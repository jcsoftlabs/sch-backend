import { Appointment } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IAppointmentRepository } from '../../domain/repositories/appointment.repository.interface';

export class AppointmentRepository implements IAppointmentRepository {
    async create(data: Omit<Appointment, 'id' | 'createdAt' | 'updatedAt'>): Promise<Appointment> {
        return prisma.appointment.create({ data });
    }
    async findById(id: string): Promise<Appointment | null> {
        return prisma.appointment.findUnique({
            where: { id },
            include: { patient: true, doctor: true, healthCenter: true }
        });
    }
    async findAll(): Promise<Appointment[]> {
        return prisma.appointment.findMany({
            include: { patient: true, doctor: true, healthCenter: true },
            orderBy: { scheduledAt: 'asc' }
        });
    }
    async findByPatientId(patientId: string): Promise<Appointment[]> {
        return prisma.appointment.findMany({
            where: { patientId },
            include: { doctor: true, healthCenter: true },
            orderBy: { scheduledAt: 'asc' }
        });
    }
    async findByDoctorId(doctorId: string): Promise<Appointment[]> {
        return prisma.appointment.findMany({
            where: { doctorId },
            include: { patient: true, healthCenter: true },
            orderBy: { scheduledAt: 'asc' }
        });
    }
    async findByHealthCenterId(centerId: string): Promise<Appointment[]> {
        return prisma.appointment.findMany({
            where: { healthCenterId: centerId },
            include: { patient: true, doctor: true },
            orderBy: { scheduledAt: 'asc' }
        });
    }
    async findUpcoming(fromDate: Date): Promise<Appointment[]> {
        return prisma.appointment.findMany({
            where: { scheduledAt: { gte: fromDate }, status: { in: ['SCHEDULED', 'CONFIRMED'] } },
            include: { patient: true, doctor: true, healthCenter: true },
            orderBy: { scheduledAt: 'asc' }
        });
    }
    async update(id: string, data: Partial<Appointment>): Promise<Appointment> {
        return prisma.appointment.update({ where: { id }, data });
    }
    async delete(id: string): Promise<Appointment> {
        return prisma.appointment.delete({ where: { id } });
    }
}
