export interface INotificationService {
    sendSMS(phoneNumber: string, message: string): Promise<void>;
}

export class MockNotificationService implements INotificationService {
    async sendSMS(phoneNumber: string, message: string): Promise<void> {
        console.log(`[SMS MOCK] To: ${phoneNumber}, Message: ${message}`);
    }
}
