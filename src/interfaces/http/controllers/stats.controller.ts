import { Request, Response } from 'express';
import { prisma } from '../../../infrastructure/database/prisma';
import { AppError } from '../../../utils/AppError';

export class StatsController {
    /**
     * GET /api/stats/map-data
     * Get geographic data for interactive map
     */
    async getMapData(req: Request, res: Response) {
        try {
            const { startDate, endDate, disease, zone, urgency } = req.query;

            // Build filters
            const dateFilter = startDate && endDate ? {
                createdAt: {
                    gte: new Date(startDate as string),
                    lte: new Date(endDate as string),
                }
            } : {};

            const diseaseFilter = disease ? { symptoms: { contains: disease as string } } : {};
            const urgencyFilter = urgency ? { urgency: urgency as any } : {};

            // Fetch health centers with their coordinates
            const healthCenters = await prisma.healthCenter.findMany({
                where: zone ? { address: { contains: zone as string } } : {},
                select: {
                    id: true,
                    name: true,
                    latitude: true,
                    longitude: true,
                    services: true,
                    patients: {
                        select: { id: true }
                    },
                    appointments: {
                        select: { id: true }
                    }
                }
            });

            // Fetch case reports with patient household coordinates
            const caseReports = await prisma.caseReport.findMany({
                where: {
                    ...dateFilter,
                    ...diseaseFilter,
                    ...urgencyFilter,
                },
                select: {
                    id: true,
                    urgency: true,
                    symptoms: true,
                    createdAt: true,
                    patient: {
                        select: {
                            household: {
                                select: {
                                    gpsLat: true,
                                    gpsLng: true,
                                    zone: true,
                                }
                            }
                        }
                    }
                }
            });

            // Generate heatmap data by zone from households
            const households = await prisma.household.findMany({
                where: dateFilter.createdAt ? { createdAt: dateFilter.createdAt } : {},
                select: {
                    zone: true,
                    members: {
                        select: {
                            caseReports: {
                                where: dateFilter,
                                select: {
                                    urgency: true
                                }
                            }
                        }
                    }
                }
            });

            // Aggregate heatmap data
            const zoneMap = new Map<string, { count: number; normal: number; urgent: number; critical: number }>();

            households.forEach(household => {
                const zoneName = household.zone;
                if (!zoneMap.has(zoneName)) {
                    zoneMap.set(zoneName, { count: 0, normal: 0, urgent: 0, critical: 0 });
                }

                const zoneData = zoneMap.get(zoneName)!;
                household.members.forEach(member => {
                    member.caseReports.forEach(report => {
                        zoneData.count++;
                        if (report.urgency === 'NORMAL') zoneData.normal++;
                        else if (report.urgency === 'URGENT') zoneData.urgent++;
                        else if (report.urgency === 'CRITICAL') zoneData.critical++;
                    });
                });
            });

            const heatmapData = Array.from(zoneMap.entries()).map(([zone, data]) => ({
                zone,
                count: data.count,
                urgencyBreakdown: {
                    normal: data.normal,
                    urgent: data.urgent,
                    critical: data.critical,
                }
            }));

            res.json({
                status: 'success',
                data: {
                    healthCenters: healthCenters.map(center => ({
                        id: center.id,
                        name: center.name,
                        latitude: center.latitude,
                        longitude: center.longitude,
                        type: 'HEALTH_CENTER', // Generic type
                        activeAgents: 0, // Would need User.healthCenterId to calculate
                        totalConsultations: center.appointments.length,
                    })),
                    caseReports: caseReports
                        .filter(report => report.patient?.household?.gpsLat && report.patient?.household?.gpsLng)
                        .map(report => ({
                            id: report.id,
                            latitude: report.patient!.household!.gpsLat!,
                            longitude: report.patient!.household!.gpsLng!,
                            urgency: report.urgency,
                            disease: report.symptoms.split(',')[0].trim(),
                            createdAt: report.createdAt,
                        })),
                    heatmapData,
                }
            });
        } catch (error) {
            console.error('Map data error:', error);
            throw new AppError('Failed to fetch map data', 500);
        }
    }

