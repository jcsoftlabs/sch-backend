import { Vaccination } from '@prisma/client';

export interface IVaccinationRepository {
    create(data: Omit<Vaccination, 'id' | 'createdAt'>): Promise<Vaccination>;
    findById(id: string): Promise<Vaccination | null>;
    findByPatientId(patientId: string): Promise<Vaccination[]>;
    findDueVaccinations(beforeDate: Date): Promise<Vaccination[]>;
    findAll(): Promise<Vaccination[]>;
    update(id: string, data: Partial<Vaccination>): Promise<Vaccination>;
    delete(id: string): Promise<Vaccination>;
}
