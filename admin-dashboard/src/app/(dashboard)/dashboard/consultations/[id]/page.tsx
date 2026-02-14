"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { DashboardSkeleton } from "@/components/skeletons";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Edit, FileText, Printer } from "lucide-react";
import { ConsultationService } from "@/services/consultation.service";
import { ConsultationPatientInfo } from "@/components/dashboard/consultations/ConsultationPatientInfo";
import { ConsultationVitals } from "@/components/dashboard/consultations/ConsultationVitals";
import { ConsultationDiagnosis } from "@/components/dashboard/consultations/ConsultationDiagnosis";
import { ConsultationPrescription } from "@/components/dashboard/consultations/ConsultationPrescription";
import { ConsultationTimeline } from "@/components/dashboard/consultations/ConsultationTimeline"; // Import Timeline
import { useToast } from "@/hooks/use-toast";
import { Badge } from "@/components/ui/badge";

export default function ConsultationDetailsPage() {
    const params = useParams();
    const router = useRouter();
    const { toast } = useToast();
    const [consultation, setConsultation] = useState<any | null>(null);
    const [loading, setLoading] = useState(true);

    // Mock Timeline Data
    const mockTimeline = [
        { id: "e1", title: "Consultation Terminée", time: "10:45", status: "completed", description: "Ordonnance délivrée" },
        { id: "e2", title: "Diagnostic posé", time: "10:30", status: "completed", description: "Hypertension confirmée" },
        { id: "e3", title: "Prise des constantes", time: "10:15", status: "completed", description: "Inf. Marie" },
        { id: "e4", title: "Arrivée Patient", time: "10:00", status: "completed" },
    ];

    useEffect(() => {
        const fetchConsultation = async () => {
            try {
                // Mock fetch
                await new Promise(r => setTimeout(r, 800));
                setConsultation({
                    id: params.id as string,
                    date: new Date().toISOString(),
                    status: "COMPLETED",
                    type: "SUIVI",
                    patient: {
                        id: "P-12345",
                        firstName: "Jean",
                        lastName: "Pierre",
                        age: 45,
                        gender: "MALE",
                        phone: "+509 3700-1234",
                        address: "Rue Capois, Port-au-Prince"
                    },
                    vitals: {
                        heartRate: 82,
                        bloodPressure: "140/90",
                        temperature: 37.2,
                        weight: 78
                    },
                    diagnosis: "Hypertension Artérielle Grade 1",
                    symptoms: ["Maux de tête", "Vertiges", "Fatigue"],
                    prescription: [
                        { medication: "Amlodipine", dosage: "5mg", frequency: "1x/jour", duration: "30 jours" },
                        { medication: "Paracétamol", dosage: "500mg", frequency: "si douleur", duration: "5 jours" }
                    ],
                    notes: "Patient à revoir dans 1 mois pour contrôle de la tension. Régime hyposodé conseillé."
                } as any);

            } catch (error) {
                console.error(error);
                toast({
                    title: "Erreur",
                    description: "Impossible de charger les détails de la consultation",
                    variant: "destructive",
                });
            } finally {
                setLoading(false);
            }
        };

        if (params.id) {
            fetchConsultation();
        }
    }, [params.id, toast]);

    if (loading) return <DashboardSkeleton />;
    if (!consultation) return <div className="p-8">Consultation non trouvée</div>;

    return (
        <div className="flex-1 space-y-6 p-8">
            {/* Header */}
            <div className="flex items-center justify-between">
                <div className="flex items-center space-x-4">
                    <Button variant="outline" size="icon" onClick={() => router.back()}>
                        <ArrowLeft className="h-4 w-4" />
                    </Button>
                    <div>
                        <div className="flex items-center gap-2">
                            <h2 className="text-2xl font-bold tracking-tight text-slate-900">
                                Consultation #{consultation.id}
                            </h2>
                            <Badge>{consultation.status}</Badge>
                        </div>

                        <p className="text-slate-500">
                            {new Date(consultation.date).toLocaleDateString()} • {consultation.type}
                        </p>
                    </div>
                </div>
                <div className="flex space-x-2">
                    <Button variant="outline">
                        <Printer className="mr-2 h-4 w-4" />
                        Imprimer
                    </Button>
                    <Button>
                        <Edit className="mr-2 h-4 w-4" />
                        Modifier
                    </Button>
                </div>
            </div>

            {/* Content Layout */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">

                {/* Left Column: Patient & Timeline */}
                <div className="lg:col-span-1 space-y-6">
                    <ConsultationPatientInfo patient={consultation.patient} />
                    <div className="p-6 bg-white rounded-lg border shadow-sm">
                        <ConsultationTimeline events={mockTimeline as any} />
                    </div>
                </div>

                {/* Right Column: Clinical Data */}
                <div className="lg:col-span-2 space-y-6">
                    <ConsultationVitals vitals={consultation.vitals} />
                    <ConsultationDiagnosis diagnosis={consultation.diagnosis} symptoms={consultation.symptoms} />
                    <ConsultationPrescription prescription={consultation.prescription} />

                    {/* Notes Card */}
                    <div className="p-6 bg-yellow-50 rounded-lg border border-yellow-100">
                        <h4 className="text-sm font-bold text-yellow-800 uppercase mb-2 flex items-center gap-2">
                            <FileText className="h-4 w-4" /> Notes du Médecin
                        </h4>
                        <p className="text-slate-700 whitespace-pre-wrap">{consultation.notes}</p>
                    </div>
                </div>
            </div>
        </div>
    );
}
