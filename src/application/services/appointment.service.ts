import { AppointmentRepository } from '../../infrastructure/repositories/appointment.repository';
import { AppError } from '../../utils/AppError';

export class AppointmentService {
    constructor(private repo: AppointmentRepository) { }

    async createAppointment(data: any) {
        return this.repo.create(data);
    }

    async getAllAppointments() {
        return this.repo.findAll();
    }

    async getAppointmentById(id: string) {
        const appointment = await this.repo.findById(id);
        if (!appointment) throw new AppError('Appointment not found', 404);
        return appointment;
    }

    async getAppointmentsByPatient(patientId: string) {
        return this.repo.findByPatientId(patientId);
    }

    async getAppointmentsByDoctor(doctorId: string) {
        return this.repo.findByDoctorId(doctorId);
    }

    async getAppointmentsByCenter(centerId: string) {
        return this.repo.findByHealthCenterId(centerId);
    }

    async getUpcomingAppointments() {
        return this.repo.findUpcoming(new Date());
    }

    async confirmAppointment(id: string) {
        await this.getAppointmentById(id);
        return this.repo.update(id, { status: 'CONFIRMED' as any });
    }

    async cancelAppointment(id: string) {
        await this.getAppointmentById(id);
        return this.repo.update(id, { status: 'CANCELLED' as any });
    }

    async completeAppointment(id: string, notes?: string) {
        await this.getAppointmentById(id);
        return this.repo.update(id, { status: 'COMPLETED' as any, notes });
    }

    async updateAppointment(id: string, data: any) {
        await this.getAppointmentById(id);
        return this.repo.update(id, data);
    }

    async deleteAppointment(id: string) {
        await this.getAppointmentById(id);
        return this.repo.delete(id);
    }
}
