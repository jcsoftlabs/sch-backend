"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Activity, CreditCard, DollarSign, Users, Loader2, UserCog } from "lucide-react";
import { ConsultationChart } from "@/components/dashboard/ConsultationChart";
import { StatsService, DashboardStats } from "@/services/stats.service";
import { ConsultationService } from "@/services/consultation.service";
import { DashboardSkeleton } from "@/components/skeletons";
import { useEffect, useState } from "react";

export default function DashboardPage() {
    const [stats, setStats] = useState<DashboardStats | null>(null);
    const [recentConsultations, setRecentConsultations] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchStats = async () => {
            try {
                const [statsData, consultationsData] = await Promise.all([
                    StatsService.getOverview(),
                    ConsultationService.getAll()
                ]);
                setStats(statsData);
                // Sort by date desc and take top 5
                const sorted = consultationsData
                    .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
                    .slice(0, 5);
                setRecentConsultations(sorted);
            } catch (error) {
                console.error(error);
            } finally {
                setLoading(false);
            }
        }
        fetchStats();
    }, []);

    if (loading) {
        return <DashboardSkeleton />
    }

    return (
        <div className="flex-1 space-y-4">
            <div className="flex items-center justify-between space-y-2">
                <h2 className="text-3xl font-bold tracking-tight">Tableau de bord</h2>
            </div>
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
                <Card>
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-sm font-medium">
                            Consultations Totales
                        </CardTitle>
                        <Activity className="h-4 w-4 text-muted-foreground" />
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold">{stats?.totalConsultations || 0}</div>
                        <p className="text-xs text-muted-foreground">
                            Total enregistré
                        </p>
                    </CardContent>
                </Card>
                <Card>
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-sm font-medium">
                            Patients Actifs
                        </CardTitle>
                        <Users className="h-4 w-4 text-muted-foreground" />
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold">{stats?.activePatients || 0}</div>
                        <p className="text-xs text-muted-foreground">
                            Patients inscrits
                        </p>
                    </CardContent>
                </Card>
                <Card>
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-sm font-medium">Centres de Santé</CardTitle>
                        <CreditCard className="h-4 w-4 text-muted-foreground" />
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold">{stats?.totalCenters || 0}</div>
                        <p className="text-xs text-muted-foreground">
                            Partenaires actifs
                        </p>
                    </CardContent>
                </Card>
                <Card>
                    <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                        <CardTitle className="text-sm font-medium">
                            Agents Actifs
                        </CardTitle>
                        <UserCog className="h-4 w-4 text-muted-foreground" />
                    </CardHeader>
                    <CardContent>
                        <div className="text-2xl font-bold">{stats?.activeAgents || 0}</div>
                        <p className="text-xs text-muted-foreground">
                            Personnel du système
                        </p>
                    </CardContent>
                </Card>
            </div>
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
                <Card className="col-span-4">
                    <CardHeader>
                        <CardTitle>Aperçu</CardTitle>
                    </CardHeader>
                    <CardContent className="pl-2">
                        <ConsultationChart />
                    </CardContent>
                </Card>
                <Card className="col-span-3">
                    <CardHeader>
                        <CardTitle>Consultations Récentes</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="space-y-8">
                            {loading ? (
                                <div className="flex items-center justify-center py-4">
                                    <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
                                </div>
                            ) : recentConsultations.length === 0 ? (
                                <p className="text-sm text-muted-foreground text-center py-4">Aucune consultation récente</p>
                            ) : (
                                recentConsultations.map((consultation) => (
                                    <div key={consultation.id} className="flex items-center">
                                        <div className="space-y-1">
                                            <p className="text-sm font-medium leading-none">
                                                {consultation.patient.firstName} {consultation.patient.lastName}
                                            </p>
                                            <p className="text-xs text-muted-foreground">
                                                {consultation.doctor?.name || "Médecin non assigné"}
                                            </p>
                                        </div>
                                        <div className="ml-auto font-medium text-xs text-muted-foreground">
                                            {new Date(consultation.createdAt).toLocaleDateString()}
                                        </div>
                                    </div>
                                ))
                            )}
                        </div>
                    </CardContent>
                </Card>
            </div>
        </div>
    );
}
