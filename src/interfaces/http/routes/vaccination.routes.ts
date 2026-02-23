import { Router } from 'express';
import * as ctrl from '../controllers/vaccination.controller';
import { authenticate } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createVaccinationSchema, updateVaccinationSchema } from '../validators/vaccination.validator';

const router = Router();

router.use(authenticate);

router.get('/', ctrl.getAll);
router.get('/due', ctrl.getDue);
router.get('/stats/dashboard', ctrl.getDashboardStats);
router.get('/:id', ctrl.getById);
router.get('/patient/:patientId', ctrl.getByPatient);
router.post('/', validate(createVaccinationSchema), ctrl.create);
router.put('/:id', validate(updateVaccinationSchema), ctrl.update);
router.delete('/:id', ctrl.remove);

export default router;
