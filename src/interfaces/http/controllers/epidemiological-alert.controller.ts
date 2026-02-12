import { Request, Response, NextFunction } from 'express';
import { EpidemiologicalAlertService } from '../../../application/services/epidemiological-alert.service';

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
