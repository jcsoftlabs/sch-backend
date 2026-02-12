import { Request, Response, NextFunction } from 'express';
import { prisma } from '../../../infrastructure/database/prisma';
import { AuthRequest } from './auth.middleware';

// Simple audit middleware to log specific actions
// In prod, this might be more sophisticated or use a queue
export const auditLog = (action: string, resource: string) => {
    return async (req: Request, res: Response, next: NextFunction) => {
        // We execute the modification first
        next();

        // After response is finished (or we can use on-headers), we log
        // For simplicity, we just fire and forget here, assuming req.user exists
        const user = (req as AuthRequest).user;
        if (user) {
            try {
                await prisma.auditLog.create({
                    data: {
                        userId: user.id,
                        action,
                        resource,
                        details: JSON.stringify({ body: req.body, params: req.params, method: req.method, url: req.originalUrl }),
                    },
                });
            } catch (err) {
                console.error('Audit Log Error:', err);
            }
        }
    };
};
