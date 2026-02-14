"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Trophy, TrendingUp, UserCheck } from "lucide-react";

interface Agent {
    id: string;
    name: string;
    zone: string;
    consultations: number;
    score: number;
    avatar?: string;
}

export function AgentLeaderboard({ agents }: { agents: Agent[] }) {
    const sortedAgents = [...agents].sort((a, b) => b.consultations - a.consultations).slice(0, 5);

    return (
        <Card className="h-full">
            <CardHeader>
                <CardTitle className="flex items-center gap-2">
                    <Trophy className="h-5 w-5 text-yellow-500" />
                    Top Agents
                </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
                {sortedAgents.map((agent, index) => (
                    <div key={agent.id} className="flex items-center justify-between p-3 bg-slate-50 rounded-lg hover:bg-slate-100 transition-colors">
                        <div className="flex items-center gap-3">
                            <div className="relative font-bold text-slate-400 w-6 text-center">
                                {index + 1}
                                {index === 0 && <span className="absolute -top-1 -right-2 text-yellow-500 text-xs">👑</span>}
                            </div>
                            <Avatar>
                                <AvatarImage src={agent.avatar} />
                                <AvatarFallback className="bg-blue-100 text-blue-700 font-bold">
                                    {agent.name.substring(0, 2).toUpperCase()}
                                </AvatarFallback>
                            </Avatar>
                            <div>
                                <p className="font-semibold text-sm text-slate-900">{agent.name}</p>
                                <p className="text-xs text-slate-500">{agent.zone}</p>
                            </div>
                        </div>
                        <div className="text-right">
                            <p className="font-bold text-slate-900">{agent.consultations}</p>
                            <p className="text-[10px] text-slate-500 uppercase">Consultations</p>
                        </div>
                    </div>
                ))}
            </CardContent>
        </Card>
    );
}
