import { Router } from 'express';
import { register, login, refresh } from '../controllers/auth.controller';
import { authenticate, AuthRequest } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { registerSchema, loginSchema, refreshSchema } from '../validators/schemas';
import { UserRepository } from '../../../infrastructure/repositories/user.repository';

const userRepository = new UserRepository();

const router = Router();

router.post('/register', validate(registerSchema), register);
router.post('/login', validate(loginSchema), login);
router.post('/refresh', validate(refreshSchema), refresh);
router.get('/me', authenticate, async (req, res, next) => {
    try {
        const jwtUser = (req as AuthRequest).user;
        const user = await userRepository.findById(jwtUser.id);
        if (!user) {
            res.status(404).json({ message: 'User not found' });
            return;
        }
        res.json({
            status: 'success',
            data: {
                id: user.id,
                email: user.email,
                name: user.name,
                role: user.role,
                zone: (user as any).zone ?? null,
                healthCenterId: (user as any).healthCenterId ?? null,
            }
        });
    } catch (error) {
        next(error);
    }
});

export default router;
