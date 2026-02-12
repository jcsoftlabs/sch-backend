import { Router } from 'express';
import * as ctrl from '../controllers/sms.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { sendSMSSchema } from '../validators/sms.validator';

const router = Router();

// Send SMS (authenticated, ADMIN/DOCTOR/AGENT)
router.post(
    '/send',
    authenticate,
    authorize(['ADMIN', 'DOCTOR', 'AGENT']),
    validate(sendSMSSchema),
    ctrl.sendSMS
);

// Webhook for incoming SMS (public, no auth)
router.post('/webhook', ctrl.handleWebhook);

// Get patient SMS history (authenticated)
router.get(
    '/history/patient/:patientId',
    authenticate,
    ctrl.getPatientHistory
);

// Get my SMS history (authenticated agent)
router.get(
    '/history/me',
    authenticate,
    authorize(['AGENT', 'DOCTOR', 'ADMIN']),
    ctrl.getMyHistory
);

export default router;
