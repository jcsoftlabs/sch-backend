"use client";

import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ReportService, ReportTemplate, ExportRawDataParams } from "@/services/report.service";
import { useToast } from "@/hooks/use-toast";
import { Download, FileText, Table } from "lucide-react";

interface ExportButtonsProps {
    selectedTemplate: ReportTemplate | null;
    filters: {
        startDate: string;
        endDate: string;
        zone: string;
        format: "PDF" | "CSV";
    };
}

export function ExportButtons({ selectedTemplate, filters }: ExportButtonsProps) {
    const { toast } = useToast();
    const [generating, setGenerating] = useState(false);
    const [exporting, setExporting] = useState(false);

    const handleGenerateReport = async () => {
        if (!selectedTemplate) {
            toast({
                title: "Erreur",
                description: "Veuillez sélectionner un modèle de rapport",
                variant: "destructive",
            });
            return;
        }

        if (!filters.startDate || !filters.endDate) {
            toast({
                title: "Erreur",
                description: "Veuillez sélectionner une période",
                variant: "destructive",
            });
            return;
        }

        try {
            setGenerating(true);
            const blob = await ReportService.generateReport({
                templateId: selectedTemplate.id,
                startDate: filters.startDate,
                endDate: filters.endDate,
                zone: filters.zone,
                format: filters.format,
            });

            // Download the file
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = url;
            a.download = `rapport_${selectedTemplate.type}_${new Date().toISOString().split("T")[0]}.${filters.format.toLowerCase()}`;
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
            document.body.removeChild(a);

            toast({
                title: "Rapport généré",
                description: `Le rapport ${filters.format} a été téléchargé avec succès`,
            });
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de générer le rapport",
                variant: "destructive",
            });
        } finally {
            setGenerating(false);
        }
    };

    const handleExportRawData = async (entity: ExportRawDataParams["entity"]) => {
        try {
            setExporting(true);
            const blob = await ReportService.exportRawData({
                entity,
                startDate: filters.startDate,
                endDate: filters.endDate,
                zone: filters.zone,
            });

            // Download the CSV
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = url;
            a.download = `export_${entity}_${new Date().toISOString().split("T")[0]}.csv`;
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
            document.body.removeChild(a);

            toast({
                title: "Export réussi",
                description: `Les données ${entity} ont été exportées en CSV`,
            });
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible d'exporter les données",
                variant: "destructive",
            });
        } finally {
            setExporting(false);
        }
    };

    return (
        <Card>
            <CardHeader>
                <CardTitle>Génération et Export</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
                <div>
                    <h3 className="text-sm font-semibold mb-2">Générer un Rapport</h3>
                    <Button
                        onClick={handleGenerateReport}
                        disabled={generating || !selectedTemplate}
                        className="w-full"
                    >
                        <FileText className="h-4 w-4 mr-2" />
                        {generating ? "Génération..." : `Générer ${filters.format}`}
                    </Button>
                </div>

                <div>
                    <h3 className="text-sm font-semibold mb-2">Exporter Données Brutes (CSV)</h3>
                    <div className="grid grid-cols-2 gap-2">
                        <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleExportRawData("patients")}
                            disabled={exporting}
                        >
                            <Table className="h-4 w-4 mr-2" />
                            Patients
                        </Button>
                        <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleExportRawData("consultations")}
                            disabled={exporting}
                        >
                            <Table className="h-4 w-4 mr-2" />
                            Consultations
                        </Button>
                        <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleExportRawData("case-reports")}
                            disabled={exporting}
                        >
                            <Table className="h-4 w-4 mr-2" />
                            Cas Reportés
                        </Button>
                        <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleExportRawData("vaccinations")}
                            disabled={exporting}
                        >
                            <Table className="h-4 w-4 mr-2" />
                            Vaccinations
                        </Button>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
}
