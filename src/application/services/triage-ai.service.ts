import { GoogleGenerativeAI, Schema, SchemaType } from '@google/generative-ai';
import { AppError } from '../../utils/AppError';

// Ensure the API key exists
const apiKey = process.env.GEMINI_API_KEY;

let genAI: GoogleGenerativeAI | null = null;
if (apiKey) {
    genAI = new GoogleGenerativeAI(apiKey);
}

export interface TriageAIResult {
    clinicalAssessment: string;
    urgency: 'NORMAL' | 'URGENT' | 'CRITICAL';
    keywords: string[];
}

export class TriageAIService {

    /**
     * Analyze symptoms using Gemini
     */
    async analyzeSymptoms(symptoms: string): Promise<TriageAIResult> {
        if (!genAI) {
            console.error('Missing GEMINI_API_KEY environment variable. Falling back to simple keyword matching.');
            return this.fallbackAnalysis(symptoms);
        }

        try {
            // Use gemini-1.5-flash as it is fast and capable of JSON structuration
            const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

            // Define the expected output JSON schematic
            const resultSchema: Schema = {
                type: SchemaType.OBJECT,
                properties: {
                    clinicalAssessment: {
                        type: SchemaType.STRING,
                        description: "Une évaluation clinique courte et professionnelle basée sur les symptômes. Moins de 3 phrases. En Français."
                    },
                    urgency: {
                        type: SchemaType.STRING,
                        description: "Le niveau d'urgence stricte. Doit être l'une des 3 valeurs : NORMAL, URGENT, ou CRITICAL",
                        format: 'enum',
                        enum: ['NORMAL', 'URGENT', 'CRITICAL']
                    },
                    keywords: {
                        type: SchemaType.ARRAY,
                        description: "3 à 5 mots-clés extraits des symptômes (ex: [fièvre, toux, diarrhée])",
                        items: {
                            type: SchemaType.STRING
                        }
                    }
                },
                required: ["clinicalAssessment", "urgency", "keywords"] // Force structure
            };

            const prompt = `Tu es une IA d'assistance médicale pour des agents de santé communautaire en Haïti. 
Ta tâche est d'analyser les symptômes décrits par les agents de terrain et de déterminer l'urgence médicale.
Les symptômes peuvent être écrits en Français ou en Créole haïtien.
            
Symptômes rapportés par l'agent :
"${symptoms}"

Analyse ces symptômes et retourne UNIQUEMENT un objet JSON valide contenant l'évaluation clinique, le niveau d'urgence, et les mots-clés.
CRITICAL: Urgence doit absolument être NORMAL, URGENT ou CRITICAL.
Ne donne aucun texte avant ou après le JSON.`;

            // Request generation with forced JSON output matching our schema
            const result = await model.generateContent({
                contents: [{ role: 'user', parts: [{ text: prompt }] }],
                generationConfig: {
                    temperature: 0.1, // Keep it deterministic for medical
                    responseMimeType: "application/json",
                    responseSchema: resultSchema,
                }
            });

            const output = result.response.text();

            // Parse the guaranteed JSON
            const parsed = JSON.parse(output) as TriageAIResult;

            return {
                clinicalAssessment: parsed.clinicalAssessment,
                urgency: parsed.urgency,
                keywords: parsed.keywords
            };

        } catch (error) {
            console.error('Gemini AI API Error:', error);
            // If the API fails (quota limits, network), fallback to the local RegExp logic
            return this.fallbackAnalysis(symptoms);
        }
    }

    /**
     * Fallback logic if the API key is missing or the Gemini call fails.
     * Replicates the basic keyword system used in the offline mobile app.
     */
    private fallbackAnalysis(symptoms: string): TriageAIResult {
        const normalized = symptoms.toLowerCase().trim();

        const criticalKeywords = ['urgence', 'critique', 'grave', 'mourant', 'inconscient', 'convulsion', 'kriz', 'mouri', 'san', 'pa respire'];
        const urgentKeywords = ['fièvre', 'douleur', 'saignement', 'vomissement', 'diarrhée', 'lafyèv', 'doule', 'vomi', 'dyare'];

        let urgency: 'NORMAL' | 'URGENT' | 'CRITICAL' = 'NORMAL';
        let assessment = 'Symptôme bénin. Recommander repos et hydratation. Consulter si persistance.';

        if (criticalKeywords.some(kw => normalized.includes(kw))) {
            urgency = 'CRITICAL';
            assessment = "URGENCE VITALE POTENTIELLE d'après mots-clés. Référer immédiatement au centre de niveau supérieur.";
        } else if (urgentKeywords.some(kw => normalized.includes(kw))) {
            urgency = 'URGENT';
            assessment = "Cas urgent d'après mots-clés nécessitant une consultation médicale rapprochée ou administration de traitement palliatif prioritaire.";
        }

        return {
            clinicalAssessment: assessment,
            urgency: urgency,
            keywords: ['analyse', 'hors', 'ligne', 'fallback']
        };
    }
}
