import { Router } from 'express';
import { ReportsController } from '../controllers/reports.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';

const router = Router();
const reportsController = new ReportsController();

// All reports routes require authentication and ADMIN/DOCTOR role
router.use(authenticate);
router.use(authorize(['ADMIN', 'DOCTOR']));

/**
 * @route   GET /api/reports/templates
 * @desc    Get list of available report templates
 * @access  Admin, Doctor
 */
router.get('/templates', (req, res, next) => {
    reportsController.getTemplates(req, res).catch(next);
});

/**
 * @route   POST /api/reports/generate
 * @desc    Generate a report (PDF or CSV)
 * @access  Admin, Doctor
 * @body    templateId, startDate, endDate, zone?, format
 */
router.post('/generate', (req, res, next) => {
    reportsController.generateReport(req, res).catch(next);
});

/**
 * @route   GET /api/reports/export/raw
 * @desc    Export raw data as CSV
 * @access  Admin, Doctor
 * @query   entity, startDate?, endDate?, zone?
 */
router.get('/export/raw', (req, res, next) => {
    reportsController.exportRawData(req, res).catch(next);
});

/**
 * @route   GET /api/reports/epidemiology
 * @desc    Get epidemiological statistics by zone
 * @access  Admin, Doctor
 * @query   startDate?, endDate?
 */
router.get('/epidemiology', (req, res, next) => {
    reportsController.getEpidemiologyStats(req, res).catch(next);
});

export default router;
