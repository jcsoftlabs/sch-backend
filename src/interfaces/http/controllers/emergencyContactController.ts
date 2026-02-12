import { Request, Response, NextFunction } from 'express';
import { EmergencyContactService } from '../../../application/services/emergencyContactService';
import { EmergencyContactRepository } from '../../../infrastructure/repositories/emergencyContactRepository';

const contactService = new EmergencyContactService(new EmergencyContactRepository());

export const EmergencyContactController = {
    // GET /api/emergency-contacts/patient/:patientId
    getByPatient: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { patientId } = req.params;
            const contacts = await contactService.getContactsByPatient(patientId as string);

            res.json({
                status: 'success',
                data: { contacts },
            });
        } catch (error) {
            next(error);
        }
    },

    // GET /api/emergency-contacts/patient/:patientId/primary
    getPrimary: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { patientId } = req.params;
            const contact = await contactService.getPrimaryContact(patientId as string);

            res.json({
                status: 'success',
                data: { contact },
            });
        } catch (error) {
            next(error);
        }
    },

    // GET /api/emergency-contacts/:id
    getById: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            const contact = await contactService.getContactById(id as string);

            res.json({
                status: 'success',
                data: { contact },
            });
        } catch (error) {
            next(error);
        }
    },

    // POST /api/emergency-contacts
    create: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const contact = await contactService.createContact(req.body);

            res.status(201).json({
                status: 'success',
                data: { contact },
            });
        } catch (error) {
            next(error);
        }
    },

    // PUT /api/emergency-contacts/:id
    update: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            const contact = await contactService.updateContact(id as string, req.body);

            res.json({
                status: 'success',
                data: { contact },
            });
        } catch (error) {
            next(error);
        }
    },

    // PATCH /api/emergency-contacts/:id/primary
    setPrimary: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            const contact = await contactService.setPrimaryContact(id as string);

            res.json({
                status: 'success',
                data: { contact },
            });
        } catch (error) {
            next(error);
        }
    },

    // DELETE /api/emergency-contacts/:id
    delete: async (req: Request, res: Response, next: NextFunction) => {
        try {
            const { id } = req.params; const idStr = id as string;
            await contactService.deleteContact(id as string);

            res.status(204).send();
        } catch (error) {
            next(error);
        }
    },
};
