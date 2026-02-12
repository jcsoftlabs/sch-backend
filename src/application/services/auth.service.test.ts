import { AuthService } from './auth.service';
import { IUserRepository } from '../../domain/repositories/user.repository.interface';
import { AppError } from '../../utils/AppError';
import { User } from '@prisma/client';

// Mock dependencies
const mockUserRepository: jest.Mocked<IUserRepository> = {
    create: jest.fn(),
    findByEmail: jest.fn(),
    findById: jest.fn(),
};

// Mock utils
jest.mock('../../utils/password', () => ({
    hashPassword: jest.fn().mockResolvedValue('hashedPassword'),
    comparePassword: jest.fn().mockResolvedValue(true),
}));

jest.mock('../../utils/jwt', () => ({
    signAccessToken: jest.fn().mockReturnValue('accessToken'),
    signRefreshToken: jest.fn().mockReturnValue('refreshToken'),
    verifyRefreshToken: jest.fn().mockReturnValue({ id: 'userId' }),
}));

describe('AuthService', () => {
    let authService: AuthService;

    beforeEach(() => {
        authService = new AuthService(mockUserRepository);
        jest.clearAllMocks();
    });

    describe('register', () => {
        it('should register a new user successfully', async () => {
            const userData = { email: 'test@test.com', password: 'password', name: 'Test', role: 'AGENT' };
            const createdUser = { id: 'userId', ...userData, password: 'hashedPassword', createdAt: new Date(), updatedAt: new Date() } as User;

            mockUserRepository.findByEmail.mockResolvedValue(null);
            mockUserRepository.create.mockResolvedValue(createdUser);

            const result = await authService.register(userData);

            expect(mockUserRepository.findByEmail).toHaveBeenCalledWith(userData.email);
            expect(mockUserRepository.create).toHaveBeenCalled();
            expect(result).toHaveProperty('accessToken', 'accessToken');
            expect(result.user).toEqual(createdUser);
        });

        it('should throw error if user already exists', async () => {
            const userData = { email: 'test@test.com', password: 'password', name: 'Test' };
            mockUserRepository.findByEmail.mockResolvedValue({} as User);

            await expect(authService.register(userData)).rejects.toThrow(AppError);
        });
    });

    describe('login', () => {
        it('should login successfully', async () => {
            const loginData = { email: 'test@test.com', password: 'password' };
            const user = { id: 'userId', email: 'test@test.com', password: 'hashedPassword', role: 'AGENT' } as User;

            mockUserRepository.findByEmail.mockResolvedValue(user);

            const result = await authService.login(loginData);

            expect(result).toHaveProperty('accessToken', 'accessToken');
        });
    });
});
