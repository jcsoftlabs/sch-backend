import { MaternalCareRepository } from '../../infrastructure/repositories/maternal-care.repository';
import { AppError } from '../../utils/AppError';

export class MaternalCareService {
    constructor(private repo: MaternalCareRepository) { }

    async createMaternalCare(data: any) {
        // Auto-calculate expected delivery date (40 weeks from pregnancy start)
        if (data.pregnancyStart && !data.expectedDelivery) {
            const start = new Date(data.pregnancyStart);
            const dpa = new Date(start);
            dpa.setDate(dpa.getDate() + 280); // 40 weeks
            data.expectedDelivery = dpa;
        }
        return this.repo.create(data);
    }

    async getAllMaternalCares() {
        return this.repo.findAll();
    }

    async getMaternalCareById(id: string) {
        const care = await this.repo.findById(id);
        if (!care) throw new AppError('Maternal care record not found', 404);
        return care;
    }

    async getMaternalCareByPatient(patientId: string) {
        return this.repo.findByPatientId(patientId);
    }

    async getHighRiskPregnancies() {
        return this.repo.findHighRisk();
    }

    async updateMaternalCare(id: string, data: any) {
        await this.getMaternalCareById(id);
        return this.repo.update(id, data);
    }

    async deleteMaternalCare(id: string) {
        await this.getMaternalCareById(id);
        return this.repo.delete(id);
    }
}
