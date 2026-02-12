import { MedicalProtocolRepository } from '../../infrastructure/repositories/medical-protocol.repository';
import { CaseReportRepository } from '../../infrastructure/repositories/case-report.repository';
import { CaseReportService } from './case-report.service';
import { UrgencyLevel } from '@prisma/client';

interface TriageResult {
    urgencyLevel: UrgencyLevel;
    matchedProtocol?: {
        id: string;
        name: string;
        steps: string;
    };
    keywords: string[];
}

export class TriageService {
    private protocolRepo = new MedicalProtocolRepository();
    private caseReportService = new CaseReportService(new CaseReportRepository());

    /**
     * Analyze SMS content and determine urgency level
     */
    async analyzeSMS(content: string): Promise<TriageResult> {
        const normalizedContent = content.toLowerCase();
        const words = normalizedContent.split(/\s+/);

        // Get all active protocols
        const protocols = await this.protocolRepo.findAll();

        let bestMatch: any = null;
        let maxMatches = 0;
        const matchedKeywords: string[] = [];

        // Find protocol with most keyword matches
        for (const protocol of protocols) {
            if (!protocol.isActive) continue;

            let matches = 0;
            const protocolKeywords: string[] = [];

            for (const keyword of protocol.keywords) {
                const keywordLower = keyword.toLowerCase();
                if (normalizedContent.includes(keywordLower)) {
                    matches++;
                    protocolKeywords.push(keyword);
                }
            }

            if (matches > maxMatches) {
                maxMatches = matches;
                bestMatch = protocol;
                matchedKeywords.length = 0;
                matchedKeywords.push(...protocolKeywords);
            }
        }

        // Determine urgency level
        let urgencyLevel: UrgencyLevel = 'NORMAL';

        if (bestMatch) {
            urgencyLevel = bestMatch.urgencyLevel;
        } else {
            // Fallback: check for critical keywords
            const criticalKeywords = ['urgence', 'critique', 'grave', 'mourant', 'inconscient', 'convulsion'];
            const urgentKeywords = ['fièvre', 'douleur', 'saignement', 'vomissement'];

            if (criticalKeywords.some(kw => normalizedContent.includes(kw))) {
                urgencyLevel = 'CRITICAL';
            } else if (urgentKeywords.some(kw => normalizedContent.includes(kw))) {
                urgencyLevel = 'URGENT';
            }
        }

        return {
            urgencyLevel,
            matchedProtocol: bestMatch ? {
                id: bestMatch.id,
                name: bestMatch.name,
                steps: bestMatch.steps,
            } : undefined,
            keywords: matchedKeywords,
        };
    }

    /**
     * Create CaseReport from SMS triage
     */
    async createCaseReportFromSMS(
        agentId: string,
        patientId: string | undefined,
        symptoms: string,
        triageResult: TriageResult
    ) {
        return this.caseReportService.createCaseReport({
            agentId,
            patientId,
            symptoms,
            urgency: triageResult.urgencyLevel,
            channel: 'SMS',
        });
    }

    /**
     * Generate automatic response based on triage
     */
    generateResponse(triageResult: TriageResult, caseReportId: string): string {
        const { urgencyLevel, matchedProtocol } = triageResult;

        let response = `Cas enregistré (ID: ${caseReportId.substring(0, 8)}).\n`;

        if (matchedProtocol) {
            response += `Protocole: ${matchedProtocol.name}\n`;

            // Parse steps and extract key instructions
            try {
                const steps = JSON.parse(matchedProtocol.steps);
                if (steps.traitement) {
                    response += `Traitement: ${steps.traitement.substring(0, 100)}...\n`;
                }
            } catch (e) {
                // If steps is not JSON, skip
            }
        }

        if (urgencyLevel === 'CRITICAL') {
            response += '⚠️ URGENCE CRITIQUE - Médecin notifié. Référer immédiatement.';
        } else if (urgencyLevel === 'URGENT') {
            response += '⚠️ URGENT - Médecin sera consulté rapidement.';
        } else {
            response += 'Cas en attente de consultation.';
        }

        return response;
    }
}
