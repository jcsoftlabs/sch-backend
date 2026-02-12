import { Router } from 'express';
import * as ctrl from '../controllers/case-report.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';

const router = Router();

router.use(authenticate);

router.get('/', ctrl.getAll);
router.get('/pending', ctrl.getPending);
router.get('/:id', ctrl.getById);
router.get('/agent/:agentId', ctrl.getByAgent);
router.post('/', ctrl.create);
router.put('/:id', ctrl.update);
router.put('/:id/assign', authorize(['ADMIN', 'DOCTOR']), ctrl.assignDoctor);
router.put('/:id/resolve', authorize(['DOCTOR']), ctrl.resolve);
router.delete('/:id', authorize(['ADMIN']), ctrl.remove);

export default router;
