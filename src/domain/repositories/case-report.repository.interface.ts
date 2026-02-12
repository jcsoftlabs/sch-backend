import { CaseReport } from '@prisma/client';

export interface ICaseReportRepository {
    create(data: Omit<CaseReport, 'id' | 'createdAt' | 'updatedAt'>): Promise<CaseReport>;
    findById(id: string): Promise<CaseReport | null>;
    findAll(): Promise<CaseReport[]>;
    findByAgentId(agentId: string): Promise<CaseReport[]>;
    findByDoctorId(doctorId: string): Promise<CaseReport[]>;
    findByStatus(status: string): Promise<CaseReport[]>;
    findPending(): Promise<CaseReport[]>;
    update(id: string, data: Partial<CaseReport>): Promise<CaseReport>;
    delete(id: string): Promise<CaseReport>;
}
