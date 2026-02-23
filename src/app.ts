import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';

import authRoutes from './interfaces/http/routes/auth.routes';
import patientRoutes from './interfaces/http/routes/patient.routes';
import healthCenterRoutes from './interfaces/http/routes/health-center.routes';
import consultationRoutes from './interfaces/http/routes/consultation.routes';
import userRoutes from './interfaces/http/routes/user.routes';
import householdRoutes from './interfaces/http/routes/household.routes';
import medicalRecordRoutes from './interfaces/http/routes/medical-record.routes';
import vaccinationRoutes from './interfaces/http/routes/vaccination.routes';
import caseReportRoutes from './interfaces/http/routes/case-report.routes';
import maternalCareRoutes from './interfaces/http/routes/maternal-care.routes';
import appointmentRoutes from './interfaces/http/routes/appointment.routes';
import medicalProtocolRoutes from './interfaces/http/routes/medical-protocol.routes';
import epidemiologicalAlertRoutes from './interfaces/http/routes/epidemiological-alert.routes';
import smsRoutes from './interfaces/http/routes/sms.routes';
import statsRoutes from './interfaces/http/routes/stats.routes';
import reportsRoutes from './interfaces/http/routes/reports.routes';
import prescriptionRoutes from './interfaces/http/routes/prescription.routes';
import emergencyContactRoutes from './interfaces/http/routes/emergency-contact.routes';
import diagnosisRoutes from './interfaces/http/routes/diagnosis.routes';
import labResultRoutes from './interfaces/http/routes/lab-result.routes';
import triageRoutes from './interfaces/http/routes/triage.routes';
import vitalSignRoutes from './interfaces/http/routes/vital-sign.routes';
import { errorHandler } from './interfaces/http/middlewares/errorHandler';
import { authLimiter, apiLimiter } from './interfaces/http/middlewares/rateLimiter.middleware';

dotenv.config();

const app = express();

// Trust proxy - required for Railway/Heroku/etc
app.set('trust proxy', 1);

app.use(express.json({ limit: '10kb' })); // Body limit
app.use(cors({
    origin: function (origin, callback) {
        // If no CORS_ORIGIN is set, or it's '*', allow all
        if (!process.env.CORS_ORIGIN || process.env.CORS_ORIGIN === '*') {
            return callback(null, true);
        }

        // Parse comma-separated list of allowed origins from env
        const allowedOrigins = process.env.CORS_ORIGIN.split(',').map(o => o.trim());

        // Always allow localhost and the known Vercel domains for safety during development/deployment
        allowedOrigins.push('http://localhost:3000');
        allowedOrigins.push('https://admin-dashboard-ruddy-theta.vercel.app');

        // Allow if origin is in the allowed list or if there's no origin (mobile app, postman, etc)
        if (!origin || allowedOrigins.includes(origin)) {
            callback(null, true);
        } else {
            // For now, generously allow other origins to prevent blocking the dashboard, 
            // but in strict production this should be new Error('Not allowed by CORS')
            callback(null, true);
        }
    },
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
}));
app.use(helmet());
app.use(morgan('dev'));

// Rate Limiting
app.use('/api/auth', authLimiter);
app.use('/api', apiLimiter);

// Existing routes
app.use('/api/auth', authRoutes);
app.use('/api/patients', patientRoutes);
app.use('/api/health-centers', healthCenterRoutes);
app.use('/api/consultations', consultationRoutes);
app.use('/api/users', userRoutes);

// New SCH core routes
app.use('/api/households', householdRoutes);
app.use('/api/medical-records', medicalRecordRoutes);
app.use('/api/vaccinations', vaccinationRoutes);
app.use('/api/case-reports', caseReportRoutes);
app.use('/api/maternal-care', maternalCareRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/medical-protocols', medicalProtocolRoutes);
app.use('/api/epidemiological-alerts', epidemiologicalAlertRoutes);
app.use('/api/sms', smsRoutes);

// Phase 3: MSPP Dashboard routes
app.use('/api/stats', statsRoutes);
app.use('/api/reports', reportsRoutes);

// Phase 4: Complete Medical Records
app.use('/api/prescriptions', prescriptionRoutes);
app.use('/api/emergency-contacts', emergencyContactRoutes);
app.use('/api/diagnoses', diagnosisRoutes);
app.use('/api/lab-results', labResultRoutes);
app.use('/api/vital-signs', vitalSignRoutes);
app.use('/api/triage', triageRoutes);

app.get('/health', (req, res) => {

    res.status(200).json({ status: 'OK', timestamp: new Date().toISOString() });
});

const PORT = process.env.PORT || 3000;

if (require.main === module) {
    app.listen(PORT, () => {
        console.log(`Server running on port ${PORT}`);
    });
}

app.use(errorHandler);

export default app;
