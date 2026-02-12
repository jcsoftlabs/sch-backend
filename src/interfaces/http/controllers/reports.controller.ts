import { Request, Response } from 'express';
import { prisma } from '../../../infrastructure/database/prisma';
import { AppError } from '../../../utils/AppError';

export class ReportsController {
    /**
     * GET /api/reports/templates
     * Get available report templates
     */
    async getTemplates(req: Request, res: Response) {
        try {
            const templates = [
                {
                    id: 'weekly',
                    name: 'Rapport Hebdomadaire',
                    description: 'Statistiques des 7 derniers jours',
                    frequency: 'WEEKLY',
                    metrics: ['consultations', 'caseReports', 'vaccinations']
                },
                {
                    id: 'monthly',
                    name: 'Rapport Mensuel',
                    description: 'Statistiques mensuelles complètes',
                    frequency: 'MONTHLY',
                    metrics: ['consultations', 'caseReports', 'vaccinations', 'maternalCare']
                },
                {
                    id: 'quarterly',
                    name: 'Rapport Trimestriel',
                    description: 'Vue d\'ensemble trimestrielle',
                    frequency: 'QUARTERLY',
                    metrics: ['consultations', 'caseReports', 'vaccinations', 'maternalCare', 'nutrition']
                }
            ];

            res.json({
                status: 'success',
                data: templates
            });
        } catch (error) {
            console.error('Templates error:', error);
            throw new AppError('Failed to fetch report templates', 500);
        }
    }

    /**
     * POST /api/reports/generate
     * Generate a report in PDF or CSV format
     */
    async generateReport(req: Request, res: Response) {
        try {
            const { templateId, startDate, endDate, zone, format } = req.body;

            if (!templateId || !startDate || !endDate || !format) {
                throw new AppError('Missing required fields', 400);
            }

            if (!['PDF', 'CSV'].includes(format)) {
                throw new AppError('Invalid format. Must be PDF or CSV', 400);
            }

            const dateFilter = {
                createdAt: {
                    gte: new Date(startDate),
                    lte: new Date(endDate),
                }
            };

            // Fetch data based on template
            const [consultations, caseReports, patients] = await Promise.all([
                prisma.consultation.findMany({
                    where: dateFilter,
                    include: {
                        patient: {
                            select: {
                                firstName: true,
                                lastName: true,
                                household: {
                                    select: { zone: true }
                                }
                            }
                        },
                        doctor: {
                            select: {
                                name: true,
                                zone: true
                            }
                        }
                    }
                }),
                prisma.caseReport.findMany({
                    where: dateFilter,
                    include: {
                        agent: {
                            select: {
                                name: true,
                                zone: true
                            }
                        },
                        patient: {
                            select: {
                                firstName: true,
                                lastName: true,
                                household: {
                                    select: { zone: true }
                                }
                            }
                        }
                    }
                }),
                prisma.patient.findMany({
                    where: dateFilter,
                    select: {
                        id: true,
                        firstName: true,
                        lastName: true,
                        household: {
                            select: { zone: true }
                        }
                    }
                })
            ]);

            // Filter by zone if specified
            const filteredConsultations = zone
                ? consultations.filter(c => c.doctor?.zone === zone || c.patient?.household?.zone === zone)
                : consultations;

            const filteredCaseReports = zone
                ? caseReports.filter(c => c.agent.zone === zone || c.patient?.household?.zone === zone)
                : caseReports;

            const filteredPatients = zone
                ? patients.filter(p => p.household?.zone === zone)
                : patients;

            // Mock report generation (in production, use jspdf or csv library)
            const reportId = `RPT-${Date.now()}`;
            const downloadUrl = `/api/reports/download/${reportId}.${format.toLowerCase()}`;

            res.json({
                status: 'success',
                data: {
                    reportId,
                    downloadUrl,
                    summary: {
                        totalConsultations: filteredConsultations.length,
                        totalCaseReports: filteredCaseReports.length,
                        totalPatients: filteredPatients.length,
                        period: { startDate, endDate },
                        zone: zone || 'ALL'
                    }
                }
            });
        } catch (error) {
            console.error('Report generation error:', error);
            if (error instanceof AppError) throw error;
            throw new AppError('Failed to generate report', 500);
        }
    }

