import { Request, Response, NextFunction } from 'express';
import { HealthCenterService } from '../../../application/services/health-center.service';
import { HealthCenterRepository } from '../../../infrastructure/repositories/health-center.repository';

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
        const id = req.params.id as string;
        const healthCenter = await healthCenterService.getHealthCenterById(id);
        res.status(200).json({ status: 'success', data: { healthCenter } });
    } catch (error) {
        next(error);
    }
};

export const updateHealthCenter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id as string;
        const healthCenter = await healthCenterService.updateHealthCenter(id, req.body);
        res.status(200).json({ status: 'success', data: { healthCenter } });
    } catch (error) {
        next(error);
    }
};

export const deleteHealthCenter = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id as string;
        await healthCenterService.deleteHealthCenter(id);
        res.status(204).json({ status: 'success', data: null });
    } catch (error) {
        next(error);
    }
};
