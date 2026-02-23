import { Router } from 'express';
import * as ctrl from '../controllers/nutrition.controller';
import { authenticate } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createNutritionSchema, updateNutritionSchema } from '../validators/nutrition.validator';

const router = Router();

router.use(authenticate);

router.get('/:id', ctrl.getById);
router.get('/patient/:patientId', ctrl.getByPatient);
router.post('/', validate(createNutritionSchema), ctrl.create);
router.put('/:id', validate(updateNutritionSchema), ctrl.update);
router.delete('/:id', ctrl.remove);

export default router;
