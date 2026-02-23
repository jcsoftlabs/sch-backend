"use client";

import { useParams, useRouter } from "next/navigation";
import { useState, useEffect } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { TriageService, TriageReport } from "@/services/triage.service";
import { User, Activity, Brain, Clock, CheckCircle2, AlertTriangle, ShieldCheck, Thermometer, Info } from "lucide-react";
import { getUrgencyColor } from "@/components/dashboard/TriageTable";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";

export default function TriageDetailPage() {
    const params = useParams();
    const router = useRouter();
    const reportId = params.id as string;
    const [report, setReport] = useState<TriageReport | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadReport();
    }, [reportId]);

    const loadReport = async () => {
        try {
            setLoading(true);
            const data = await TriageService.getById(reportId);
            setReport(data);
        } catch (error) {
            console.error("Error loading triage report:", error);
            // Fallback for development if backend missing
            if (reportId === "evt-1234") {
                setReport({
                    id: "evt-1234",
                    patientId: "pat-123",
                    createdBy: "user-1",
                    symptoms: ["Fièvre élevée (> 39°C)", "Toux sèche persistante", "Perte d'odorat soudaine", "Fatigue intense"],
                    aiDiagnosticName: "Suspicion de COVID-19 ou Grippe Sévère",
                    aiDiagnosticReasoning: "Les symptômes déclarés (fièvre élevée, toux sèche, anosmie) correspondent fortement aux critères diagnostiques de l'infection virale respiratoire de type SARS-CoV-2. L'apparition soudaine de la perte d'odorat est un marqueur fort. Une évaluation médicale immédiate et un test de dépistage sont recommandés pour confirmer le diagnostic et limiter la propagation.",
                    aiConfidenceScore: 92,
                    urgencyLevel: "ELEVEE",
                    medicalProtocolId: "prot-1",
                    createdAt: new Date().toISOString(),
                    updatedAt: new Date().toISOString(),
                    validationStatus: "PENDING",
                    validatedBy: null,
                    validatedAt: null,
                    patient: { id: "pat-123", firstName: "Jean", lastName: "Jacques" },
                    creator: { id: "user-1", firstName: "Agent", lastName: "Local" },
                    protocol: { id: "prot-1", name: "Protocole Respiratoire Standard" }
                });
            } else {
                setReport(null);
            }
        } finally {
            setLoading(false);
        }
    };

    if (loading) {
        return (
            <div className="p-8 space-y-6">
                <Skeleton className="h-12 w-64" />
                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <Skeleton className="h-64 w-full md:col-span-1" />
                    <Skeleton className="h-64 w-full md:col-span-2" />
                </div>
            </div>
        );
    }

    if (!report) {
        return (
            <div className="p-8">
                <Card>
                    <CardHeader>
                        <CardTitle>Rapport non trouvé</CardTitle>
                        <CardDescription>
                            Le rapport de triage demandé n'existe pas ou a été supprimé.
                        </CardDescription>
                    </CardHeader>
                </Card>
            </div>
        );
    }

    const patientName = report.patient ? `${report.patient.firstName} ${report.patient.lastName}` : "Patient Non Lié (Anonyme)";
    const agentName = report.creator ? `${report.creator.firstName} ${report.creator.lastName}` : "Agent Inconnu";
    const date = new Date(report.createdAt).toLocaleString('fr-FR', {
        dateStyle: 'full',
        timeStyle: 'short'
    });

    return (
        <div className="p-8 space-y-6">
            {/* Header */}
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <div className="flex items-center gap-3 mb-2">
                        <h1 className="text-3xl font-bold tracking-tight">Rapport de Triage</h1>
                        <span className={`px-3 py-1 rounded-full text-sm font-bold border ${getUrgencyColor(report.urgencyLevel)} uppercase`}>
                            Urgence {report.urgencyLevel}
                        </span>
                        {report.validationStatus === "VALIDATED" && (
                            <span className="px-3 py-1 rounded-full text-sm font-bold border bg-green-100 text-green-700 border-green-200 uppercase flex items-center gap-1">
                                <ShieldCheck className="w-4 h-4" /> Validé
                            </span>
                        )}
                        {report.validationStatus === "PENDING" && (
                            <span className="px-3 py-1 rounded-full text-sm font-bold border bg-amber-100 text-amber-700 border-amber-200 uppercase flex items-center gap-1">
                                <Clock className="w-4 h-4" /> En Attente
                            </span>
                        )}
                    </div>
                    <p className="text-slate-500 flex items-center gap-2">
                        <Clock className="h-4 w-4" /> {date}
                        <span className="mx-2">•</span>
                        <User className="h-4 w-4" /> Évalué par {agentName}
                    </p>
                </div>

                {report.validationStatus === "PENDING" && (
                    <div className="flex items-center gap-3">
                        <Button variant="outline" className="text-red-600 border-red-200 hover:bg-red-50">
                            Rejeter le diagnostic
                        </Button>
                        <Button className="bg-emerald-600 hover:bg-emerald-700 text-white shadow-sm">
                            <ShieldCheck className="w-4 h-4 mr-2" />
                            Valider l'évaluation
                        </Button>
                    </div>
                )}
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">

                {/* Left Column: Context & Symptoms */}
                <div className="space-y-6 lg:col-span-1">

                    <Card>
                        <CardHeader className="pb-3">
                            <CardTitle className="flex items-center gap-2 text-lg">
                                <User className="h-5 w-5 text-indigo-500" />
                                Sujet de l'évaluation
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <p className="font-medium text-lg">{patientName}</p>
                            {report.patientId ? (
                                <Button
                                    variant="link"
                                    className="px-0 h-auto text-blue-600 mt-1"
                                    onClick={() => router.push(`/dashboard/patients/${report.patientId}`)}
                                >
                                    Voir le dossier médical complet &rarr;
                                </Button>
                            ) : (
                                <p className="text-sm text-slate-500 mt-1">Dossier médical non rattaché.</p>
                            )}
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="pb-3">
                            <CardTitle className="flex items-center gap-2 text-lg">
                                <Thermometer className="h-5 w-5 text-orange-500" />
                                Symptômes Reportés
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            {report.symptoms && report.symptoms.length > 0 ? (
                                <div className="flex flex-wrap gap-2">
                                    {report.symptoms.map((symp, idx) => (
                                        <Badge key={idx} variant="secondary" className="px-3 py-1 text-sm bg-slate-100 text-slate-800 border-slate-200">
                                            {symp}
                                        </Badge>
                                    ))}
                                </div>
                            ) : (
                                <p className="text-slate-500 italic">Aucun symptôme spécifique saisi.</p>
                            )}
                        </CardContent>
                    </Card>
                </div>

                {/* Right Column: AI Analysis */}
                <div className="space-y-6 lg:col-span-2">

                    <Card className="border-blue-100 shadow-sm">
                        <CardHeader className="bg-slate-50/50 border-b border-slate-100 pb-4">
                            <div className="flex items-start justify-between">
                                <div>
                                    <CardTitle className="flex items-center gap-2 text-xl text-slate-900">
                                        <Brain className="h-6 w-6 text-blue-600" />
                                        Diagnostic Automatisé (IA)
                                    </CardTitle>
                                    <CardDescription className="mt-1.5 text-base text-slate-900 font-medium">
                                        {report.aiDiagnosticName || "Analyse non concluante"}
                                    </CardDescription>
                                </div>
                                {report.aiConfidenceScore && (
                                    <div className="flex flex-col items-end">
                                        <span className="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1">Confiance</span>
                                        <div className="flex items-center gap-2">
                                            <div className="w-24 h-2 bg-slate-200 rounded-full overflow-hidden">
                                                <div
                                                    className={`h-full ${report.aiConfidenceScore > 80 ? 'bg-green-500' : report.aiConfidenceScore > 50 ? 'bg-amber-500' : 'bg-red-500'}`}
                                                    style={{ width: `${report.aiConfidenceScore}%` }}
                                                />
                                            </div>
                                            <span className="font-bold text-slate-700">{report.aiConfidenceScore}%</span>
                                        </div>
                                    </div>
                                )}
                            </div>
                        </CardHeader>
                        <CardContent className="pt-6">
                            <div className="space-y-4">
                                <div>
                                    <h4 className="text-sm font-semibold text-slate-500 uppercase tracking-wider mb-2 flex items-center gap-2">
                                        <Info className="h-4 w-4" />
                                        Raisonnement Clinique
                                    </h4>
                                    <div className="bg-slate-50 p-4 rounded-lg border border-slate-100 text-slate-700 leading-relaxed min-h-[100px]">
                                        {report.aiDiagnosticReasoning ? (
                                            <p>{report.aiDiagnosticReasoning}</p>
                                        ) : (
                                            <p className="italic text-slate-400">Le modèle n'a pas fourni de raisonnement détaillé pour ce cas.</p>
                                        )}
                                    </div>
                                </div>

                                {report.protocol && (
                                    <div className="mt-6 pt-6 border-t border-slate-100">
                                        <h4 className="text-sm font-semibold text-slate-500 uppercase tracking-wider mb-2 flex items-center gap-2">
                                            <Activity className="h-4 w-4" />
                                            Protocole Médical Suggéré
                                        </h4>
                                        <div className="flex items-center justify-between bg-blue-50 border border-blue-100 p-4 rounded-lg">
                                            <div>
                                                <p className="font-semibold text-blue-900">{report.protocol.name}</p>
                                                <p className="text-sm text-blue-700 mt-0.5">Ce protocole a été recommandé par l'agent sur le terrain sur base de ce diagnostic.</p>
                                            </div>
                                            <Button variant="outline" className="text-blue-700 border-blue-300 bg-white hover:bg-blue-50 shrink-0">
                                                Voir le Protocole
                                            </Button>
                                        </div>
                                    </div>
                                )}
                            </div>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader className="pb-3">
                            <CardTitle className="text-lg">Notes du Superviseur</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <textarea
                                className="w-full min-h-[120px] p-3 border border-slate-200 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none resize-y"
                                placeholder="Ajouter des notes médicales ou justifier la validation/le rejet de ce diagnostic..."
                            />
                        </CardContent>
                    </Card>

                </div>
            </div>
        </div>
    );
}
