import { CaseReportRepository } from '../../infrastructure/repositories/case-report.repository';
import { AppError } from '../../utils/AppError';

export class CaseReportService {
    constructor(private repo: CaseReportRepository) { }

    async createCaseReport(data: any) {
        return this.repo.create(data);
    }

    async getAllCaseReports() {
        return this.repo.findAll();
    }

    async getCaseReportById(id: string) {
        const report = await this.repo.findById(id);
        if (!report) throw new AppError('Case report not found', 404);
        return report;
    }

    async getCaseReportsByAgent(agentId: string) {
        return this.repo.findByAgentId(agentId);
    }

    async getCaseReportsByDoctor(doctorId: string) {
        return this.repo.findByDoctorId(doctorId);
    }

    async getPendingCaseReports() {
        return this.repo.findPending();
    }

    async assignDoctor(id: string, doctorId: string) {
        await this.getCaseReportById(id);
        return this.repo.update(id, { doctorId, status: 'ASSIGNED' as any });
    }

    async resolveCase(id: string, response: string, referral: boolean = false) {
        await this.getCaseReportById(id);
        return this.repo.update(id, {
            response,
            referral,
            status: referral ? 'REFERRED' as any : 'RESOLVED' as any,
            resolvedAt: new Date()
        });
    }

    async updateCaseReport(id: string, data: any) {
        await this.getCaseReportById(id);
        return this.repo.update(id, data);
    }

    async deleteCaseReport(id: string) {
        await this.getCaseReportById(id);
        return this.repo.delete(id);
    }
}
