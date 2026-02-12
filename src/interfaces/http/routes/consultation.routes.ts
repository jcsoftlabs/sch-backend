import { Router } from 'express';
import { requestConsultation, getAllConsultations, getConsultationById, updateConsultationStatus } from '../controllers/consultation.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';
import { auditLog } from '../middlewares/audit.middleware';
import { validate } from '../middlewares/validate.middleware';
import { requestConsultationSchema, updateStatusSchema } from '../validators/schemas';

const router = Router();

router.use(authenticate);

router.post('/', authorize(['ADMIN', 'AGENT', 'DOCTOR']), auditLog('CREATE_CONSULTATION', 'CONSULTATION'), validate(requestConsultationSchema), requestConsultation);
router.get('/', authorize(['ADMIN', 'AGENT', 'DOCTOR']), getAllConsultations);
router.get('/:id', authorize(['ADMIN', 'AGENT', 'DOCTOR']), getConsultationById);
router.patch('/:id/status', authorize(['ADMIN', 'DOCTOR']), auditLog('UPDATE_STATUS', 'CONSULTATION'), validate(updateStatusSchema), updateConsultationStatus);

export default router;
