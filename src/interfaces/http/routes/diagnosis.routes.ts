import { Router } from 'express';
import { DiagnosisController } from '../controllers/diagnosis.controller';
import { authenticate } from '../middlewares/auth.middleware';

const router = Router();

// All routes require authentication
router.use(authenticate);

// Search diagnoses by disease
router.get('/search', DiagnosisController.search);

// Get diagnoses by patient
router.get('/patient/:patientId', DiagnosisController.getByPatient);

// Get single diagnosis
router.get('/:id', DiagnosisController.getById);

// Create diagnosis
router.post('/', DiagnosisController.create);

// Update diagnosis
router.put('/:id', DiagnosisController.update);

// Resolve diagnosis
router.patch('/:id/resolve', DiagnosisController.resolve);

// Delete diagnosis
router.delete('/:id', DiagnosisController.delete);

export default router;
