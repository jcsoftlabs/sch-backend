import { Request, Response, NextFunction } from 'express';
import { VitalSignService } from '../../../application/services/vital-sign.service';
import { VitalSignRepository } from '../../../infrastructure/repositories/vital-sign.repository';

const repo = new VitalSignRepository();
const service = new VitalSignService(repo);

export const create = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const vitalSign = await service.createVitalSign(req.params.patientId as string, req.body);
        res.status(201).json({ status: 'success', data: { vitalSign } });
    } catch (error) { next(error); }
};

export const getByPatient = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const vitalSigns = await service.getVitalSignsByPatient(req.params.patientId as string);
        res.status(200).json({ status: 'success', data: { vitalSigns } });
    } catch (error) { next(error); }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
    try {
        await service.deleteVitalSign(req.params.id as string);
        res.status(204).send();
    } catch (error) { next(error); }
};
