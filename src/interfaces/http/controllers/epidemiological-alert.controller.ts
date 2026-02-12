import { Request, Response, NextFunction } from 'express';
import { EpidemiologicalAlertService } from '../../../application/services/epidemiological-alert.service';
import { prisma } from '../../../infrastructure/database/prisma';

const service = new EpidemiologicalAlertService();

// Default alert configuration
const DEFAULT_CONFIG = {
    diseases: [
        {
            name: 'Cholera',
            thresholds: { low: 5, medium: 10, high: 20, critical: 30 }
        },
        {
            name: 'Dengue',
            thresholds: { low: 3, medium: 7, high: 15, critical: 25 }
        },
        {
            name: 'Malaria',
            thresholds: { low: 10, medium: 20, high: 40, critical: 60 }
        },
        {
            name: 'COVID-19',
            thresholds: { low: 5, medium: 15, high: 30, critical: 50 }
        }
    ]
};

export const getAll = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const alerts = await service.getAll();
        res.json(alerts);
    } catch (error) {
        next(error);
    }
};

export const getActive = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const alerts = await service.getActive();
        res.json(alerts);
    } catch (error) {
        next(error);
    }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const alert = await service.getById(req.params.id as string);
        if (!alert) return res.status(404).json({ message: 'Alert not found' });
        res.json(alert);
    } catch (error) {
        next(error);
    }
};

export const getByZone = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const alerts = await service.getByZone(req.params.zone as string);
        res.json(alerts);
    } catch (error) {
        next(error);
    }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const alert = await service.create(req.body);
        res.status(201).json(alert);
    } catch (error) {
        next(error);
    }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const alert = await service.update(req.params.id as string, req.body);
        res.json(alert);
    } catch (error) {
        next(error);
    }
};

export const resolve = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const alert = await service.resolve(req.params.id as string);
        res.json(alert);
    } catch (error) {
        next(error);
    }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
    try {
        await service.delete(req.params.id as string);
        res.status(204).send();
    } catch (error) {
        next(error);
    }
};

export const getConfig = async (req: Request, res: Response, next: NextFunction) => {
    try {
        // In a real implementation, this would be stored in database
        // For now, return default config
        res.json({
            status: 'success',
            data: DEFAULT_CONFIG
        });
    } catch (error) {
        next(error);
    }
};

export const updateConfig = async (req: Request, res: Response, next: NextFunction) => {
    try {
        // In a real implementation, this would update database
        // For now, just validate and return
        const { diseases } = req.body;

        if (!diseases || !Array.isArray(diseases)) {
            return res.status(400).json({ message: 'Invalid config format' });
        }

        res.json({
            status: 'success',
            data: { diseases },
            message: 'Configuration updated successfully'
        });
    } catch (error) {
        next(error);
    }
};

export const updateStatus = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const { status } = req.body;

        if (!status || !['ACTIVE', 'RESOLVED'].includes(status)) {
            return res.status(400).json({ message: 'Invalid status' });
        }

        const alert = await prisma.epidemiologicalAlert.update({
            where: { id: id as string },
            data: {
                status,
                resolvedAt: status === 'RESOLVED' ? new Date() : null
            }
        });

        res.json({
            status: 'success',
            data: alert
        });
    } catch (error) {
        next(error);
    }
};
