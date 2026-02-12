import { Router } from 'express';
import * as ctrl from '../controllers/household.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';

const router = Router();

router.use(authenticate);

router.get('/', ctrl.getAll);
router.get('/:id', ctrl.getById);
router.get('/agent/:agentId', ctrl.getByAgent);
router.get('/zone/:zone', ctrl.getByZone);
router.post('/', ctrl.create);
router.put('/:id', ctrl.update);
router.delete('/:id', authorize(['ADMIN']), ctrl.remove);

export default router;
