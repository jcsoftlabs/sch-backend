import { Request, Response, NextFunction } from 'express';
import { ZodError, ZodSchema } from 'zod';
import { AppError } from '../../../utils/AppError';

export const validate = (schema: ZodSchema) => (req: Request, res: Response, next: NextFunction) => {
    try {
        schema.parse({
            body: req.body,
            query: req.query,
            params: req.params,
        });
        next();
    } catch (error) {
        if (error instanceof ZodError) {
            const messages = (error as any).errors.map((e: any) => `${e.path.join('.')}: ${e.message}`).join(', ');
            next(new AppError(`Validation failed: ${messages}`, 400));
        } else {
            next(error);
        }
    }
};
