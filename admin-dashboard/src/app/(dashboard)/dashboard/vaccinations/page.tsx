"use client";

import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Activity, ShieldCheck, AlertTriangle, Syringe, FileText, Download, Loader2 } from "lucide-react";
import { vaccinationService, VaccinationStats } from "@/services/vaccination.service";
import { Button } from "@/components/ui/button";
import { exportToCSV, exportToPDF } from "@/lib/exportUtils";

export default function VaccinationsDashboardPage() {
    const [stats, setStats] = useState<VaccinationStats | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchData = async () => {
            try {
                // In a real app we'd fetch from the backed:
                // const data = await vaccinationService.getStats();

                // For demonstration, simulating data payload
                await new Promise((resolve) => setTimeout(resolve, 800));

                setStats({
                    totalGiven: 3450,
                    dueToday: 42,
                    overdue: 115,
                    coverageByZone: [
                        { zone: "Nord", count: 1200 },
                        { zone: "Sud", count: 950 },
                        { zone: "Ouest", count: 1300 }
                    ],
                    recentVaccinations: [
                        { id: "1", patientId: "p1", vaccine: "Penta", doseNumber: 1, dateGiven: new Date().toISOString(), agentId: "a1", createdAt: new Date().toISOString(), Patient: { id: "p1", firstName: "Luc", lastName: "Paul" }, Agent: { id: "a1", firstName: "Marie", lastName: "Jeanne" } },
                        { id: "2", patientId: "p2", vaccine: "BCG", doseNumber: 1, dateGiven: new Date().toISOString(), agentId: "a2", createdAt: new Date().toISOString(), Patient: { id: "p2", firstName: "Sarah", lastName: "Michel" }, Agent: { id: "a2", firstName: "Jean", lastName: "Baptiste" } },
                    ]
                });
            } catch (error) {
                console.error("Failed to load vaccination stats", error);
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, []);

    const handleExportCSV = () => {
        if (!stats) return;
        const data = stats.recentVaccinations.map(v => ({
            Patient: `${v.Patient?.firstName} ${v.Patient?.lastName}`,
            Vaccin: v.vaccine,
            Dose: v.doseNumber,
            Date: new Date(v.dateGiven).toLocaleDateString(),
            Agent: `${v.Agent?.firstName} ${v.Agent?.lastName}`
        }));
        exportToCSV(data, "vaccinations_export");
    };

    const handleExportPDF = () => {
        if (!stats) return;
        const data = stats.recentVaccinations.map(v => [
            `${v.Patient?.firstName} ${v.Patient?.lastName}`,
            v.vaccine,
            v.doseNumber.toString(),
            new Date(v.dateGiven).toLocaleDateString(),
            `${v.Agent?.firstName} ${v.Agent?.lastName}`
        ]);
        exportToPDF("Rapport de Vaccination", ["Patient", "Vaccin", "Dose", "Date", "ASCP"], data, "rapport_vaccinations");
    };

    if (loading) {
        return (
            <div className="flex h-full items-center justify-center pt-24">
                <Loader2 className="h-8 w-8 animate-spin text-slate-500" />
            </div>
        );
    }

    return (
        <div className="flex-1 space-y-4 p-4 md:p-8">
            <div className="flex flex-col md:flex-row md:items-center justify-between space-y-2 md:space-y-0 pb-4">
                <h2 className="text-3xl font-bold tracking-tight text-slate-900">Vaccinations</h2>
                <div className="flex items-center gap-2">
                    <Button variant="outline" size="icon" onClick={handleExportCSV} title="Exporter en CSV">
                        <FileText className="h-4 w-4 text-slate-600" />
                    </Button>
                    <Button variant="outline" size="icon" onClick={handleExportPDF} title="Exporter en PDF">
                        <Download className="h-4 w-4 text-slate-600" />
                    </Button>
                </div>
            </div>

            {/* Top Stat Cards */}
            <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
                <Card className="stat-card-primary animate-fade-in">
                    <CardHeader className="flex flex-row items-center justify-between pb-2">
                        <CardTitle className="text-sm font-semibold text-slate-900">
                            Doses Administrées
                        </CardTitle>
                        <div className="h-10 w-10 rounded-lg bg-blue-100 flex items-center justify-center">
                            <Activity className="h-5 w-5 text-blue-600" />
                        </div>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold text-slate-900">
                            {stats?.totalGiven || 0}
                        </div>
                        <p className="text-xs text-slate-500 mt-2 font-medium">Au total cette année</p>
                    </CardContent>
                </Card>

                <Card className="stat-card-secondary animate-fade-in" style={{ animationDelay: '0.1s' }}>
                    <CardHeader className="flex flex-row items-center justify-between pb-2">
                        <CardTitle className="text-sm font-semibold text-slate-900">
                            Couverture Globale
                        </CardTitle>
                        <div className="h-10 w-10 rounded-lg bg-green-100 flex items-center justify-center">
                            <ShieldCheck className="h-5 w-5 text-green-600" />
                        </div>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold text-slate-900">
                            85%
                        </div>
                        <p className="text-xs text-slate-500 mt-2 font-medium">Cible: 90%</p>
                    </CardContent>
                </Card>

                <Card className="stat-card-warning animate-fade-in" style={{ animationDelay: '0.2s' }}>
                    <CardHeader className="flex flex-row items-center justify-between pb-2">
                        <CardTitle className="text-sm font-semibold text-slate-900">
                            À Faire Aujourd'hui
                        </CardTitle>
                        <div className="h-10 w-10 rounded-lg bg-amber-100 flex items-center justify-center">
                            <Syringe className="h-5 w-5 text-amber-600" />
                        </div>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold text-slate-900">
                            {stats?.dueToday || 0}
                        </div>
                        <p className="text-xs text-slate-500 mt-2 font-medium">Rappels programmés</p>
                    </CardContent>
                </Card>

                <Card className="stat-card-accent animate-fade-in" style={{ animationDelay: '0.3s' }}>
                    <CardHeader className="flex flex-row items-center justify-between pb-2">
                        <CardTitle className="text-sm font-semibold text-slate-900">
                            Retards Signalés
                        </CardTitle>
                        <div className="h-10 w-10 rounded-lg bg-rose-100 flex items-center justify-center">
                            <AlertTriangle className="h-5 w-5 text-rose-600" />
                        </div>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold text-slate-900">
                            {stats?.overdue || 0}
                        </div>
                        <p className="text-xs text-rose-500 mt-2 font-medium">Enfants en retard</p>
                    </CardContent>
                </Card>
            </div>

            {/* Main Content Area */}
            <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-7 pt-4">

                {/* Registre des vaccins récents */}
                <Card className="col-span-full lg:col-span-4 animate-fade-in card-elevated" style={{ animationDelay: '0.4s' }}>
                    <CardHeader>
                        <CardTitle className="text-base font-semibold text-slate-900">Registre Actif</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="space-y-6">
                            {stats?.recentVaccinations.length === 0 ? (
                                <p className="text-sm text-slate-500 text-center py-4">Aucun registre récent</p>
                            ) : (
                                stats?.recentVaccinations.map((vac) => (
                                    <div key={vac.id} className="flex items-center">
                                        <div className="h-9 w-9 rounded-full bg-slate-100 flex items-center justify-center mr-3">
                                            <p className="text-xs font-bold text-slate-700">
                                                {vac.Patient?.firstName.charAt(0)}{vac.Patient?.lastName.charAt(0)}
                                            </p>
                                        </div>
                                        <div className="space-y-1">
                                            <p className="text-sm font-medium leading-none text-slate-900">
                                                {vac.Patient?.firstName} {vac.Patient?.lastName}
                                            </p>
                                            <p className="text-xs text-slate-500">
                                                {vac.vaccine} (Dose {vac.doseNumber}) par {vac.Agent?.firstName}
                                            </p>
                                        </div>
                                        <div className="ml-auto font-medium text-xs text-slate-500 bg-slate-100 px-2 py-1 rounded-full">
                                            {new Date(vac.dateGiven).toLocaleDateString()}
                                        </div>
                                    </div>
                                ))
                            )}
                        </div>
                    </CardContent>
                </Card>

                {/* Couverture par zone */}
                <Card className="col-span-full lg:col-span-3 animate-fade-in card-elevated" style={{ animationDelay: '0.5s' }}>
                    <CardHeader>
                        <CardTitle className="text-base font-semibold text-slate-900">Doses par Zone</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="space-y-8">
                            {stats?.coverageByZone.map((zoneData, idx) => (
                                <div key={idx} className="flex items-center">
                                    <div className="space-y-1 w-full">
                                        <div className="flex items-center justify-between">
                                            <p className="text-sm font-medium leading-none text-slate-900">{zoneData.zone}</p>
                                            <p className="text-sm font-bold text-slate-700">{zoneData.count}</p>
                                        </div>
                                        <div className="w-full bg-slate-100 rounded-full h-2.5 mt-2">
                                            <div
                                                className="bg-blue-600 h-2.5 rounded-full"
                                                style={{ width: `${Math.min((zoneData.count / 1500) * 100, 100)}%` }}
                                            ></div>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </CardContent>
                </Card>

            </div>
        </div>
    );
}
