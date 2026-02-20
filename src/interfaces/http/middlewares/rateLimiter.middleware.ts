import rateLimit from 'express-rate-limit';

export const authLimiter = rateLimit({
    windowMs: 5 * 60 * 1000, // 5 minutes
    max: 1000,
    message: 'Trop de tentatives (429). Veuillez patienter.',
    standardHeaders: true,
    legacyHeaders: false,
});

export const apiLimiter = rateLimit({
    windowMs: 5 * 60 * 1000, // 5 minutes
    max: 1000,
    message: 'Trop de requêtes (429). Veuillez patienter.',
    standardHeaders: true,
    legacyHeaders: false,
});
