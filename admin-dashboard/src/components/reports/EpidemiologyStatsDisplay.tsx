"use client";

import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ReportService, EpidemiologyStats } from "@/services/report.service";
import { TrendingUp, TrendingDown, Minus } from "lucide-react";

interface EpidemiologyStatsDisplayProps {
    startDate?: string;
    endDate?: string;
}

export function EpidemiologyStatsDisplay({ startDate, endDate }: EpidemiologyStatsDisplayProps) {
    const [stats, setStats] = useState<EpidemiologyStats[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchStats = async () => {
            try {
                setLoading(true);
                const data = await ReportService.getEpidemiologyStats(startDate, endDate);
                setStats(data);
            } catch (error) {
                console.error("Error fetching epidemiology stats:", error);
            } finally {
                setLoading(false);
            }
        };
        fetchStats();
    }, [startDate, endDate]);

    const getTrendIcon = (trend: string) => {
        switch (trend) {
            case "UP":
                return <TrendingUp className="h-4 w-4 text-red-500" />;
            case "DOWN":
                return <TrendingDown className="h-4 w-4 text-green-500" />;
            case "STABLE":
                return <Minus className="h-4 w-4 text-gray-500" />;
            default:
                return null;
        }
    };

    if (loading) {
        return (
            <Card>
                <CardContent className="py-8">
                    <div className="flex items-center justify-center">
                        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
                    </div>
                </CardContent>
            </Card>
        );
    }

    return (
        <Card>
            <CardHeader>
                <CardTitle>Statistiques Épidémiologiques par Zone</CardTitle>
            </CardHeader>
            <CardContent>
                {stats.length === 0 ? (
                    <p className="text-center py-8 text-slate-500">
                        Aucune donnée disponible pour cette période
                    </p>
                ) : (
                    <div className="space-y-6">
                        {stats.map((zoneStat) => (
                            <div key={zoneStat.zone} className="border-b pb-4 last:border-b-0">
                                <div className="flex items-center justify-between mb-3">
                                    <h3 className="font-semibold text-lg">{zoneStat.zone}</h3>
                                    <span className="text-sm text-slate-500">
                                        {zoneStat.totalCases} cas total
                                    </span>
                                </div>
                                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                                    {zoneStat.diseases.map((disease) => (
                                        <div
                                            key={disease.name}
                                            className="p-3 bg-gray-50 rounded-lg flex items-center justify-between"
                                        >
                                            <div>
                                                <p className="font-medium text-sm">{disease.name}</p>
                                                <p className="text-2xl font-bold">{disease.count}</p>
                                            </div>
                                            <div className="flex items-center gap-1">
                                                {getTrendIcon(disease.trend)}
                                                <span className="text-xs text-slate-500">
                                                    {disease.trend}
                                                </span>
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </CardContent>
        </Card>
    );
}
