import { EpidemiologicalAlert, AlertStatus, AlertSeverity } from '@prisma/client';
import { EpidemiologicalAlertRepository } from '../../infrastructure/repositories/epidemiological-alert.repository';

export class EpidemiologicalAlertService {
    private repository = new EpidemiologicalAlertRepository();

    async getAll(): Promise<EpidemiologicalAlert[]> {
        return this.repository.findAll();
    }

    async getById(id: string): Promise<EpidemiologicalAlert | null> {
        return this.repository.findById(id);
    }

    async getActive(): Promise<EpidemiologicalAlert[]> {
        return this.repository.findActive();
    }

    async getByZone(zone: string): Promise<EpidemiologicalAlert[]> {
        return this.repository.findByZone(zone);
    }

    async create(data: Omit<EpidemiologicalAlert, 'id' | 'createdAt' | 'updatedAt'>): Promise<EpidemiologicalAlert> {
        // Auto-set severity based on case count threshold
        const severity = this.calculateSeverity(data.caseCount);
        return this.repository.create({ ...data, severity });
    }

    async update(id: string, data: Partial<EpidemiologicalAlert>): Promise<EpidemiologicalAlert> {
        return this.repository.update(id, data);
    }

    async resolve(id: string): Promise<EpidemiologicalAlert> {
        return this.repository.updateStatus(id, 'RESOLVED');
    }

    async delete(id: string): Promise<void> {
        return this.repository.delete(id);
    }

    // Automatic severity calculation based on case count
    private calculateSeverity(caseCount: number): AlertSeverity {
        if (caseCount >= 50) return 'CRITICAL';
        if (caseCount >= 10) return 'WARNING';
        return 'INFO';
    }
}
