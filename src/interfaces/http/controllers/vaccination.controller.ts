import { Request, Response, NextFunction } from 'express';
import { VaccinationService } from '../../../application/services/vaccination.service';
import { VaccinationRepository } from '../../../infrastructure/repositories/vaccination.repository';

const repo = new VaccinationRepository();
const service = new VaccinationService(repo);

export const getAll = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const vaccinations = await service.getAllVaccinations();
        res.status(200).json({ status: 'success', data: { vaccinations } });
    } catch (error) { next(error); }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const vaccination = await service.getVaccinationById(req.params.id as string as string);
        res.status(200).json({ status: 'success', data: { vaccination } });
    } catch (error) { next(error); }
};

export const getByPatient = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const vaccinations = await service.getVaccinationsByPatient(req.params.patientId as string);
        res.status(200).json({ status: 'success', data: { vaccinations } });
    } catch (error) { next(error); }
};

export const getDue = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const vaccinations = await service.getDueVaccinations();
        res.status(200).json({ status: 'success', data: { vaccinations } });
    } catch (error) { next(error); }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const vaccination = await service.createVaccination(req.body);
        res.status(201).json({ status: 'success', data: { vaccination } });
    } catch (error) { next(error); }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const vaccination = await service.updateVaccination(req.params.id as string as string, req.body);
        res.status(200).json({ status: 'success', data: { vaccination } });
    } catch (error) { next(error); }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
    try {
        await service.deleteVaccination(req.params.id as string as string);
        res.status(204).send();
    } catch (error) { next(error); }
};
