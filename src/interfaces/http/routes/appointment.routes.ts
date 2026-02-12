import { Router } from 'express';
import * as ctrl from '../controllers/appointment.controller';
import { authenticate } from '../middlewares/auth.middleware';

const router = Router();

router.use(authenticate);

router.get('/', ctrl.getAll);
router.get('/upcoming', ctrl.getUpcoming);
router.get('/:id', ctrl.getById);
router.get('/patient/:patientId', ctrl.getByPatient);
router.post('/', ctrl.create);
router.put('/:id', ctrl.update);
router.put('/:id/confirm', ctrl.confirm);
router.put('/:id/cancel', ctrl.cancel);
router.put('/:id/complete', ctrl.complete);
router.delete('/:id', ctrl.remove);

export default router;
