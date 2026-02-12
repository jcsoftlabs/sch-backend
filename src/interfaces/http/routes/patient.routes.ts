import { Router } from 'express';
import { createPatient, getAllPatients, getPatientById, updatePatient, deletePatient } from '../controllers/patient.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createPatientSchema } from '../validators/schemas';

const router = Router();

router.use(authenticate); // Protect all routes

router.post('/', authorize(['ADMIN', 'AGENT', 'DOCTOR']), validate(createPatientSchema), createPatient);
router.get('/', authorize(['ADMIN', 'AGENT', 'DOCTOR']), getAllPatients);
router.get('/:id', authorize(['ADMIN', 'AGENT', 'DOCTOR']), getPatientById);
router.put('/:id', authorize(['ADMIN', 'AGENT']), updatePatient); // Only Admin and Agent can update
router.delete('/:id', authorize(['ADMIN']), deletePatient); // Only Admin can delete

export default router;
