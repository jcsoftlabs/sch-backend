import { Request, Response, NextFunction } from 'express';
import { AuthService } from '../../../application/services/auth.service';
import { UserRepository } from '../../../infrastructure/repositories/user.repository';

const userRepository = new UserRepository();
const authService = new AuthService(userRepository);

export const register = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const result = await authService.register(req.body);
        res.status(201).json({
            status: 'success',
            data: {
                user: { id: result.user.id, email: result.user.email, name: result.user.name, role: result.user.role },
                accessToken: result.accessToken,
                refreshToken: result.refreshToken,
            },
        });
    } catch (error) {
        next(error);
    }
};

export const login = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const result = await authService.login(req.body);
        res.status(200).json({
            status: 'success',
            data: {
                user: { id: result.user.id, email: result.user.email, name: result.user.name, role: result.user.role },
                accessToken: result.accessToken,
                refreshToken: result.refreshToken,
            },
        });
    } catch (error) {
        next(error);
    }
};

export const refresh = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { refreshToken } = req.body;
        const result = await authService.refresh(refreshToken);
        res.status(200).json({
            status: 'success',
            data: {
                accessToken: result.accessToken,
            },
        });
    } catch (error) {
        next(error);
    }
};
