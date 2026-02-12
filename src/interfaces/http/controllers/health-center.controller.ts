import { Request, Response, NextFunction } from 'express';
import { HealthCenterService } from '../../../application/services/health-center.service';
import { HealthCenterRepository } from '../../../infrastructure/repositories/health-center.repository';
import { prisma } from '../../../infrastructure/database/prisma';
import { AppError } from '../../../utils/AppError';

const healthCenterRepository = new HealthCenterRepository();
const healthCenterService = new HealthCenterService(healthCenterRepository);

export const createHealthCenter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const healthCenter = await healthCenterService.createHealthCenter(req.body);
        res.status(201).json({ status: 'success', data: { healthCenter } });
    } catch (error) {
        next(error);
    }
};

export const getAllHealthCenters = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const healthCenters = await healthCenterService.getAllHealthCenters();
        res.status(200).json({ status: 'success', data: { healthCenters } });
    } catch (error) {
        next(error);
    }
};

export const getHealthCenterById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id as string as string;
        const healthCenter = await healthCenterService.getHealthCenterById(id as string);
        res.status(200).json({ status: 'success', data: { healthCenter } });
    } catch (error) {
        next(error);
    }
};

export const updateHealthCenter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id as string as string;
        const healthCenter = await healthCenterService.updateHealthCenter(id as string, req.body);
        res.status(200).json({ status: 'success', data: { healthCenter } });
    } catch (error) {
        next(error);
    }
};

export const deleteHealthCenter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id as string as string;
        await healthCenterService.deleteHealthCenter(id as string);
        res.status(204).json({ status: 'success', data: null });
    } catch (error) {
        next(error);
    }
};

/**
 * GET /api/health-centers/directory
 * Get complete directory of health centers with detailed information
 */
export const getDirectory = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { zone, services, sortBy } = req.query;

        // Build filters
        const where: any = {};

        if (zone) {
            where.address = { contains: zone as string };
        }

        if (services) {
            where.services = { contains: services as string };
        }

        // Fetch health centers with statistics
        const healthCenters = await prisma.healthCenter.findMany({
            where,
            include: {
                patients: {
                    select: { id: true }
                },
                appointments: {
                    select: {
                        id: true,
                        status: true
                    }
                }
            },
            orderBy: sortBy === 'name' ? { name: 'asc' } : { createdAt: 'desc' }
        });

        // Format directory entries
        const directory = healthCenters.map(center => ({
            id: center.id,
            name: center.name,
            address: center.address,
            phone: center.phone || 'N/A',
            coordinates: {
                latitude: center.latitude,
                longitude: center.longitude
            },
            services: center.services ? center.services.split(',').map(s => s.trim()) : [],
            capacity: center.capacity || 0,
            statistics: {
                totalPatients: center.patients.length,
                totalAppointments: center.appointments.length,
                activeAppointments: center.appointments.filter(a =>
                    a.status === 'SCHEDULED' || a.status === 'CONFIRMED'
                ).length
            },
            createdAt: center.createdAt,
            updatedAt: center.updatedAt
        }));

        res.json({
            status: 'success',
            data: {
                total: directory.length,
                directory
            }
        });
    } catch (error) {
        console.error('Directory error:', error);
        next(error);
    }
};

/**
 * POST /api/sms/directory/search
 * Search health centers via SMS (webhook for Vonage)
 * Expected SMS format: "CENTRE [zone/nom]"
 */
export const searchBySMS = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { from, text, messageId } = req.body;

        if (!from || !text) {
            throw new AppError('Missing required fields: from, text', 400);
        }

        // Log SMS message
        await prisma.sMSMessage.create({
            data: {
                from: from,
                to: process.env.VONAGE_FROM_NUMBER || '+50937000000',
                content: text,
                direction: 'INBOUND',
                status: 'DELIVERED',
                messageId: messageId || `MSG-${Date.now()}`
            }
        });

        // Parse search query
        const searchText = text.trim().toUpperCase();
        const searchQuery = searchText.replace(/^CENTRE\s+/i, '').trim();

        if (!searchQuery) {
            return res.json({
                status: 'success',
                message: 'Format: CENTRE [zone/nom]\nExemple: CENTRE Port-au-Prince'
            });
        }

        // Search health centers
        const healthCenters = await prisma.healthCenter.findMany({
            where: {
                OR: [
                    { name: { contains: searchQuery, mode: 'insensitive' } },
                    { address: { contains: searchQuery, mode: 'insensitive' } }
                ]
            },
            take: 5, // Limit to 5 results for SMS
            select: {
                name: true,
                address: true,
                phone: true,
                services: true
            }
        });

        // Format SMS response
        let responseMessage = '';

        if (healthCenters.length === 0) {
            responseMessage = `Aucun centre trouvé pour "${searchQuery}". Essayez un autre terme.`;
        } else {
            responseMessage = `${healthCenters.length} centre(s) trouvé(s):\n\n`;
            healthCenters.forEach((center, index) => {
                responseMessage += `${index + 1}. ${center.name}\n`;
                responseMessage += `   ${center.address}\n`;
                if (center.phone) {
                    responseMessage += `   Tel: ${center.phone}\n`;
                }
                responseMessage += '\n';
            });
            responseMessage += 'Pour plus d\'infos, appelez le centre directement.';
        }

        // Send SMS response (via Vonage)
        // This would integrate with your existing SMS service
        // For now, we'll just return the response

        res.json({
            status: 'success',
            data: {
                from,
                searchQuery,
                resultsCount: healthCenters.length,
                responseMessage
            }
        });
    } catch (error) {
        console.error('SMS search error:', error);
        next(error);
    }
};
