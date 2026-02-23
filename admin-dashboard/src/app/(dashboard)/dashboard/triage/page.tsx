"use client";

import { columns } from "@/components/dashboard/TriageTable";
import { DataTable } from "@/components/ui/data-table";
import { TriageService, TriageReport } from "@/services/triage.service";
import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2 } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

export default function TriageListPage() {
    const router = useRouter();
    const [data, setData] = useState<TriageReport[]>([]);
    const [loading, setLoading] = useState(true);
    const { toast } = useToast();

    const fetchData = async () => {
        try {
            const reports = await TriageService.getAll();
            setData(reports);
        } catch (error) {
            console.error("Failed to load triage reports", error);
            toast({
                title: "Erreur",
                description: "Impossible de charger les rapports de triage",
                variant: "destructive",
            });
            // Mock data for development if the backend API endpoint is not yet ready:
            setData([
                {
                    id: "evt-1234",
                    patientId: "pat-123",
                    createdBy: "user-1",
                    symptoms: ["Fièvre élevée", "Toux sèche", "Perte d'odorat"],
                    aiDiagnosticName: "Suspicion de COVID-19",
                    aiDiagnosticReasoning: "Les symptômes déclarés correspondent fortement aux critères diagnostiques de l'infection virale respiratoire sévère.",
                    aiConfidenceScore: 92,
                    urgencyLevel: "ELEVEE",
                    medicalProtocolId: "prot-1",
                    createdAt: new Date().toISOString(),
                    updatedAt: new Date().toISOString(),
                    validationStatus: "PENDING",
                    validatedBy: null,
                    validatedAt: null,
                    patient: { id: "pat-123", firstName: "Jean", lastName: "Jacques" }
                },
                {
                    id: "evt-2345",
                    patientId: null,
                    createdBy: "user-2",
                    symptoms: ["Céphalées mineures", "Fatigue"],
                    aiDiagnosticName: "Céphalée de tension",
                    aiDiagnosticReasoning: "Absence de signes d'alerte. Céphalées isolées probables liées au stress ou à la fatigue.",
                    aiConfidenceScore: 85,
                    urgencyLevel: "FAIBLE",
                    medicalProtocolId: "prot-2",
                    createdAt: new Date(Date.now() - 86400000).toISOString(),
                    updatedAt: new Date(Date.now() - 86400000).toISOString(),
                    validationStatus: "VALIDATED",
                    validatedBy: "admin-1",
                    validatedAt: new Date(Date.now() - 3600000).toISOString(),
                }
            ]);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);

    const tableColumns = columns; // Reuse the createColumns output

    if (loading) {
        return <div className="flex h-full items-center justify-center"><Loader2 className="h-8 w-8 animate-spin" /></div>
    }

    return (
        <div className="flex h-full flex-1 flex-col space-y-8 p-8 md:flex">
            <div className="flex items-center justify-between space-y-2">
                <div>
                    <h2 className="text-2xl font-bold tracking-tight text-slate-900">Rapports de Triage IA</h2>
                    <p className="text-slate-500">
                        Liste des diagnostics automatisés réalisés sur le terrain pour validation médicale.
                    </p>
                </div>
            </div>

            <DataTable
                data={data}
                columns={tableColumns}
                searchKey="aiDiagnosticName"
                onRowClick={(report) => router.push(`/dashboard/triage/${report.id}`)}
            />
        </div>
    );
}