    /**
     * GET /api/reports/export/raw
     * Export raw data as CSV
     */
    async exportRawData(req: Request, res: Response) {
        try {
            const { entity, startDate, endDate, zone } = req.query;

            if (!entity || !['consultation', 'caseReport', 'patient'].includes(entity as string)) {
                throw new AppError('Invalid entity. Must be consultation, caseReport, or patient', 400);
            }

            const dateFilter = startDate && endDate ? {
                createdAt: {
                    gte: new Date(startDate as string),
                    lte: new Date(endDate as string),
                }
            } : {};

            let data: any[] = [];

            switch (entity) {
                case 'consultation':
                    data = await prisma.consultation.findMany({
                        where: dateFilter,
                        include: {
                            patient: {
                                select: {
                                    firstName: true,
                                    lastName: true,
                                    household: {
                                        select: { zone: true }
                                    }
                                }
                            },
                            doctor: {
                                select: {
                                    name: true,
                                    zone: true
                                }
                            }
                        }
                    });
                    break;

                case 'caseReport':
                    data = await prisma.caseReport.findMany({
                        where: dateFilter,
                        include: {
                            agent: {
                                select: {
                                    name: true,
                                    zone: true
                                }
                            },
                            patient: {
                                select: {
                                    firstName: true,
                                    lastName: true,
                                    household: {
                                        select: { zone: true }
                                    }
                                }
                            }
                        }
                    });
                    break;

                case 'patient':
                    data = await prisma.patient.findMany({
                        where: dateFilter,
                        include: {
                            household: {
                                select: { zone: true }
                            }
                        }
                    });
                    break;
            }

            // Filter by zone if specified
            if (zone) {
                data = data.filter((item: any) => {
                    if (item.agent?.zone === zone) return true;
                    if (item.doctor?.zone === zone) return true;
                    if (item.patient?.household?.zone === zone) return true;
                    if (item.household?.zone === zone) return true;
                    return false;
                });
            }

            // Mock CSV generation (in production, use papaparse or csv-writer)
            const csvId = `CSV-${Date.now()}`;
            const downloadUrl = `/api/reports/download/${csvId}.csv`;

            res.json({
                status: 'success',
                data: {
                    csvId,
                    downloadUrl,
                    recordCount: data.length,
                    entity,
                }
            });
        } catch (error) {
            console.error('Export error:', error);
            if (error instanceof AppError) throw error;
            throw new AppError('Failed to export data', 500);
        }
    }

    /**
     * GET /api/reports/epidemiology
     * Get epidemiological statistics by zone
     */
    async getEpidemiologyStats(req: Request, res: Response) {
        try {
            const { startDate, endDate } = req.query;

            const dateFilter = startDate && endDate ? {
                createdAt: {
                    gte: new Date(startDate as string),
                    lte: new Date(endDate as string),
                }
            } : {};

            // Get all households with their case reports
            const households = await prisma.household.findMany({
                select: {
                    zone: true,
                    members: {
                        select: {
                            caseReports: {
                                where: dateFilter,
                                select: {
                                    symptoms: true,
                                    urgency: true,
                                    createdAt: true,
                                }
                            }
                        }
                    }
                }
            });

            // Aggregate by zone
            const zoneStats = new Map<string, {
                totalCases: number;
                diseaseBreakdown: Map<string, number>;
                urgencyBreakdown: { normal: number; urgent: number; critical: number };
            }>();

            households.forEach(household => {
                const zone = household.zone;
                if (!zoneStats.has(zone)) {
                    zoneStats.set(zone, {
                        totalCases: 0,
                        diseaseBreakdown: new Map(),
                        urgencyBreakdown: { normal: 0, urgent: 0, critical: 0 }
                    });
                }

                const stats = zoneStats.get(zone)!;
                household.members.forEach(member => {
                    member.caseReports.forEach(report => {
                        stats.totalCases++;

                        // Extract disease from symptoms
                        const disease = report.symptoms.split(',')[0].trim();
                        stats.diseaseBreakdown.set(
                            disease,
                            (stats.diseaseBreakdown.get(disease) || 0) + 1
                        );

                        // Count urgency
                        if (report.urgency === 'NORMAL') stats.urgencyBreakdown.normal++;
                        else if (report.urgency === 'URGENT') stats.urgencyBreakdown.urgent++;
                        else if (report.urgency === 'CRITICAL') stats.urgencyBreakdown.critical++;
                    });
                });
            });

            // Format response
            const zoneData = Array.from(zoneStats.entries()).map(([zone, stats]) => ({
                zone,
                totalCases: stats.totalCases,
                diseaseBreakdown: Array.from(stats.diseaseBreakdown.entries()).map(([disease, count]) => ({
                    disease,
                    count,
                    percentage: Math.round((count / stats.totalCases) * 100)
                })),
                urgencyBreakdown: stats.urgencyBreakdown,
                trend: stats.totalCases > 50 ? 'INCREASING' : stats.totalCases > 20 ? 'STABLE' : 'DECREASING'
            }));

            res.json({
                status: 'success',
                data: zoneData
            });
        } catch (error) {
            console.error('Epidemiology stats error:', error);
            throw new AppError('Failed to fetch epidemiology statistics', 500);
        }
    }
}
