import { Request, Response, NextFunction } from 'express';
import { PrescriptionService } from '../../../application/services/prescriptionService';
import { PrescriptionRepository } from '../../../infrastructure/repositories/prescriptionRepository';

const prescriptionService = new PrescriptionService(new PrescriptionRepository());

export const PrescriptionController = {
    // GET /api/prescriptions/patient/:patientId
    getByPatient: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { patientId } = req.params;
            const { active } = req.query;

            const prescriptions = active === 'true'
                ? await prescriptionService.getActivePrescriptionsByPatient(patientId as string)
                : await prescriptionService.getPrescriptionsByPatient(patientId as string);

            res.json({
                status: 'success',
                data: { prescriptions },
            });
        } catch (error) {
            next(error);
        }
    },

    // GET /api/prescriptions/:id
    getById: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            const prescription = await prescriptionService.getPrescriptionById(id as string);

            res.json({
                status: 'success',
                data: { prescription },
            });
        } catch (error) {
            next(error);
        }
    },

    // POST /api/prescriptions
    create: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const prescription = await prescriptionService.createPrescription(req.body);

            res.status(201).json({
                status: 'success',
                data: { prescription },
            });
        } catch (error) {
            next(error);
        }
    },

    // PUT /api/prescriptions/:id
    update: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            const prescription = await prescriptionService.updatePrescription(id as string, req.body);

            res.json({
                status: 'success',
                data: { prescription },
            });
        } catch (error) {
            next(error);
        }
    },

    // PATCH /api/prescriptions/:id/status
    updateStatus: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            const { status } = req.body;

            const prescription = await prescriptionService.updatePrescriptionStatus(id as string, status);

            res.json({
                status: 'success',
                data: { prescription },
            });
        } catch (error) {
            next(error);
        }
    },

    // DELETE /api/prescriptions/:id
    delete: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            await prescriptionService.deletePrescription(id as string);

            res.status(204).send();
        } catch (error) {
            next(error);
        }
    },

    // POST /api/prescriptions/mark-expired
    markExpired: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const count = await prescriptionService.markExpiredPrescriptions();

            res.json({
                status: 'success',
                data: { markedCount: count },
            });
        } catch (error) {
            next(error);
        }
    },
};
