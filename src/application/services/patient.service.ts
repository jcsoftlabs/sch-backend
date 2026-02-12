import { Patient, Prisma } from '@prisma/client';
import { IPatientRepository } from '../../domain/repositories/patient.repository.interface';
import { AppError } from '../../utils/AppError';

export class PatientService {
    constructor(private patientRepository: IPatientRepository) { }

    async createPatient(data: Prisma.PatientCreateInput): Promise<Patient> {
        return this.patientRepository.create(data);
    }

    async getAllPatients(): Promise<Patient[]> {
        return this.patientRepository.findAll();
    }

    async getPatientById(id: string): Promise<Patient> {
        const patient = await this.patientRepository.findById(id);
        if (!patient) {
            throw new AppError('Patient not found', 404);
        }
        return patient;
    }

    async updatePatient(id: string, data: Prisma.PatientUpdateInput): Promise<Patient> {
        const patient = await this.patientRepository.findById(id);
        if (!patient) {
            throw new AppError('Patient not found', 404);
        }
        return this.patientRepository.update(id, data);
    }

    async deletePatient(id: string): Promise<Patient> {
        const patient = await this.patientRepository.findById(id);
        if (!patient) {
            throw new AppError('Patient not found', 404);
        }
        return this.patientRepository.delete(id);
    }
}
