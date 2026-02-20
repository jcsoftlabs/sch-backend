import { Router } from 'express';
import { LabResultController } from '../controllers/lab-result.controller';
import { authenticate } from '../middlewares/auth.middleware';

const router = Router();

// All routes require authentication
router.use(authenticate);

// Get recent results by test type
router.get('/recent/:testType', LabResultController.getRecentByType);

// Get results by patient
router.get('/patient/:patientId', LabResultController.getByPatient);

// Get single result
router.get('/:id', LabResultController.getById);

// Create lab result
router.post('/', LabResultController.create);

// Update lab result
router.put('/:id', LabResultController.update);

// Delete lab result
router.delete('/:id', LabResultController.delete);

export default router;
