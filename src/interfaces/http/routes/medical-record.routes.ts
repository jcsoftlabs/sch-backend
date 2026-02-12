import { Router } from 'express';
import * as ctrl from '../controllers/medical-record.controller';
import { authenticate } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createMedicalRecordSchema, updateMedicalRecordSchema } from '../validators/medical-record.validator';

const router = Router();

router.use(authenticate);

router.get('/:id', ctrl.getById);
router.get('/patient/:patientId', ctrl.getByPatient);
router.post('/', validate(createMedicalRecordSchema), ctrl.create);
router.put('/:id', validate(updateMedicalRecordSchema), ctrl.update);
router.delete('/:id', ctrl.remove);

export default router;
