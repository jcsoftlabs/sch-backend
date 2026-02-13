"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Activity, Users, CreditCard, UserCog, Loader2, Download, FileText } from "lucide-react";
import { ConsultationService, Consultation } from "@/services/consultation.service";
import { StatsService, DashboardStats } from "@/services/stats.service";
import { ConsultationTrends } from "@/components/dashboard/charts/ConsultationTrends";
import { DiseaseDistribution } from "@/components/dashboard/charts/DiseaseDistribution";
import { AgentPerformance } from "@/components/dashboard/charts/AgentPerformance";
import { DashboardSkeleton } from "@/components/skeletons";
import { useEffect, useState } from "react";
import { DateRangePicker } from "@/components/dashboard/filters/DateRangePicker";
import { LocationFilter } from "@/components/dashboard/filters/LocationFilter";
import { Button } from "@/components/ui/button";
import { exportToCSV, exportToPDF } from "@/lib/exportUtils";

export default function DashboardPage() {
    const [stats, setStats] = useState<DashboardStats | null>(null);
    const [recentConsultations, setRecentConsultations] = useState<Consultation[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        // Mock data fetch
        const fetchData = async () => {
            try {
                // ... (existing mock logic)
                // Simulate delay
                await new Promise(resolve => setTimeout(resolve, 1500));

                setStats({
                    totalConsultations: 1245,
                    activePatients: 850,
                    totalCenters: 12,
                    activeAgents: 45,
                    revenue: 0
                });

                // Mock mock consultations
                setRecentConsultations([
                    { id: "1", patient: { firstName: "Jean", lastName: "Pierre" }, doctor: { name: "Dr. Paul" }, createdAt: new Date().toISOString(), status: "COMPLETED", patientId: "p1" },
                    { id: "2", patient: { firstName: "Marie", lastName: "Joseph" }, doctor: { name: "Dr. Sarah" }, createdAt: new Date().toISOString(), status: "PENDING", patientId: "p2" },
                    { id: "3", patient: { firstName: "Luc", lastName: "Saint-Fleur" }, doctor: { name: "Dr. Marc" }, createdAt: new Date().toISOString(), status: "ACCEPTED", patientId: "p3" },
                ]);

            } catch (error) {
                console.error(error);
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, []);

    const handleExportCSV = () => {
        // Mock data for export
        const data = recentConsultations.map(c => ({
            Patient: `${c.patient.firstName} ${c.patient.lastName}`,
            Medecin: c.doctor?.name,
            Date: new Date(c.createdAt).toLocaleDateString(),
            Statut: c.status
        }));
        exportToCSV(data, "consultations_export");
    };

    const handleExportPDF = () => {
        // Mock data for export
        const data = recentConsultations.map(c => [
            `${c.patient.firstName} ${c.patient.lastName}`,
            c.doctor?.name || "N/A",
            new Date(c.createdAt).toLocaleDateString(),
            c.status
        ]);
        exportToPDF("Rapport des Consultations Récentes", ["Patient", "Médecin", "Date", "Statut"], data, "rapport_consultations");
    };

    if (loading) {
        return <DashboardSkeleton />
    }

    return (
        <div className="flex-1 space-y-4">
            <div className="flex flex-col md:flex-row md:items-center justify-between space-y-2 md:space-y-0 pb-4">
                <h2 className="text-3xl font-bold tracking-tight text-slate-900">Tableau de bord</h2>
                <div className="flex flex-col sm:flex-row items-start sm:items-center gap-2">
                    <LocationFilter />
                    <DateRangePicker />
                    <div className="flex items-center gap-2 w-full sm:w-auto mt-2 sm:mt-0">
                        <Button variant="outline" size="icon" onClick={handleExportCSV} title="Exporter en CSV">
                            <FileText className="h-4 w-4 text-slate-600" />
                        </Button>
                        <Button variant="outline" size="icon" onClick={handleExportPDF} title="Exporter en PDF">
                            <Download className="h-4 w-4 text-slate-600" />
                        </Button>
                    </div>
                </div>
            </div>
            <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
                <Card className="stat-card-primary animate-fade-in">
                    <CardHeader className="flex flex-row items-center justify-between pb-2">
                        <CardTitle className="text-sm font-semibold text-slate-900">
                            Consultations Totales
                        </CardTitle>
                        <div className="h-10 w-10 rounded-lg bg-blue-100 flex items-center justify-center">
                            <Activity className="h-5 w-5 text-blue-600" />
                        </div>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold text-slate-900">
                            {stats?.totalConsultations || 0}
                        </div>
                        <div className="flex items-center gap-2 mt-2">
                            <div className="badge-success flex items-center gap-1">
                                <svg className="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                                </svg>
                                <span>+12.5%</span>
                            </div>
                            <p className="text-xs text-slate-700 font-medium">vs. mois dernier</p>
                        </div>
                    </CardContent>
                </Card>

                <Card className="stat-card-secondary animate-fade-in" style={{ animationDelay: '0.1s' }}>
                    <CardHeader className="flex flex-row items-center justify-between pb-2">
                        <CardTitle className="text-sm font-semibold text-slate-900">
                            Patients Actifs
                        </CardTitle>
                        <div className="h-10 w-10 rounded-lg bg-green-100 flex items-center justify-center">
                            <Users className="h-5 w-5 text-green-600" />
                        </div>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold text-slate-900">
                            {stats?.activePatients || 0}
                        </div>
                        <div className="flex items-center gap-2 mt-2">
                            <div className="badge-success flex items-center gap-1">
                                <svg className="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                                </svg>
                                <span>+8.2%</span>
                            </div>
                            <p className="text-xs text-slate-700 font-medium">nouveaux patients</p>
                        </div>
                    </CardContent>
                </Card>

                <Card className="stat-card-accent animate-fade-in" style={{ animationDelay: '0.2s' }}>
                    <CardHeader className="flex flex-row items-center justify-between pb-2">
                        <CardTitle className="text-sm font-semibold text-slate-900">
                            Centres de Santé
                        </CardTitle>
                        <div className="h-10 w-10 rounded-lg bg-orange-100 flex items-center justify-center">
                            <CreditCard className="h-5 w-5 text-orange-600" />
                        </div>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold text-slate-900">
                            {stats?.totalCenters || 0}
                        </div>
                        <div className="flex items-center gap-2 mt-2">
                            <div className="badge-info flex items-center gap-1">
                                <svg className="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 12h14" />
                                </svg>
                                <span>Stable</span>
                            </div>
                            <p className="text-xs text-slate-700 font-medium">partenaires actifs</p>
                        </div>
                    </CardContent>
                </Card>

                <Card className="stat-card-warning animate-fade-in" style={{ animationDelay: '0.3s' }}>
                    <CardHeader className="flex flex-row items-center justify-between pb-2">
                        <CardTitle className="text-sm font-semibold text-slate-900">
                            Agents Actifs
                        </CardTitle>
                        <div className="h-10 w-10 rounded-lg bg-amber-100 flex items-center justify-center">
                            <UserCog className="h-5 w-5 text-amber-600" />
                        </div>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold text-slate-900">
                            {stats?.activeAgents || 0}
                        </div>
                        <div className="flex items-center gap-2 mt-2">
                            <div className="badge-success flex items-center gap-1">
                                <svg className="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                                </svg>
                                <span>+5.1%</span>
                            </div>
                            <p className="text-xs text-slate-700 font-medium">personnel actif</p>
                        </div>
                    </CardContent>
                </Card>
            </div>
            {/* Analytics Section */}
            <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-7 pt-4">
                <ConsultationTrends />
                <DiseaseDistribution />
            </div>

            <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-7">
                <AgentPerformance />

                <Card className="col-span-3 animate-fade-in card-elevated" style={{ animationDelay: '0.3s' }}>
                    <CardHeader>
                        <CardTitle className="text-base font-semibold text-slate-900">Consultations Récentes</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="space-y-6">
                            {loading ? (
                                <div className="flex items-center justify-center py-4">
                                    <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
                                </div>
                            ) : recentConsultations.length === 0 ? (
                                <p className="text-sm text-slate-500 text-center py-4">Aucune consultation récente</p>
                            ) : (
                                recentConsultations.slice(0, 5).map((consultation) => (
                                    <div key={consultation.id} className="flex items-center">
                                        <div className="h-9 w-9 rounded-full bg-slate-100 flex items-center justify-center mr-3">
                                            <p className="text-xs font-bold text-slate-700">
                                                {consultation.patient.firstName.charAt(0)}{consultation.patient.lastName.charAt(0)}
                                            </p>
                                        </div>
                                        <div className="space-y-1">
                                            <p className="text-sm font-medium leading-none text-slate-900">
                                                {consultation.patient.firstName} {consultation.patient.lastName}
                                            </p>
                                            <p className="text-xs text-slate-500">
                                                {consultation.doctor?.name || "Médecin non assigné"}
                                            </p>
                                        </div>
                                        <div className="ml-auto font-medium text-xs text-slate-500 bg-slate-100 px-2 py-1 rounded-full">
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
