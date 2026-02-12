import { Household } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IHouseholdRepository } from '../../domain/repositories/household.repository.interface';

export class HouseholdRepository implements IHouseholdRepository {
    async create(data: Omit<Household, 'id' | 'createdAt' | 'updatedAt'>): Promise<Household> {
        return prisma.household.create({ data });
    }
    async findById(id: string): Promise<Household | null> {
        return prisma.household.findUnique({ where: { id }, include: { members: true, agent: true } });
    }
    async findAll(): Promise<Household[]> {
        return prisma.household.findMany({ include: { members: true, agent: true } });
    }
    async findByAgent(agentId: string): Promise<Household[]> {
        return prisma.household.findMany({ where: { agentId }, include: { members: true } });
    }
    async findByZone(zone: string): Promise<Household[]> {
        return prisma.household.findMany({ where: { zone }, include: { members: true } });
    }
    async update(id: string, data: Partial<Household>): Promise<Household> {
        return prisma.household.update({ where: { id }, data });
    }
    async delete(id: string): Promise<Household> {
        return prisma.household.delete({ where: { id } });
    }
}
