"use client";

import { useEffect, useState } from "react";
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogHeader,
    DialogTitle,
} from "@/components/ui/dialog";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { AgentService, AgentDetail } from "@/services/agent.service";
import { AgentPerformanceChart } from "./AgentPerformanceChart";
import { Doughnut } from "react-chartjs-2";
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from "chart.js";

ChartJS.register(ArcElement, Tooltip, Legend);

interface AgentDetailModalProps {
    agentId: string | null;
    open: boolean;
    onClose: () => void;
}

export function AgentDetailModal({ agentId, open, onClose }: AgentDetailModalProps) {
    const [data, setData] = useState<AgentDetail | null>(null);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        if (agentId && open) {
            const fetchData = async () => {
                try {
                    setLoading(true);
                    const detail = await AgentService.getAgentDetail(agentId);
                    setData(detail);
                } catch (error) {
                    console.error("Error fetching agent detail:", error);
                } finally {
                    setLoading(false);
                }
            };
            fetchData();
        }
    }, [agentId, open]);

    if (!data && !loading) return null;

    const urgencyData = data
        ? {
            labels: ["Normal", "Urgent", "Critique"],
            datasets: [
                {
                    data: [
                        data.stats.casesByUrgency.normal,
                        data.stats.casesByUrgency.urgent,
                        data.stats.casesByUrgency.critical,
                    ],
                    backgroundColor: [
                        "rgba(34, 197, 94, 0.8)",
                        "rgba(251, 146, 60, 0.8)",
                        "rgba(239, 68, 68, 0.8)",
                    ],
                },
            ],
        }
        : null;

    return (
        <Dialog open={open} onOpenChange={onClose}>
            <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
                <DialogHeader>
                    <DialogTitle>{data?.agent.name || "Chargement..."}</DialogTitle>
                    <DialogDescription>
                        {data?.agent.zone && `Zone: ${data.agent.zone}`}
                        {data?.agent.phone && ` • Tel: ${data.agent.phone}`}
                    </DialogDescription>
                </DialogHeader>

                {loading && (
                    <div className="flex items-center justify-center py-8">
                        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
                    </div>
                )}

                {data && (
                    <div className="space-y-6">
                        {/* Stats Overview */}
                        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <Card>
                                <CardHeader className="pb-2">
                                    <CardTitle className="text-sm font-medium">Total Visites</CardTitle>
                                </CardHeader>
                                <CardContent>
                                    <div className="text-2xl font-bold">{data.stats.totalVisits}</div>
                                </CardContent>
                            </Card>
                            <Card>
                                <CardHeader className="pb-2">
                                    <CardTitle className="text-sm font-medium">Cas Reportés</CardTitle>
                                </CardHeader>
                                <CardContent>
                                    <div className="text-2xl font-bold">{data.stats.casesReported}</div>
                                </CardContent>
                            </Card>
                            <Card>
                                <CardHeader className="pb-2">
                                    <CardTitle className="text-sm font-medium">Cas Résolus</CardTitle>
                                </CardHeader>
                                <CardContent>
                                    <div className="text-2xl font-bold">{data.stats.casesResolved}</div>
                                </CardContent>
                            </Card>
                            <Card>
                                <CardHeader className="pb-2">
                                    <CardTitle className="text-sm font-medium">Score Performance</CardTitle>
                                </CardHeader>
                                <CardContent>
                                    <div className="text-2xl font-bold">{data.stats.performanceScore}/100</div>
                                </CardContent>
                            </Card>
                        </div>

                        {/* Charts */}
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <AgentPerformanceChart visitsByDay={data.stats.visitsByDay} />

                            <Card>
                                <CardHeader>
                                    <CardTitle>Cas par Urgence</CardTitle>
                                </CardHeader>
                                <CardContent className="flex items-center justify-center">
                                    {urgencyData && <Doughnut data={urgencyData} />}
                                </CardContent>
                            </Card>
                        </div>
                    </div>
                )}
            </DialogContent>
        </Dialog>
    );
}
