import { Consultation, Prisma } from '@prisma/client';

export interface IConsultationRepository {
    create(data: Prisma.ConsultationCreateInput): Promise<Consultation>;
    findAll(): Promise<Consultation[]>;
    findById(id: string): Promise<Consultation | null>;
    findByPatientId(patientId: string): Promise<Consultation[]>;
    update(id: string, data: Prisma.ConsultationUpdateInput): Promise<Consultation>;
}