    /**
     * GET /api/stats/agents
     * Get global agent statistics
     */
    async getAgentStats(req: Request, res: Response) {
        try {
            const { startDate, endDate, zone } = req.query;

            const dateFilter = startDate && endDate ? {
                createdAt: {
                    gte: new Date(startDate as string),
                    lte: new Date(endDate as string),
                }
            } : {};

            // Get all agents
            const agents = await prisma.user.findMany({
                where: {
                    role: 'AGENT',
                    ...(zone ? { zone: zone as string } : {})
                },
                include: {
                    caseReportsAgent: {
                        where: dateFilter,
                        select: {
                            id: true,
                            createdAt: true,
                            urgency: true,
                        }
                    },
                    households: {
                        select: { id: true }
                    }
                }
            });

            const totalAgents = agents.length;
            const activeAgents = agents.filter(a => a.caseReportsAgent.length > 0).length;

            // Calculate average visits per day (using case reports as proxy)
            const totalVisits = agents.reduce((sum, a) => sum + a.caseReportsAgent.length, 0);
            const daysDiff = startDate && endDate
                ? Math.ceil((new Date(endDate as string).getTime() - new Date(startDate as string).getTime()) / (1000 * 60 * 60 * 24))
                : 30;
            const avgVisitsPerDay = totalVisits / (daysDiff * totalAgents || 1);

            // Mock avg response time (would need timestamps)
            const avgResponseTime = 45; // minutes

            // Get top performers
            const topPerformers = agents
                .map(agent => ({
                    id: agent.id,
                    name: agent.name,
                    visitsThisMonth: agent.caseReportsAgent.length,
                    casesResolved: agent.caseReportsAgent.filter(c => c.urgency !== 'CRITICAL').length,
                    avgResponseTime: 45, // Mock
                }))
                .sort((a, b) => b.visitsThisMonth - a.visitsThisMonth)
                .slice(0, 10);

            res.json({
                status: 'success',
                data: {
                    totalAgents,
                    activeAgents,
                    avgVisitsPerDay: Math.round(avgVisitsPerDay * 10) / 10,
                    avgResponseTime,
                    topPerformers,
                }
            });
        } catch (error) {
            console.error('Agent stats error:', error);
            throw new AppError('Failed to fetch agent statistics', 500);
        }
    }

    /**
     * GET /api/stats/agents/:id
     * Get detailed statistics for a specific agent
     */
    async getAgentDetailStats(req: Request, res: Response) {
        try {
            const { id } = req.params; const idStr = id as string;
            const { startDate, endDate } = req.query;

            const dateFilter = startDate && endDate ? {
                createdAt: {
                    gte: new Date(startDate as string),
                    lte: new Date(endDate as string),
                }
            } : {};

            const agent = await prisma.user.findUnique({
                where: { id: id as string },
                include: {
                    caseReportsAgent: {
                        where: dateFilter,
                        select: {
                            id: true,
                            createdAt: true,
                            urgency: true,
                        }
                    },
                    households: {
                        select: {
                            id: true,
                            zone: true,
                        }
                    }
                }
            });

            if (!agent) {
                throw new AppError('Agent not found', 404);
            }

            // Calculate visits by day
            const visitsByDay = agent.caseReportsAgent.reduce((acc: any[], report) => {
                const date = report.createdAt.toISOString().split('T')[0];
                const existing = acc.find(item => item.date === date);
                if (existing) {
                    existing.count++;
                } else {
                    acc.push({ date, count: 1 });
                }
                return acc;
            }, []);

            // Cases by urgency
            const casesByUrgency = {
                normal: agent.caseReportsAgent.filter(c => c.urgency === 'NORMAL').length,
                urgent: agent.caseReportsAgent.filter(c => c.urgency === 'URGENT').length,
                critical: agent.caseReportsAgent.filter(c => c.urgency === 'CRITICAL').length,
            };

            // Performance score (0-100)
            const performanceScore = Math.min(100, Math.round(
                (agent.caseReportsAgent.length * 2) +
                (agent.households.length * 5) -
                (casesByUrgency.critical * 3)
            ));

            res.json({
                status: 'success',
                data: {
                    agent: {
                        id: agent.id,
                        name: agent.name,
                        phone: agent.phone || 'N/A',
                        zone: agent.zone || 'N/A',
                    },
                    stats: {
                        totalVisits: agent.caseReportsAgent.length,
                        casesReported: agent.caseReportsAgent.length,
                        casesResolved: agent.caseReportsAgent.filter(c => c.urgency !== 'CRITICAL').length,
                        avgResponseTime: 45, // Mock
                        visitsByDay,
                        casesByUrgency,
                        performanceScore,
                    }
                }
            });
        } catch (error) {
            console.error('Agent detail stats error:', error);
            if (error instanceof AppError) throw error;
            throw new AppError('Failed to fetch agent details', 500);
        }
    }
}
