import { Request, Response, NextFunction } from 'express';
import { ConsultationService } from '../../../application/services/consultation.service';
import { ConsultationRepository } from '../../../infrastructure/repositories/consultation.repository';
import { MockNotificationService } from '../../../infrastructure/services/notification.service';
import { AuthRequest } from '../middlewares/auth.middleware';

const consultationRepository = new ConsultationRepository();
const notificationService = new MockNotificationService();
const consultationService = new ConsultationService(consultationRepository, notificationService);

export const requestConsultation = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { patientId, notes } = req.body;
        const consultation = await consultationService.requestConsultation(patientId as string, notes);
        res.status(201).json({ status: 'success', data: { consultation } });
    } catch (error) {
        next(error);
    }
};

export const getAllConsultations = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const consultations = await consultationService.getAllConsultations();
        res.status(200).json({ status: 'success', data: { consultations } });
    } catch (error) {
        next(error);
    }
};

export const getConsultationById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id as string as string;
        const consultation = await consultationService.getConsultationById(id as string);
        res.status(200).json({ status: 'success', data: { consultation } });
    } catch (error) {
        next(error);
    }
};

export const updateConsultationStatus = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const id = req.params.id as string as string;
        const { status } = req.body;

        // If doctor accepts, assign them
        // For simplicity, using the authenticated user id if role is DOCTOR
        const user = (req as AuthRequest).user;
        const doctorId = user?.role === 'DOCTOR' ? user.id : undefined;

        const consultation = await consultationService.updateStatus(id as string, status, doctorId);
        res.status(200).json({ status: 'success', data: { consultation } });
    } catch (error) {
        next(error);
    }
};
