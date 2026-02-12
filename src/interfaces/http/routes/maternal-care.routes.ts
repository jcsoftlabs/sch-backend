import { Router } from 'express';
import * as ctrl from '../controllers/maternal-care.controller';
import { authenticate } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createMaternalCareSchema, updateMaternalCareSchema } from '../validators/maternal-care.validator';

const router = Router();

router.use(authenticate);

router.get('/', ctrl.getAll);
router.get('/high-risk', ctrl.getHighRisk);
router.get('/:id', ctrl.getById);
router.get('/patient/:patientId', ctrl.getByPatient);
router.post('/', validate(createMaternalCareSchema), ctrl.create);
router.put('/:id', validate(updateMaternalCareSchema), ctrl.update);
router.delete('/:id', ctrl.remove);

export default router;
