import { Router } from 'express';
import * as ctrl from '../controllers/medical-protocol.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createMedicalProtocolSchema, updateMedicalProtocolSchema } from '../validators/medical-protocol.validator';

const router = Router();

router.use(authenticate);

router.get('/', ctrl.getAll);
router.get('/:id', ctrl.getById);
router.get('/disease/:disease', ctrl.getByDisease);
router.post('/', authorize(['ADMIN', 'DOCTOR']), validate(createMedicalProtocolSchema), ctrl.create);
router.put('/:id', authorize(['ADMIN', 'DOCTOR']), validate(updateMedicalProtocolSchema), ctrl.update);
router.delete('/:id', authorize(['ADMIN']), ctrl.remove);

export default router;
