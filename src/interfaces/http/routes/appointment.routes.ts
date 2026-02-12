import { Router } from 'express';
import * as ctrl from '../controllers/appointment.controller';
import { authenticate } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createAppointmentSchema, updateAppointmentSchema, completeAppointmentSchema } from '../validators/appointment.validator';

const router = Router();

router.use(authenticate);

router.get('/', ctrl.getAll);
router.get('/upcoming', ctrl.getUpcoming);
router.get('/:id', ctrl.getById);
router.get('/patient/:patientId', ctrl.getByPatient);
router.post('/', validate(createAppointmentSchema), ctrl.create);
router.put('/:id', validate(updateAppointmentSchema), ctrl.update);
router.put('/:id/confirm', ctrl.confirm);
router.put('/:id/cancel', ctrl.cancel);
router.put('/:id/complete', validate(completeAppointmentSchema), ctrl.complete);
router.delete('/:id', ctrl.remove);

export default router;
