import { Router } from 'express';
import { createHealthCenter, getAllHealthCenters, getHealthCenterById, updateHealthCenter, deleteHealthCenter } from '../controllers/health-center.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createHealthCenterSchema } from '../validators/schemas';

const router = Router();

router.use(authenticate);

router.post('/', authorize(['ADMIN']), validate(createHealthCenterSchema), createHealthCenter);
router.get('/', authorize(['ADMIN', 'AGENT', 'DOCTOR']), getAllHealthCenters);
router.get('/:id', authorize(['ADMIN', 'AGENT', 'DOCTOR']), getHealthCenterById);
router.put('/:id', authorize(['ADMIN']), updateHealthCenter);
router.delete('/:id', authorize(['ADMIN']), deleteHealthCenter);

export default router;
