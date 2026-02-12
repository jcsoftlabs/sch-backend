"use client";

import { useState } from "react";
import { useAgentStats } from "@/hooks/useAgentStats";
import { AgentFilters } from "@/services/agent.service";
import { AgentStatsOverview } from "@/components/agents/AgentStatsOverview";
import { AgentRankingTable } from "@/components/agents/AgentRankingTable";
import { AgentFiltersComponent } from "@/components/agents/AgentFilters";
import { AgentDetailModal } from "@/components/agents/AgentDetailModal";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

export default function AgentKPIPage() {
    const [filters, setFilters] = useState<AgentFilters>({});
    const [selectedAgentId, setSelectedAgentId] = useState<string | null>(null);
    const [modalOpen, setModalOpen] = useState(false);
    const { data, loading, error } = useAgentStats(filters);

    const handleViewDetails = (agentId: string) => {
        setSelectedAgentId(agentId);
        setModalOpen(true);
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center h-screen">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
                    <p className="mt-4 text-muted-foreground">Chargement des KPIs agents...</p>
                </div>
            </div>
        );
    }

    if (error) {
        return (
            <div className="flex items-center justify-center h-screen">
                <Card className="w-96">
                    <CardHeader>
                        <CardTitle className="text-destructive">Erreur</CardTitle>
                        <CardDescription>
                            Impossible de charger les statistiques des agents
                        </CardDescription>
                    </CardHeader>
                    <CardContent>
                        <p className="text-sm text-muted-foreground">{error.message}</p>
                    </CardContent>
                </Card>
            </div>
        );
    }

    return (
        <div className="space-y-6 p-6">
            <div>
                <h1 className="text-3xl font-bold">KPIs Agents</h1>
                <p className="text-muted-foreground">
                    Statistiques et performances des agents de santé communautaire
                </p>
            </div>

            <AgentFiltersComponent onFiltersChange={setFilters} />

            {data && (
                <>
                    <AgentStatsOverview
                        totalAgents={data.totalAgents}
                        activeAgents={data.activeAgents}
                        avgVisitsPerDay={data.avgVisitsPerDay}
                        avgResponseTime={data.avgResponseTime}
                    />

                    <AgentRankingTable
                        topPerformers={data.topPerformers}
                        onViewDetails={handleViewDetails}
                    />
                </>
            )}

            <AgentDetailModal
                agentId={selectedAgentId}
                open={modalOpen}
                onClose={() => setModalOpen(false)}
            />
        </div>
    );
}
