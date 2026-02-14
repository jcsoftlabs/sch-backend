"use client";

import { AgentKPICards } from "@/components/dashboard/agents-kpi/AgentKPICards";
import { AgentLeaderboard } from "@/components/dashboard/agents-kpi/AgentLeaderboard";
import { AgentPerformanceChart } from "@/components/dashboard/agents-kpi/AgentPerformanceChart";
import { Button } from "@/components/ui/button";
import { Download } from "lucide-react";

// Mock Data
const MOCK_STATS = {
    totalAgents: 45,
    activeAgents: 38,
    activePercentage: 84,
    monthlyConsultations: 1250,
    avgConsultations: 28,
    qualityScore: 9.2
};

const MOCK_AGENTS = [
    { id: "1", name: "Jean Baptiste", zone: "Delmas 32", consultations: 145, score: 9.5 },
    { id: "2", name: "Marie Pierre", zone: "Pétition-Ville", consultations: 132, score: 9.2 },
    { id: "3", name: "Paul Dumas", zone: "Carrefour", consultations: 128, score: 8.9 },
    { id: "4", name: "Sophie Charles", zone: "Cité Soleil", consultations: 115, score: 9.0 },
    { id: "5", name: "Luc Michel", zone: "Tabarre", consultations: 98, score: 8.5 },
    { id: "6", name: "Antoinette Joseph", zone: "Delmas 19", consultations: 85, score: 8.8 },
];

const MOCK_CHART_DATA = [
    { name: "Lun", consultations: 120 },
    { name: "Mar", consultations: 145 },
    { name: "Mer", consultations: 132 },
    { name: "Jeu", consultations: 155 },
    { name: "Ven", consultations: 140 },
    { name: "Sam", consultations: 90 },
    { name: "Dim", consultations: 45 },
];

export default function AgentKPIPage() {
    return (
        <div className="flex-1 space-y-8 p-8 pt-6">
            <div className="flex items-center justify-between space-y-2">
                <div>
                    <h2 className="text-3xl font-bold tracking-tight">Performance des Agents</h2>
                    <p className="text-muted-foreground">
                        Tableau de bord de suivi de la productivité et de la qualité des soins.
                    </p>
                </div>
                <div className="flex items-center space-x-2">
                    <Button>
                        <Download className="mr-2 h-4 w-4" />
                        Exporter Données
                    </Button>
                </div>
            </div>

            <AgentKPICards stats={MOCK_STATS} />

            <div className="grid grid-cols-1 md:grid-cols-7 gap-6">
                <div className="md:col-span-4">
                    <AgentPerformanceChart data={MOCK_CHART_DATA} />
                </div>
                <div className="md:col-span-3">
                    <AgentLeaderboard agents={MOCK_AGENTS} />
                </div>
            </div>
        </div>
    );
}
