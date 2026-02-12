import { Consultation, Prisma } from '@prisma/client';
import { IConsultationRepository } from '../../domain/repositories/consultation.repository.interface';
import { INotificationService } from '../../infrastructure/services/notification.service';
import { AppError } from '../../utils/AppError';

export class ConsultationService {
    constructor(
        private consultationRepository: IConsultationRepository,
        private notificationService: INotificationService
    ) { }

    async requestConsultation(patientId: string, notes?: string): Promise<Consultation> {
        // In a real app, we would validate patient existence here or in controller
        const consultation = await this.consultationRepository.create({
            patient: { connect: { id: patientId } },
            notes,
            status: 'PENDING',
        });

        // Notify logic (e.g. notify admins or patient)
        await this.notificationService.sendSMS('0000000000', `New consultation request for patient ${patientId}`);

        return consultation;
    }

    async getAllConsultations(): Promise<Consultation[]> {
        return this.consultationRepository.findAll();
    }

    async getConsultationById(id: string): Promise<Consultation> {
        const consultation = await this.consultationRepository.findById(id);
        if (!consultation) {
            throw new AppError('Consultation not found', 404);
        }
        return consultation;
    }

    async updateStatus(id: string, status: any, doctorId?: string): Promise<Consultation> {
        // Validate status enum manually or trust TS/Prisma
        const data: Prisma.ConsultationUpdateInput = { status };
        if (doctorId) {
            data.doctor = { connect: { id: doctorId } };
        }

        return this.consultationRepository.update(id, data);
    }
}
