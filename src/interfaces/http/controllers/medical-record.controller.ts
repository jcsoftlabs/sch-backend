import { Request, Response, NextFunction } from 'express';
import { MedicalRecordService } from '../../../application/services/medical-record.service';
import { MedicalRecordRepository } from '../../../infrastructure/repositories/medical-record.repository';

const repo = new MedicalRecordRepository();
const service = new MedicalRecordService(repo);

export const getById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const record = await service.getRecordById(req.params.id as string as string);
        res.status(200).json({ status: 'success', data: { medicalRecord: record } });
    } catch (error) { next(error); }
};

export const getByPatient = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const record = await service.getRecordByPatientId(req.params.patientId as string);
        res.status(200).json({ status: 'success', data: { medicalRecord: record } });
    } catch (error) { next(error); }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const record = await service.createRecord(req.body);
        res.status(201).json({ status: 'success', data: { medicalRecord: record } });
    } catch (error) { next(error); }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const record = await service.updateRecord(req.params.id as string as string, req.body);
        res.status(200).json({ status: 'success', data: { medicalRecord: record } });
    } catch (error) { next(error); }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
    try {
        await service.deleteRecord(req.params.id as string as string);
        res.status(204).send();
    } catch (error) { next(error); }
};
