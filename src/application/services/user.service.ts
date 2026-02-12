import { User, Prisma } from '@prisma/client';
import { IUserRepository } from '../../domain/repositories/user.repository.interface';
import { hashPassword } from '../../utils/password';
import { AppError } from '../../utils/AppError';

export class UserService {
    constructor(private userRepository: IUserRepository) { }

    async getAllUsers(): Promise<User[]> {
        return this.userRepository.findAll();
    }

    async getUserById(id: string): Promise<User> {
        const user = await this.userRepository.findById(id);
        if (!user) {
            throw new AppError('User not found', 404);
        }
        return user;
    }

    async createUser(data: { email: string; password: string; name: string; role?: string }): Promise<User> {
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

        return this.userRepository.create({
            email,
            password: hashedPassword,
            name,
            role: userRole as any,
        });
    }

    async updateUser(id: string, data: Prisma.UserUpdateInput): Promise<User> {
        const user = await this.userRepository.findById(id);
        if (!user) {
            throw new AppError('User not found', 404);
        }

        // If password is being updated, hash it
        if (data.password && typeof data.password === 'string') {
            data.password = await hashPassword(data.password);
        }

        return this.userRepository.update(id, data);
    }

    async deleteUser(id: string): Promise<User> {
        const user = await this.userRepository.findById(id);
        if (!user) {
            throw new AppError('User not found', 404);
        }
        return this.userRepository.delete(id);
    }
}
