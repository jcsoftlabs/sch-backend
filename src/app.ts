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
import { errorHandler } from './interfaces/http/middlewares/errorHandler';
import { authLimiter, apiLimiter } from './interfaces/http/middlewares/rateLimiter.middleware';

dotenv.config();

const app = express();

// Trust proxy - required for Railway/Heroku/etc
app.set('trust proxy', 1);

app.use(express.json({ limit: '10kb' })); // Body limit
app.use(cors({
    origin: process.env.CORS_ORIGIN || '*', // Configure allowed origins
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization'],
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
