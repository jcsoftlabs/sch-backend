import { Router } from 'express';
import * as ctrl from '../controllers/epidemiological-alert.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createEpidemiologicalAlertSchema, updateEpidemiologicalAlertSchema } from '../validators/epidemiological-alert.validator';

const router = Router();

router.use(authenticate);

router.get('/', ctrl.getAll);
router.get('/active', ctrl.getActive);
router.get('/config', ctrl.getConfig);
router.get('/:id', ctrl.getById);
router.get('/zone/:zone', ctrl.getByZone);
router.post('/', authorize(['ADMIN', 'DOCTOR']), validate(createEpidemiologicalAlertSchema), ctrl.create);
router.put('/config', authorize(['ADMIN']), ctrl.updateConfig);
router.put('/:id', authorize(['ADMIN', 'DOCTOR']), validate(updateEpidemiologicalAlertSchema), ctrl.update);
router.put('/:id/resolve', authorize(['ADMIN', 'DOCTOR']), ctrl.resolve);
router.patch('/:id/status', authorize(['ADMIN', 'DOCTOR']), ctrl.updateStatus);
router.delete('/:id', authorize(['ADMIN']), ctrl.remove);

export default router;
