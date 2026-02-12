import { Request, Response, NextFunction } from 'express';
import { LabResultService } from '../../application/services/lab-result.service';
import { LabResultRepository } from '../../infrastructure/repositories/lab-result.repository';
import { LabTestType } from '@prisma/client';

const labResultService = new LabResultService(new LabResultRepository());

export const LabResultController = {
    // GET /api/lab-results/patient/:patientId
    getByPatient: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { patientId } = req.params;
            const { testType, abnormal } = req.query;

            let results;

            if (abnormal === 'true') {
                results = await labResultService.getAbnormalResults(patientId);
            } else if (testType && typeof testType === 'string') {
                results = await labResultService.getResultsByPatientAndType(
                    patientId,
                    testType as LabTestType
                );
            } else {
                results = await labResultService.getResultsByPatient(patientId);
            }

            res.json({
                status: 'success',
                data: { results },
            });
        } catch (error) {
            next(error);
        }
    },

    // GET /api/lab-results/:id
    getById: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params;
            const result = await labResultService.getResultById(id);

            res.json({
                status: 'success',
                data: { result },
            });
        } catch (error) {
            next(error);
        }
    },

    // POST /api/lab-results
    create: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const result = await labResultService.createLabResult(req.body);

            res.status(201).json({
                status: 'success',
                data: { result },
            });
        } catch (error) {
            next(error);
        }
    },

    // PUT /api/lab-results/:id
    update: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params;
            const result = await labResultService.updateLabResult(id, req.body);

            res.json({
                status: 'success',
                data: { result },
            });
        } catch (error) {
            next(error);
        }
    },

    // DELETE /api/lab-results/:id
    delete: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params;
            await labResultService.deleteLabResult(id);

            res.status(204).send();
        } catch (error) {
            next(error);
        }
    },

    // GET /api/lab-results/recent/:testType?limit=10
    getRecentByType: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { testType } = req.params;
            const limit = req.query.limit ? parseInt(req.query.limit as string) : 10;

            const results = await labResultService.getRecentResultsByType(
                testType as LabTestType,
                limit
            );

            res.json({
                status: 'success',
                data: { results },
            });
        } catch (error) {
            next(error);
        }
    },
};
