import { Router } from 'express';
import { TriageController } from '../controllers/triage.controller';
import { authenticate } from '../middlewares/auth.middleware';

const router = Router();
const controller = new TriageController();

// All triage routes must be authenticated
router.use(authenticate);

router.post('/analyze', controller.analyzeSymptom);

export default router;
