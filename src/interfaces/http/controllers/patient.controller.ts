import { Request, Response, NextFunction } from 'express';
import { PatientService } from '../../../application/services/patient.service';
import { PatientRepository } from '../../../infrastructure/repositories/patient.repository';

const patientRepository = new PatientRepository();
const patientService = new PatientService(patientRepository);

export const createPatient = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const patient = await patientService.createPatient(req.body);
        res.status(201).json({ status: 'success', data: { patient } });
    } catch (error) {
        next(error);
    }
};

export const getAllPatients = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const patients = await patientService.getAllPatients();
        res.status(200).json({ status: 'success', data: { patients } });
    } catch (error) {
        next(error);
    }
};

export const getPatientById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const patientId = req.params.id as string as string;
        const patient = await patientService.getPatientById(patientId as string);
        res.status(200).json({ status: 'success', data: { patient } });
    } catch (error) {
        next(error);
    }
};

export const updatePatient = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const patientId = req.params.id as string as string;
        const patient = await patientService.updatePatient(patientId as string, req.body);
        res.status(200).json({ status: 'success', data: { patient } });
    } catch (error) {
        next(error);
    }
};

export const deletePatient = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const patientId = req.params.id as string as string;
        await patientService.deletePatient(patientId as string);
        res.status(204).json({ status: 'success', data: null });
    } catch (error) {
        next(error);
    }
};
