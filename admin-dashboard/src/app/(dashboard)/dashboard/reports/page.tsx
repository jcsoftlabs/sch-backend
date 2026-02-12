"use client";

import { useState } from "react";
import { useReportTemplates } from "@/hooks/useReportTemplates";
import { ReportTemplateSelector } from "@/components/reports/ReportTemplateSelector";
import { ReportFilters } from "@/components/reports/ReportFilters";
import { ExportButtons } from "@/components/reports/ExportButtons";
import { EpidemiologyStatsDisplay } from "@/components/reports/EpidemiologyStatsDisplay";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { ReportTemplate } from "@/services/report.service";

export default function ReportsPage() {
    const { data: templates, loading, error } = useReportTemplates();
    const [selectedTemplate, setSelectedTemplate] = useState<ReportTemplate | null>(null);
    const [filters, setFilters] = useState({
        startDate: "",
        endDate: "",
        zone: "",
        format: "PDF" as "PDF" | "CSV",
    });

    if (loading) {
        return (
            <div className="flex items-center justify-center h-screen">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
                    <p className="mt-4 text-muted-foreground">Chargement des modèles de rapports...</p>
                </div>
            </div>
        );
    }

    if (error) {
        return (
            <div className="flex items-center justify-center h-screen">
                <Card className="w-96">
                    <CardHeader>
                        <CardTitle className="text-destructive">Erreur</CardTitle>
                        <CardDescription>
                            Impossible de charger les modèles de rapports
                        </CardDescription>
                    </CardHeader>
                    <CardContent>
                        <p className="text-sm text-muted-foreground">{error.message}</p>
                    </CardContent>
                </Card>
            </div>
        );
    }

    return (
        <div className="space-y-6 p-6">
            <div>
                <h1 className="text-3xl font-bold">Rapports & Exports</h1>
                <p className="text-muted-foreground">
                    Générez des rapports et exportez des données pour analyse
                </p>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <div className="lg:col-span-2 space-y-6">
                    <ReportTemplateSelector
                        templates={templates}
                        selectedTemplate={selectedTemplate}
                        onSelect={setSelectedTemplate}
                    />

                    <ReportFilters onFiltersChange={setFilters} />

                    <EpidemiologyStatsDisplay
                        startDate={filters.startDate}
                        endDate={filters.endDate}
                    />
                </div>

                <div>
                    <ExportButtons selectedTemplate={selectedTemplate} filters={filters} />
                </div>
            </div>
        </div>
    );
}
