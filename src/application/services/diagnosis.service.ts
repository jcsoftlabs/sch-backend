import {
    DiagnosisRepository,
    CreateDiagnosisDTO,
    UpdateDiagnosisDTO,
} from '../../infrastructure/repositories/diagnosisRepository';
import { Diagnosis } from '@prisma/client';
import { AppError } from '../../utils/AppError';

export class DiagnosisService {
    constructor(private diagnosisRepo: DiagnosisRepository) { }

    async getDiagnosesByPatient(patientId: string): Promise<Diagnosis[]> {
        return this.diagnosisRepo.findByPatientId(patientId);
    }

    async getActiveDiagnosesByPatient(patientId: string): Promise<Diagnosis[]> {
        return this.diagnosisRepo.findActiveByPatientId(patientId);
    }

    async getDiagnosisById(id: string): Promise<Diagnosis> {
        const diagnosis = await this.diagnosisRepo.findById(id);
        if (!diagnosis) {
            throw new AppError('Diagnosis not found', 404);
        }
        return diagnosis;
    }

    async createDiagnosis(data: CreateDiagnosisDTO): Promise<Diagnosis> {
        // Validate ICD-10 code format if provided (basic validation)
        if (data.icd10Code && !this.isValidICD10(data.icd10Code)) {
            throw new AppError('Invalid ICD-10 code format', 400);
        }

        return this.diagnosisRepo.create(data);
    }

    async updateDiagnosis(id: string, data: UpdateDiagnosisDTO): Promise<Diagnosis> {
        await this.getDiagnosisById(id); // Verify exists

        // Validate ICD-10 if provided
        if (data.icd10Code && !this.isValidICD10(data.icd10Code)) {
            throw new AppError('Invalid ICD-10 code format', 400);
        }

        // Auto-set resolvedAt if status changed to RESOLVED
        if (data.status === 'RESOLVED' && !data.resolvedAt) {
            data.resolvedAt = new Date();
        }

        return this.diagnosisRepo.update(id, data);
    }

    async resolveDiagnosis(id: string): Promise<Diagnosis> {
        await this.getDiagnosisById(id); // Verify exists
        return this.diagnosisRepo.resolve(id);
    }

    async deleteDiagnosis(id: string): Promise<void> {
        await this.getDiagnosisById(id); // Verify exists
        await this.diagnosisRepo.delete(id);
    }

    async searchByDisease(disease: string): Promise<Diagnosis[]> {
        return this.diagnosisRepo.findByDisease(disease);
    }

    private isValidICD10(code: string): boolean {
        // ICD-10 format: Letter + 2 digits + optional .X (e.g., A00, A00.1, Z99.9)
        const icd10Regex = /^[A-Z]\d{2}(\.\d{1,2})?$/;
        return icd10Regex.test(code);
    }
}
