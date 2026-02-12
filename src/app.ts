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

app.use('/api/auth', authRoutes);
app.use('/api/patients', patientRoutes);
app.use('/api/centers', healthCenterRoutes);
app.use('/api/consultations', consultationRoutes);
app.use('/api/users', userRoutes);

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
