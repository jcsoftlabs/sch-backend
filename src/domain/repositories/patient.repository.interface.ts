import { Patient, Prisma } from '@prisma/client';

export interface IPatientRepository {
    create(data: Prisma.PatientCreateInput): Promise<Patient>;
    findAll(): Promise<Patient[]>;
    findById(id: string): Promise<Patient | null>;
    update(id: string, data: Prisma.PatientUpdateInput): Promise<Patient>;
    delete(id: string): Promise<Patient>;
}
