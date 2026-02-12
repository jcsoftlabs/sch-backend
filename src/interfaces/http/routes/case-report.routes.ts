import { Router } from 'express';
import * as ctrl from '../controllers/case-report.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createCaseReportSchema, updateCaseReportSchema, assignDoctorSchema, resolveCaseReportSchema } from '../validators/case-report.validator';

const router = Router();

router.use(authenticate);

router.get('/', ctrl.getAll);
router.get('/pending', ctrl.getPending);
router.get('/:id', ctrl.getById);
router.get('/agent/:agentId', ctrl.getByAgent);
router.post('/', validate(createCaseReportSchema), ctrl.create);
router.put('/:id', validate(updateCaseReportSchema), ctrl.update);
router.put('/:id/assign', authorize(['ADMIN', 'DOCTOR']), validate(assignDoctorSchema), ctrl.assignDoctor);
router.put('/:id/resolve', authorize(['DOCTOR']), validate(resolveCaseReportSchema), ctrl.resolve);
router.delete('/:id', authorize(['ADMIN']), ctrl.remove);

export default router;
