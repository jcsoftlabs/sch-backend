import { Router } from 'express';
import { EmergencyContactController } from '../controllers/emergency-contact.controller';
import { authenticate } from '../middlewares/auth.middleware';

const router = Router();

// All routes require authentication
router.use(authenticate);

// Get contacts by patient
router.get('/patient/:patientId', EmergencyContactController.getByPatient);

// Get primary contact
router.get('/patient/:patientId/primary', EmergencyContactController.getPrimary);

// Get single contact
router.get('/:id', EmergencyContactController.getById);

// Create contact
router.post('/', EmergencyContactController.create);

// Update contact
router.put('/:id', EmergencyContactController.update);

// Set as primary contact
router.patch('/:id/primary', EmergencyContactController.setPrimary);

// Delete contact
router.delete('/:id', EmergencyContactController.delete);

export default router;
