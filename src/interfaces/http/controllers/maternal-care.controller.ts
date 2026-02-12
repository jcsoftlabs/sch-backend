import { Request, Response, NextFunction } from 'express';
import { MaternalCareService } from '../../../application/services/maternal-care.service';
import { MaternalCareRepository } from '../../../infrastructure/repositories/maternal-care.repository';

const repo = new MaternalCareRepository();
const service = new MaternalCareService(repo);

export const getAll = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const records = await service.getAllMaternalCares();
        res.status(200).json({ status: 'success', data: { maternalCares: records } });
    } catch (error) { next(error); }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const record = await service.getMaternalCareById(req.params.id as string as string);
        res.status(200).json({ status: 'success', data: { maternalCare: record } });
    } catch (error) { next(error); }
};

export const getByPatient = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const records = await service.getMaternalCareByPatient(req.params.patientId as string);
        res.status(200).json({ status: 'success', data: { maternalCares: records } });
    } catch (error) { next(error); }
};

export const getHighRisk = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const records = await service.getHighRiskPregnancies();
        res.status(200).json({ status: 'success', data: { maternalCares: records } });
    } catch (error) { next(error); }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const record = await service.createMaternalCare(req.body);
        res.status(201).json({ status: 'success', data: { maternalCare: record } });
    } catch (error) { next(error); }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const record = await service.updateMaternalCare(req.params.id as string as string, req.body);
        res.status(200).json({ status: 'success', data: { maternalCare: record } });
    } catch (error) { next(error); }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
    try {
        await service.deleteMaternalCare(req.params.id as string as string);
        res.status(204).send();
    } catch (error) { next(error); }
};
