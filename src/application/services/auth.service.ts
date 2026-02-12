import { User } from '@prisma/client';
import { IUserRepository } from '../../domain/repositories/user.repository.interface';
import { hashPassword, comparePassword } from '../../utils/password';
import { signAccessToken, signRefreshToken, verifyRefreshToken } from '../../utils/jwt';
import { AppError } from '../../utils/AppError';

export class AuthService {
    constructor(private userRepository: IUserRepository) { }

    async register(data: any): Promise<{ user: User; accessToken: string; refreshToken: string }> {
        const { email, password, name, role } = data;

        if (!email || !password || !name) {
            throw new AppError('Missing required fields', 400);
        }

        const existingUser = await this.userRepository.findByEmail(email);
        if (existingUser) {
            throw new AppError('User already exists', 409);
        }

        const hashedPassword = await hashPassword(password);
        const userRole = role || 'AGENT';

        const user = await this.userRepository.create({
            email,
            password: hashedPassword,
            name,
            role: userRole,
        });

        const accessToken = signAccessToken({ id: user.id, email: user.email, role: user.role });
        const refreshToken = signRefreshToken({ id: user.id });

        return { user, accessToken, refreshToken };
    }

    async login(data: any): Promise<{ user: User; accessToken: string; refreshToken: string }> {
        const { email, password } = data;

        if (!email || !password) {
            throw new AppError('Missing email or password', 400);
        }

        const user = await this.userRepository.findByEmail(email);
        if (!user || !(await comparePassword(password, user.password))) {
            throw new AppError('Invalid credentials', 401);
        }

        const accessToken = signAccessToken({ id: user.id, email: user.email, role: user.role });
        const refreshToken = signRefreshToken({ id: user.id });

        return { user, accessToken, refreshToken };
    }

    async refresh(token: string): Promise<{ accessToken: string }> {
        if (!token) {
            throw new AppError('No refresh token provided', 400);
        }

        let decoded: any;
        try {
            decoded = verifyRefreshToken(token);
        } catch (err) {
            throw new AppError('Invalid refresh token', 401);
        }

        const user = await this.userRepository.findById(decoded.id);
        if (!user) {
            throw new AppError('User not found', 404);
        }

        const accessToken = signAccessToken({ id: user.id, email: user.email, role: user.role });

        return { accessToken };
    }
}
