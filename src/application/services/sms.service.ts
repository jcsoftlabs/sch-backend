import { prisma } from '../../infrastructure/database/prisma';
import { vonageService } from '../../infrastructure/services/vonage.service';
import { TriageService } from './triage.service';

export class SMSService {
    private triageService = new TriageService();

    /**
     * Send SMS to a phone number
     */
    async sendSMS(to: string, content: string, agentId?: string, patientId?: string) {
        try {
            // Send via Vonage
            const response = await vonageService.sendSMS(to, content);

            // Save to database
            const smsMessage = await prisma.sMSMessage.create({
                data: {
                    messageId: response.messageId,
                    direction: 'OUTBOUND',
                    from: process.env.VONAGE_FROM_NUMBER || '',
                    to,
                    content,
                    status: response.status as any,
                    agentId,
                    patientId,
                },
            });

            return smsMessage;
        } catch (error) {
            console.error('SMS send error:', error);

            // Save failed message to database
            await prisma.sMSMessage.create({
                data: {
                    direction: 'OUTBOUND',
                    from: process.env.VONAGE_FROM_NUMBER || '',
                    to,
                    content,
                    status: 'FAILED',
                    agentId,
                    patientId,
                },
            });

            throw error;
        }
    }

    /**
     * Handle incoming SMS from webhook
     */
    async handleIncomingSMS(payload: any) {
        const parsed = vonageService.parseIncomingSMS(payload);

        // Save incoming SMS
        const smsMessage = await prisma.sMSMessage.create({
            data: {
                messageId: parsed.messageId,
                direction: 'INBOUND',
                from: parsed.from,
                to: parsed.to,
                content: parsed.content,
                status: 'DELIVERED',
                deliveredAt: parsed.timestamp,
            },
        });

        // Try to identify agent by phone number
        const agent = await prisma.user.findFirst({
            where: { phone: parsed.from },
        });

        if (agent) {
            // Update SMS with agent ID
            await prisma.sMSMessage.update({
                where: { id: smsMessage.id },
                data: { agentId: agent.id },
            });

            // Perform triage
            const triageResult = await this.triageService.analyzeSMS(parsed.content);

            // Create CaseReport
            const caseReport = await this.triageService.createCaseReportFromSMS(
                agent.id,
                undefined, // TODO: extract patient ID from SMS if provided
                parsed.content,
                triageResult
            );

            // Link SMS to CaseReport
            await prisma.sMSMessage.update({
                where: { id: smsMessage.id },
                data: { caseReportId: caseReport.id },
            });

            // Generate and send automatic response
            const response = this.triageService.generateResponse(triageResult, caseReport.id);
            await this.sendSMS(parsed.from, response, agent.id);

            // If CRITICAL, notify doctor
            if (triageResult.urgencyLevel === 'CRITICAL') {
                await this.notifyDoctor(caseReport.id, triageResult);
            }

            return { smsMessage, caseReport, triageResult };
        }

        return { smsMessage };
    }

    /**
     * Get SMS history for a patient
     */
    async getPatientHistory(patientId: string) {
        return prisma.sMSMessage.findMany({
            where: { patientId },
            orderBy: { createdAt: 'desc' },
            include: {
                agent: { select: { name: true, phone: true } },
                caseReport: { select: { id: true, urgency: true, status: true } },
            },
        });
    }

    /**
     * Get SMS history for an agent
     */
    async getAgentHistory(agentId: string) {
        return prisma.sMSMessage.findMany({
            where: { agentId },
            orderBy: { createdAt: 'desc' },
            include: {
                patient: { select: { firstName: true, lastName: true } },
                caseReport: { select: { id: true, urgency: true, status: true } },
            },
        });
    }

    /**
     * Notify doctor about critical case
     */
    private async notifyDoctor(caseReportId: string, triageResult: any) {
        // Find available doctor
        const doctor = await prisma.user.findFirst({
            where: { role: 'DOCTOR' },
        });

        if (doctor && doctor.phone) {
            const message = `🚨 URGENCE CRITIQUE\nNouveau cas: ${caseReportId.substring(0, 8)}\nProtocole: ${triageResult.matchedProtocol?.name || 'Non identifié'}\nConsultez le système pour plus de détails.`;

            await this.sendSMS(doctor.phone, message);
        }
    }
}
