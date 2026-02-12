import { Vonage } from '@vonage/server-sdk';

interface VonageSMSResponse {
    messageId: string;
    status: string;
}

interface VonageWebhookPayload {
    msisdn: string; // from number
    to: string;
    text: string;
    messageId: string;
    timestamp: string;
}

export class VonageService {
    private client: Vonage;
    private fromNumber: string;

    constructor() {
        const apiKey = process.env.VONAGE_API_KEY;
        const apiSecret = process.env.VONAGE_API_SECRET;
        this.fromNumber = process.env.VONAGE_FROM_NUMBER || '';

        if (!apiKey || !apiSecret) {
            throw new Error('Vonage credentials not configured');
        }

        this.client = new Vonage({
            apiKey,
            apiSecret,
        });
    }

    /**
     * Send SMS via Vonage
     */
    async sendSMS(to: string, message: string): Promise<VonageSMSResponse> {
        try {
            const response = await this.client.sms.send({
                to,
                from: this.fromNumber,
                text: message,
            });

            if (response.messages[0].status === '0') {
                return {
                    messageId: response.messages[0]['message-id'],
                    status: 'SENT',
                };
            } else {
                throw new Error(`SMS failed: ${response.messages[0].errorText}`);
            }
        } catch (error) {
            console.error('Vonage SMS error:', error);
            throw error;
        }
    }

    /**
     * Validate Vonage webhook signature (optional but recommended)
     */
    validateWebhook(payload: VonageWebhookPayload, signature?: string): boolean {
        // TODO: Implement signature validation if needed
        // For now, we'll just validate the payload structure
        return !!(payload.msisdn && payload.to && payload.text);
    }

    /**
     * Parse incoming SMS webhook
     */
    parseIncomingSMS(payload: VonageWebhookPayload) {
        return {
            from: payload.msisdn,
            to: payload.to,
            content: payload.text,
            messageId: payload.messageId,
            timestamp: new Date(payload.timestamp),
        };
    }
}

export const vonageService = new VonageService();
