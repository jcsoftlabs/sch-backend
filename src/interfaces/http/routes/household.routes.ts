import { Router } from 'express';
import * as ctrl from '../controllers/household.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createHouseholdSchema, updateHouseholdSchema } from '../validators/household.validator';

const router = Router();

router.use(authenticate);

router.get('/', ctrl.getAll);
router.get('/:id', ctrl.getById);
router.get('/agent/:agentId', ctrl.getByAgent);
router.get('/zone/:zone', ctrl.getByZone);
router.post('/', validate(createHouseholdSchema), ctrl.create);
router.put('/:id', validate(updateHouseholdSchema), ctrl.update);
router.delete('/:id', authorize(['ADMIN']), ctrl.remove);

// Household members routes
router.get('/:id/members', ctrl.getMembers);
router.post('/:id/members', ctrl.addMember);
router.put('/:id/members/:memberId', ctrl.updateMember);
router.delete('/:id/members/:memberId', ctrl.removeMember);

export default router;
