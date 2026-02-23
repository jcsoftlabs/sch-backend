import { Request, Response, NextFunction } from 'express';
import { NutritionService } from '../../../application/services/nutrition.service';
import { NutritionRepository } from '../../../infrastructure/repositories/nutrition.repository';

const repo = new NutritionRepository();
const service = new NutritionService(repo);

export const create = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const record = await service.createNutritionRecord(req.body);
        res.status(201).json({ status: 'success', data: { nutritionRecord: record } });
    } catch (error) { next(error); }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const record = await service.getNutritionRecordById(req.params.id as string);
        res.status(200).json({ status: 'success', data: { nutritionRecord: record } });
    } catch (error) { next(error); }
};

export const getByPatient = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const records = await service.getNutritionRecordsByPatient(req.params.patientId as string);
        res.status(200).json({ status: 'success', data: { nutritionRecords: records } });
    } catch (error) { next(error); }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const record = await service.updateNutritionRecord(req.params.id as string, req.body);
        res.status(200).json({ status: 'success', data: { nutritionRecord: record } });
    } catch (error) { next(error); }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
    try {
        await service.deleteNutritionRecord(req.params.id as string);
        res.status(204).send();
    } catch (error) { next(error); }
};
