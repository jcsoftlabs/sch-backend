"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Line } from "react-chartjs-2";
import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend,
} from "chart.js";

ChartJS.register(
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend
);

interface AgentPerformanceChartProps {
    visitsByDay: { date: string; count: number }[];
}

export function AgentPerformanceChart({ visitsByDay }: AgentPerformanceChartProps) {
    const data = {
        labels: visitsByDay.map((v) => new Date(v.date).toLocaleDateString("fr-FR", { month: "short", day: "numeric" })),
        datasets: [
            {
                label: "Visites par jour",
                data: visitsByDay.map((v) => v.count),
                borderColor: "rgb(59, 130, 246)",
                backgroundColor: "rgba(59, 130, 246, 0.1)",
                tension: 0.4,
            },
        ],
    };

    const options = {
        responsive: true,
        plugins: {
            legend: {
                position: "top" as const,
            },
            title: {
                display: false,
            },
        },
        scales: {
            y: {
                beginAtZero: true,
            },
        },
    };

    return (
        <Card>
            <CardHeader>
                <CardTitle>Performance sur 30 jours</CardTitle>
            </CardHeader>
            <CardContent>
                <Line data={data} options={options} />
            </CardContent>
        </Card>
    );
}
