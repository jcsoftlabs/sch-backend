import { Router } from 'express';
import * as ctrl from '../controllers/maternal-care.controller';
import { authenticate } from '../middlewares/auth.middleware';

const router = Router();

router.use(authenticate);

router.get('/', ctrl.getAll);
router.get('/high-risk', ctrl.getHighRisk);
router.get('/:id', ctrl.getById);
router.get('/patient/:patientId', ctrl.getByPatient);
router.post('/', ctrl.create);
router.put('/:id', ctrl.update);
router.delete('/:id', ctrl.remove);

export default router;
