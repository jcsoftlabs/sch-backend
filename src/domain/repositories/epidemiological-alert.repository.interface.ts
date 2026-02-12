import { EpidemiologicalAlert, AlertStatus } from '@prisma/client';

export interface IEpidemiologicalAlertRepository {
    findAll(): Promise<EpidemiologicalAlert[]>;
    findById(id: string): Promise<EpidemiologicalAlert | null>;
    findActive(): Promise<EpidemiologicalAlert[]>;
    findByZone(zone: string): Promise<EpidemiologicalAlert[]>;
    create(data: Omit<EpidemiologicalAlert, 'id' | 'createdAt' | 'updatedAt'>): Promise<EpidemiologicalAlert>;
    update(id: string, data: Partial<EpidemiologicalAlert>): Promise<EpidemiologicalAlert>;
    updateStatus(id: string, status: AlertStatus): Promise<EpidemiologicalAlert>;
    delete(id: string): Promise<void>;
}
