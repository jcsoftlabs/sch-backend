import { CaseReport } from '@prisma/client';
import { prisma } from '../database/prisma';
import { ICaseReportRepository } from '../../domain/repositories/case-report.repository.interface';

export class CaseReportRepository implements ICaseReportRepository {
    async create(data: Omit<CaseReport, 'id' | 'createdAt' | 'updatedAt'>): Promise<CaseReport> {
        return prisma.caseReport.create({ data });
    }
    async findById(id: string): Promise<CaseReport | null> {
        return prisma.caseReport.findUnique({
            where: { id },
            include: { agent: true, doctor: true, patient: true }
        });
    }
    async findAll(): Promise<CaseReport[]> {
        return prisma.caseReport.findMany({
            include: { agent: true, doctor: true, patient: true },
            orderBy: { createdAt: 'desc' }
        });
    }
    async findByAgentId(agentId: string): Promise<CaseReport[]> {
        return prisma.caseReport.findMany({
            where: { agentId },
            include: { doctor: true, patient: true },
            orderBy: { createdAt: 'desc' }
        });
    }
    async findByDoctorId(doctorId: string): Promise<CaseReport[]> {
        return prisma.caseReport.findMany({
            where: { doctorId },
            include: { agent: true, patient: true },
            orderBy: { createdAt: 'desc' }
        });
    }
    async findByStatus(status: string): Promise<CaseReport[]> {
        return prisma.caseReport.findMany({
            where: { status: status as any },
            include: { agent: true, doctor: true, patient: true },
            orderBy: { createdAt: 'desc' }
        });
    }
    async findPending(): Promise<CaseReport[]> {
        return prisma.caseReport.findMany({
            where: { status: 'PENDING' },
            include: { agent: true, patient: true },
            orderBy: [{ urgency: 'desc' }, { createdAt: 'asc' }]
        });
    }
    async update(id: string, data: Partial<CaseReport>): Promise<CaseReport> {
        return prisma.caseReport.update({ where: { id }, data });
    }
    async delete(id: string): Promise<CaseReport> {
        return prisma.caseReport.delete({ where: { id } });
    }
}
