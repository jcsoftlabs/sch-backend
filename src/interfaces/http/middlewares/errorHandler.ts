import { Request, Response, NextFunction } from 'express';
import { AppError } from '../../../utils/AppError';
import { logger } from '../../../utils/logger';

export const errorHandler = (err: Error, req: Request, res: Response, next: NextFunction) => {
    logger.error(err.message, err);

    if (err instanceof AppError) {
        return res.status(err.statusCode).json({
            status: 'error',
            message: err.message,
        });
    }

    return res.status(500).json({
        status: 'error',
        message: 'Internal Server Error',
    });
};
