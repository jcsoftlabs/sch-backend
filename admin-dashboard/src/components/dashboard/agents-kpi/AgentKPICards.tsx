"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, Activity, CheckCircle2, TrendingUp } from "lucide-react";

export function AgentKPICards({ stats }: { stats: any }) {
    return (
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
            <Card>
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">Total Agents Actifs</CardTitle>
                    <Users className="h-4 w-4 text-slate-500" />
                </CardHeader>
                <CardContent>
                    <div className="text-2xl font-bold">{stats.activeAgents} / {stats.totalAgents}</div>
                    <p className="text-xs text-slate-500 flex items-center mt-1">
                        <CheckCircle2 className="h-3 w-3 mr-1 text-green-500" />
                        {stats.activePercentage}% Taux d'activité
                    </p>
                </CardContent>
            </Card>

            <Card>
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">Consultations (Ce mois)</CardTitle>
                    <Activity className="h-4 w-4 text-slate-500" />
                </CardHeader>
                <CardContent>
                    <div className="text-2xl font-bold">{stats.monthlyConsultations}</div>
                    <p className="text-xs text-slate-500 flex items-center mt-1">
                        <TrendingUp className="h-3 w-3 mr-1 text-green-500" />
                        +12% vs mois dernier
                    </p>
                </CardContent>
            </Card>

            <Card>
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">Moy. Consultations/Agent</CardTitle>
                    <Users className="h-4 w-4 text-slate-500" />
                </CardHeader>
                <CardContent>
                    <div className="text-2xl font-bold">{stats.avgConsultations}</div>
                    <p className="text-xs text-slate-500 mt-1">
                        Par semaine
                    </p>
                </CardContent>
            </Card>

            <Card>
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">Score Qualité Moyen</CardTitle>
                    <Award className="h-4 w-4 text-slate-500" />
                </CardHeader>
                <CardContent>
                    <div className="text-2xl font-bold">{stats.qualityScore}/10</div>
                    <p className="text-xs text-slate-500 mt-1 text-green-600 font-medium">
                        Excellent
                    </p>
                </CardContent>
            </Card>
        </div>
    );
}

function Award(props: any) {
    return (
        <svg
            {...props}
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
        >
            <circle cx="12" cy="8" r="7" />
            <polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88" />
        </svg>
    )
}
