import { Request, Response, NextFunction } from 'express';
import { DiagnosisService } from '../../../application/services/diagnosis.service';
import { DiagnosisRepository } from '../../../infrastructure/repositories/diagnosis.repository';

const diagnosisService = new DiagnosisService(new DiagnosisRepository());

export const DiagnosisController = {
    // GET /api/diagnoses/patient/:patientId
    getByPatient: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { patientId } = req.params;
            const { active } = req.query;

            const diagnoses = active === 'true'
                ? await diagnosisService.getActiveDiagnosesByPatient(patientId as string)
                : await diagnosisService.getDiagnosesByPatient(patientId as string);

            res.json({
                status: 'success',
                data: { diagnoses },
            });
        } catch (error) {
            next(error);
        }
    },

    // GET /api/diagnoses/:id
    getById: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            const diagnosis = await diagnosisService.getDiagnosisById(id as string);

            res.json({
                status: 'success',
                data: { diagnosis },
            });
        } catch (error) {
            next(error);
        }
    },

    // POST /api/diagnoses
    create: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const diagnosis = await diagnosisService.createDiagnosis(req.body);

            res.status(201).json({
                status: 'success',
                data: { diagnosis },
            });
        } catch (error) {
            next(error);
        }
    },

    // PUT /api/diagnoses/:id
    update: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            const diagnosis = await diagnosisService.updateDiagnosis(id as string, req.body);

            res.json({
                status: 'success',
                data: { diagnosis },
            });
        } catch (error) {
            next(error);
        }
    },

    // PATCH /api/diagnoses/:id/resolve
    resolve: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            const diagnosis = await diagnosisService.resolveDiagnosis(id as string);

            res.json({
                status: 'success',
                data: { diagnosis },
            });
        } catch (error) {
            next(error);
        }
    },

    // DELETE /api/diagnoses/:id
    delete: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            await diagnosisService.deleteDiagnosis(id as string);

            res.status(204).send();
        } catch (error) {
            next(error);
        }
    },

    // GET /api/diagnoses/search?disease=malaria
    search: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { disease } = req.query;

            if (!disease || typeof disease !== 'string') {
                return res.status(400).json({
                    status: 'error',
                    message: 'Disease parameter is required',
                });
            }

            const diagnoses = await diagnosisService.searchByDisease(disease);

            res.json({
                status: 'success',
                data: { diagnoses },
            });
        } catch (error) {
            next(error);
        }
    },
};
