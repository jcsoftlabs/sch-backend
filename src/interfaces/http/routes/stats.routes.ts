import { Router } from 'express';
import { StatsController } from '../controllers/stats.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';

const router = Router();
const statsController = new StatsController();

// All stats routes require authentication and ADMIN/DOCTOR role
router.use(authenticate);
router.use(authorize(['ADMIN', 'DOCTOR']));

/**
 * @route   GET /api/stats/map-data
 * @desc    Get geographic data for interactive map
 * @access  Admin, Doctor
 * @query   startDate, endDate, disease, zone, urgency
 */
router.get('/map-data', (req, res, next) => {
    statsController.getMapData(req, res).catch(next);
});

/**
 * @route   GET /api/stats/agents
 * @desc    Get global agent statistics
 * @access  Admin, Doctor
 * @query   startDate, endDate, zone
 */
router.get('/agents', (req, res, next) => {
    statsController.getAgentStats(req, res).catch(next);
});

/**
 * @route   GET /api/stats/agents/:id
 * @desc    Get detailed statistics for a specific agent
 * @access  Admin, Doctor
 * @query   startDate, endDate
 */
router.get('/agents/:id', (req, res, next) => {
    statsController.getAgentDetailStats(req, res).catch(next);
});

export default router;
