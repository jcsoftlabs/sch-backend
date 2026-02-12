import { Household } from '@prisma/client';

export interface IHouseholdRepository {
    create(data: Omit<Household, 'id' | 'createdAt' | 'updatedAt'>): Promise<Household>;
    findById(id: string): Promise<Household | null>;
    findAll(): Promise<Household[]>;
    findByAgent(agentId: string): Promise<Household[]>;
    findByZone(zone: string): Promise<Household[]>;
    update(id: string, data: Partial<Household>): Promise<Household>;
    delete(id: string): Promise<Household>;
}
