import { VaccinationRepository } from '../../infrastructure/repositories/vaccination.repository';
import { AppError } from '../../utils/AppError';

export class VaccinationService {
    constructor(private repo: VaccinationRepository) { }

    async createVaccination(data: any) {
        return this.repo.create(data);
    }

    async getAllVaccinations() {
        return this.repo.findAll();
    }

    async getVaccinationById(id: string) {
        const vacc = await this.repo.findById(id);
        if (!vacc) throw new AppError('Vaccination record not found', 404);
        return vacc;
    }

    async getVaccinationsByPatient(patientId: string) {
        return this.repo.findByPatientId(patientId);
    }

    async getDueVaccinations() {
        // Get vaccinations due within the next 30 days
        const futureDate = new Date();
        futureDate.setDate(futureDate.getDate() + 30);
        return this.repo.findDueVaccinations(futureDate);
    }

    async updateVaccination(id: string, data: any) {
        await this.getVaccinationById(id);
        return this.repo.update(id, data);
    }

    async deleteVaccination(id: string) {
        await this.getVaccinationById(id);
        return this.repo.delete(id);
    }
}
