import { HealthCenter, Prisma } from '@prisma/client';
import { IHealthCenterRepository } from '../../domain/repositories/health-center.repository.interface';
import { AppError } from '../../utils/AppError';

export class HealthCenterService {
    constructor(private healthCenterRepository: IHealthCenterRepository) { }

    async createHealthCenter(data: Prisma.HealthCenterCreateInput): Promise<HealthCenter> {
        return this.healthCenterRepository.create(data);
    }

    async getAllHealthCenters(): Promise<HealthCenter[]> {
        return this.healthCenterRepository.findAll();
    }

    async getHealthCenterById(id: string): Promise<HealthCenter> {
        const healthCenter = await this.healthCenterRepository.findById(id);
        if (!healthCenter) {
            throw new AppError('Health Center not found', 404);
        }
        return healthCenter;
    }

    async updateHealthCenter(id: string, data: Prisma.HealthCenterUpdateInput): Promise<HealthCenter> {
        const healthCenter = await this.healthCenterRepository.findById(id);
        if (!healthCenter) {
            throw new AppError('Health Center not found', 404);
        }
        return this.healthCenterRepository.update(id, data);
    }

    async deleteHealthCenter(id: string): Promise<HealthCenter> {
        const healthCenter = await this.healthCenterRepository.findById(id);
        if (!healthCenter) {
            throw new AppError('Health Center not found', 404);
        }
        return this.healthCenterRepository.delete(id);
    }
}
