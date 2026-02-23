import { Appointment } from '@prisma/client';

export interface IAppointmentRepository {
    create(data: Omit<Appointment, 'id' | 'createdAt' | 'updatedAt'>): Promise<Appointment>;
    findById(id: string): Promise<Appointment | null>;
    findAll(): Promise<Appointment[]>;
    findByPatientId(patientId: string): Promise<Appointment[]>;
    findByDoctorId(doctorId: string): Promise<Appointment[]>;
    findByHealthCenterId(centerId: string): Promise<Appointment[]>;
    findUpcoming(fromDate: Date): Promise<Appointment[]>;
    findByAgentId(agentId: string): Promise<Appointment[]>;
    update(id: string, data: Partial<Appointment>): Promise<Appointment>;
    delete(id: string): Promise<Appointment>;
}
