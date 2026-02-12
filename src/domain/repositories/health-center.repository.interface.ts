import { HealthCenter, Prisma } from '@prisma/client';

export interface IHealthCenterRepository {
    create(data: Prisma.HealthCenterCreateInput): Promise<HealthCenter>;
    findAll(): Promise<HealthCenter[]>;
    findById(id: string): Promise<HealthCenter | null>;
    update(id: string, data: Prisma.HealthCenterUpdateInput): Promise<HealthCenter>;
    delete(id: string): Promise<HealthCenter>;
}
