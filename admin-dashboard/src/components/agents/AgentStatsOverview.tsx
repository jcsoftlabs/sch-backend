"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, Activity, Clock, TrendingUp } from "lucide-react";

interface AgentStatsOverviewProps {
    totalAgents: number;
    activeAgents: number;
    avgVisitsPerDay: number;
    avgResponseTime: number;
}

export function AgentStatsOverview({
    totalAgents,
    activeAgents,
    avgVisitsPerDay,
    avgResponseTime,
}: AgentStatsOverviewProps) {
    const stats = [
        {
            title: "Total Agents",
            value: totalAgents,
            icon: Users,
            color: "text-blue-600",
            bgColor: "bg-blue-100",
        },
        {
            title: "Agents Actifs",
            value: activeAgents,
            icon: Activity,
            color: "text-green-600",
            bgColor: "bg-green-100",
        },
        {
            title: "Visites/Jour",
            value: avgVisitsPerDay.toFixed(1),
            icon: TrendingUp,
            color: "text-purple-600",
            bgColor: "bg-purple-100",
        },
        {
            title: "Temps Réponse Moy.",
            value: `${avgResponseTime} min`,
            icon: Clock,
            color: "text-orange-600",
            bgColor: "bg-orange-100",
        },
    ];

    return (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            {stats.map((stat) => (
                <Card key={stat.title}>
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-sm font-medium">{stat.title}</CardTitle>
                        <div className={`p-2 rounded-lg ${stat.bgColor}`}>
                            <stat.icon className={`h-4 w-4 ${stat.color}`} />
                        </div>
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold">{stat.value}</div>
                    </CardContent>
                </Card>
            ))}
        </div>
    );
}
