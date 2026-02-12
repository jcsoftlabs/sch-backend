import { Router } from 'express';
import { register, login, refresh } from '../controllers/auth.controller';
import { authenticate, AuthRequest } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { registerSchema, loginSchema, refreshSchema } from '../validators/schemas';

const router = Router();

router.post('/register', validate(registerSchema), register);
router.post('/login', validate(loginSchema), login);
router.post('/refresh', validate(refreshSchema), refresh);
router.get('/me', authenticate, (req, res) => {
    const user = (req as AuthRequest).user;
    res.json({ user });
});

export default router;
