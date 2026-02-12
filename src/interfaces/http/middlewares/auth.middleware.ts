import { Request, Response, NextFunction } from 'express';
import { verifyAccessToken } from '../../../utils/jwt';
import { AppError } from '../../../utils/AppError';

export interface AuthRequest extends Request {
    user?: any;
}

export const authenticate = (req: AuthRequest, res: Response, next: NextFunction) => {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return next(new AppError('No token provided', 401));
    }

    const token = authHeader.split(' ')[1];

    try {
        const decoded = verifyAccessToken(token);
        req.user = decoded;
        next();
    } catch (error) {
        return next(new AppError('Invalid token', 401));
    }
};

export const authorize = (roles: string[]) => {
    return (req: AuthRequest, res: Response, next: NextFunction) => {
        if (!req.user || !roles.includes(req.user.role)) {
            return next(new AppError('Forbidden', 403));
        }
        next();
    };
};
