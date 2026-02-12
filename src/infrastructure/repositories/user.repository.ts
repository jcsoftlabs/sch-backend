import { User, Prisma } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IUserRepository } from '../../domain/repositories/user.repository.interface';

export class UserRepository implements IUserRepository {
    async create(data: Prisma.UserCreateInput): Promise<User> {
        return prisma.user.create({ data });
    }

    async findByEmail(email: string): Promise<User | null> {
        return prisma.user.findUnique({ where: { email } });
    }

    async findById(id: string): Promise<User | null> {
        return prisma.user.findUnique({ where: { id } });
    }

    async findAll(): Promise<User[]> {
        return prisma.user.findMany();
    }

    async update(id: string, data: Prisma.UserUpdateInput): Promise<User> {
        return prisma.user.update({ where: { id }, data });
    }

    async delete(id: string): Promise<User> {
        return prisma.user.delete({ where: { id } });
    }
}
