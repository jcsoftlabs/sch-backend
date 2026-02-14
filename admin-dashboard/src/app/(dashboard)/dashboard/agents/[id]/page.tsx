"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { DashboardSkeleton } from "@/components/skeletons";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Edit, Trash2 } from "lucide-react";
import { AgentService } from "@/services/agent.service";
import { AgentProfile } from "@/components/dashboard/agents/AgentProfile";
import { AgentStats } from "@/components/dashboard/agents/AgentStats";
import { AgentHistory } from "@/components/dashboard/agents/AgentHistory";
import { useToast } from "@/hooks/use-toast";
import { Agent } from "@/components/dashboard/AgentTable";

export default function AgentDetailsPage() {
    const params = useParams();
    const router = useRouter();
    const { toast } = useToast();
    const [agent, setAgent] = useState<Agent | null>(null);
    const [loading, setLoading] = useState(true);

    // Mock data for demo purposes
    const mockHistory = [
        { id: "c1", date: "2025-10-24", patientName: "J. Pierre", type: "Suivi HTA", status: "COMPLETED" },
        { id: "c2", date: "2025-10-22", patientName: "M. Joseph", type: "Visite Prénatale", status: "COMPLETED" },
        { id: "c3", date: "2025-10-20", patientName: "L. St-Fleur", type: "Vaccination", status: "COMPLETED" },
    ];

    const mockStats = {
        totalConsultations: 145,
        uniquePatients: 85,
        activeDays: 22,
        qualityScore: 4.8
    };

    useEffect(() => {
        const fetchAgent = async () => {
            try {
                // In a real app, fetch by ID. 
                // For now, getting all and finding one, or falling back to mock.
                // const data = await AgentService.getById(params.id as string);

                // MOCK
                await new Promise(r => setTimeout(r, 800));
                setAgent({
                    id: params.id as string,
                    name: "Jean Baptiste",
                    userId: "AGT-001",
                    email: "jean.baptiste@mspp.ht",
                    phone: "+509 3700-0000",
                    role: "AGENT",
                    status: "ACTIVE",
                    assignedZone: "Delmas 32",
                    deviceId: "TAB-0892",
                    lastSync: new Date().toISOString()
                } as any);

            } catch (error) {
                console.error(error);
                toast({
                    title: "Erreur",
                    description: "Impossible de charger les détails de l'agent",
                    variant: "destructive",
                });
            } finally {
                setLoading(false);
            }
        };

        if (params.id) {
            fetchAgent();
        }
    }, [params.id, toast]);

    if (loading) return <DashboardSkeleton />;
    if (!agent) return <div className="p-8">Agent non trouvé</div>;

    return (
        <div className="flex-1 space-y-6 p-8">
            {/* Header */}
            <div className="flex items-center justify-between">
                <div className="flex items-center space-x-4">
                    <Button variant="outline" size="icon" onClick={() => router.back()}>
                        <ArrowLeft className="h-4 w-4" />
                    </Button>
                    <div>
                        <h2 className="text-2xl font-bold tracking-tight text-slate-900">
                            {agent.name}
                        </h2>
                        <p className="text-slate-500">
                            Détails et performances de l'agent
                        </p>
                    </div>
                </div>
                <div className="flex space-x-2">
                    <Button variant="outline">
                        <Edit className="mr-2 h-4 w-4" />
                        Modifier
                    </Button>
                    <Button variant="destructive">
                        <Trash2 className="mr-2 h-4 w-4" />
                        Désactiver
                    </Button>
                </div>
            </div>

            {/* Content Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">

                {/* Left Column: Profile */}
                <div className="lg:col-span-1">
                    <AgentProfile agent={agent} />
                </div>

                {/* Right Column: Stats & History */}
                <div className="lg:col-span-2 space-y-6">
                    <AgentStats stats={mockStats} />

                    <div className="space-y-4">
                        <h3 className="text-lg font-semibold text-slate-900">Historique Récent</h3>
                        <AgentHistory history={mockHistory} />
                    </div>
                </div>
            </div>
        </div>
    );
}
