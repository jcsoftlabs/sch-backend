import { Router } from 'express';
import {
    createHealthCenter,
    getAllHealthCenters,
    getHealthCenterById,
    updateHealthCenter,
    deleteHealthCenter,
    getDirectory,
    searchBySMS
} from '../controllers/health-center.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { createHealthCenterSchema } from '../validators/schemas';

const router = Router();

// Public SMS webhook (no auth required)
router.post('/directory/search', searchBySMS);

// Protected routes
router.use(authenticate);

router.post('/', authorize(['ADMIN']), validate(createHealthCenterSchema), createHealthCenter);
router.get('/', authorize(['ADMIN', 'AGENT', 'DOCTOR']), getAllHealthCenters);
router.get('/directory', authorize(['ADMIN', 'DOCTOR', 'AGENT']), getDirectory);
router.get('/:id', authorize(['ADMIN', 'AGENT', 'DOCTOR']), getHealthCenterById);
router.put('/:id', authorize(['ADMIN']), updateHealthCenter);
router.delete('/:id', authorize(['ADMIN']), deleteHealthCenter);

export default router;
