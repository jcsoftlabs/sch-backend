import { Request, Response, NextFunction } from 'express';
import { EpidemiologicalAlertService } from '../../../application/services/epidemiological-alert.service';
import { prisma } from '../../../infrastructure/database/prisma';

const service = new EpidemiologicalAlertService();



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
        const alert = await service.getById(req.params.id as string as string);
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
        const alert = await service.update(req.params.id as string as string, req.body);
        res.json(alert);
    } catch (error) {
        next(error);
    }
};

export const resolve = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const alert = await service.resolve(req.params.id as string as string);
        res.json(alert);
    } catch (error) {
        next(error);
    }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
    try {
        await service.delete(req.params.id as string as string);
        res.status(204).send();
    } catch (error) {
        next(error);
    }
};

export const getConfig = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const config = await service.getConfig();
        res.json({
            status: 'success',
            data: config
        });
    } catch (error) {
        next(error);
    }
};

export const updateConfig = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const userId = (req as any).user?.id;
        const config = req.body;

        if (!config.diseases || !Array.isArray(config.diseases)) {
            return res.status(400).json({ message: 'Invalid config format' });
        }

        await service.updateConfig(config, userId);

        res.json({
            status: 'success',
            data: config,
            message: 'Configuration updated successfully'
        });
    } catch (error) {
        next(error);
    }
};

export const updateStatus = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params; const idStr = id as string;
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
