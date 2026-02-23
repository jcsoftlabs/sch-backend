import { Router } from 'express';
import * as ctrl from '../controllers/vital-sign.controller';
import { authenticate } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createVitalSignSchema } from '../validators/vital-sign.validator';

const router = Router();

router.use(authenticate);

router.post('/patient/:patientId', validate(createVitalSignSchema), ctrl.create);
router.get('/patient/:patientId', ctrl.getByPatient);
router.delete('/:id', ctrl.remove);

export default router;
