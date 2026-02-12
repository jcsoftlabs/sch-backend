import { Router } from 'express';
import { PrescriptionController } from '../controllers/prescription.controller';
import { authenticate } from '../middlewares/auth.middleware';

const router = Router();

// All routes require authentication
router.use(authenticate);

// Get prescriptions by patient
router.get('/patient/:patientId', PrescriptionController.getByPatient);

// Get single prescription
router.get('/:id', PrescriptionController.getById);

// Create prescription
router.post('/', PrescriptionController.create);

// Update prescription
router.put('/:id', PrescriptionController.update);

// Update prescription status
router.patch('/:id/status', PrescriptionController.updateStatus);

// Delete prescription
router.delete('/:id', PrescriptionController.delete);

// Mark expired prescriptions (admin/cron job)
router.post('/mark-expired', PrescriptionController.markExpired);

export default router;
