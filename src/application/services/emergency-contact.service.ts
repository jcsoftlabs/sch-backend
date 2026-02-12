import {
    EmergencyContactRepository,
    CreateEmergencyContactDTO,
    UpdateEmergencyContactDTO,
} from '../../infrastructure/repositories/emergency-contact.repository';
import { EmergencyContact } from '@prisma/client';
import { AppError } from '../../utils/AppError';

export class EmergencyContactService {
    constructor(private contactRepo: EmergencyContactRepository) { }

    async getContactsByPatient(patientId: string): Promise<EmergencyContact[]> {
        return this.contactRepo.findByPatientId(patientId);
    }

    async getPrimaryContact(patientId: string): Promise<EmergencyContact | null> {
        return this.contactRepo.findPrimaryByPatientId(patientId);
    }

    async getContactById(id: string): Promise<EmergencyContact> {
        const contact = await this.contactRepo.findById(id);
        if (!contact) {
            throw new AppError('Emergency contact not found', 404);
        }
        return contact;
    }

    async createContact(data: CreateEmergencyContactDTO): Promise<EmergencyContact> {
        // Validate phone format (basic validation)
        if (!this.isValidPhone(data.phone)) {
            throw new AppError('Invalid phone number format', 400);
        }

        return this.contactRepo.create(data);
    }

    async updateContact(
        id: string,
        data: UpdateEmergencyContactDTO
    ): Promise<EmergencyContact> {
        await this.getContactById(id); // Verify exists

        // Validate phone if provided
        if (data.phone && !this.isValidPhone(data.phone)) {
            throw new AppError('Invalid phone number format', 400);
        }

        return this.contactRepo.update(id, data);
    }

    async setPrimaryContact(id: string): Promise<EmergencyContact> {
        await this.getContactById(id); // Verify exists
        return this.contactRepo.setPrimary(id);
    }

    async deleteContact(id: string): Promise<void> {
        await this.getContactById(id); // Verify exists
        await this.contactRepo.delete(id);
    }

    private isValidPhone(phone: string): boolean {
        // Basic phone validation (Haitian format: +509 XXXX XXXX or local)
        const phoneRegex = /^(\+509\s?)?(\d{4}\s?\d{4}|\d{8})$/;
        return phoneRegex.test(phone.replace(/\s/g, ''));
    }
}
