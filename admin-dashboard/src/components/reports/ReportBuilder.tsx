"use client";

import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { DatePickerWithRange } from "@/components/ui/date-range-picker";
import { Button } from "@/components/ui/button";
import { Loader2, Search } from "lucide-react";
import { ReportPreview } from "./ReportPreview";
import { ExportButton } from "./ExportButton";
import { addDays, format } from "date-fns";
import { DateRange } from "react-day-picker";

// Mock Data Generators
const generateMockData = (type: string) => {
    const data = [];
    if (type === "consultations") {
        for (let i = 1; i <= 25; i++) {
            data.push({
                id: `CS-${1000 + i}`,
                patient: `Patient ${i}`,
                doctor: `Dr. Médecin ${i % 5 + 1}`,
                date: format(addDays(new Date(), -i), "dd/MM/yyyy"),
                diagnosis: i % 3 === 0 ? "Grippe" : i % 3 === 1 ? "Hypertension" : "Diabète",
                status: "Terminé"
            });
        }
    } else if (type === "inventory") {
        for (let i = 1; i <= 15; i++) {
            data.push({
                id: `INV-${500 + i}`,
                item: `Médicament ${i}`,
                center: `Centre ${i % 3 + 1}`,
                stock: Math.floor(Math.random() * 500),
                threshold: 50,
                status: Math.random() > 0.3 ? "Check" : "Low"
            });
        }
    } else if (type === "alerts") {
        for (let i = 1; i <= 10; i++) {
            data.push({
                id: `ALT-${200 + i}`,
                disease: `Maladie ${i}`,
                zone: `Zone ${i % 4 + 1}`,
                cases: Math.floor(Math.random() * 50),
                severity: i % 2 === 0 ? "HIGH" : "MEDIUM",
                date: format(addDays(new Date(), -i * 2), "dd/MM/yyyy"),
            });
        }
    }
    return data;
};

const REPORT_CONFIGS: any = {
    consultations: {
        title: "Rapport des Consultations",
        columns: [
            { header: "ID", key: "id" },
            { header: "Patient", key: "patient" },
            { header: "Médecin", key: "doctor" },
            { header: "Date", key: "date" },
            { header: "Diagnostic", key: "diagnosis" },
            { header: "Statut", key: "status" },
        ]
    },
    inventory: {
        title: "État des Stocks",
        columns: [
            { header: "ID", key: "id" },
            { header: "Article", key: "item" },
            { header: "Centre", key: "center" },
            { header: "Stock Actuel", key: "stock" },
            { header: "Seuil Min", key: "threshold" },
            { header: "Statut", key: "status" },
        ]
    },
    alerts: {
        title: "Rapport Épidémiologique",
        columns: [
            { header: "ID", key: "id" },
            { header: "Maladie", key: "disease" },
            { header: "Zone", key: "zone" },
            { header: "Cas", key: "cases" },
            { header: "Sévérité", key: "severity" },
            { header: "Date", key: "date" },
        ]
    }
};

export function ReportBuilder() {
    const [reportType, setReportType] = useState<string>("consultations");
    const [date, setDate] = useState<DateRange | undefined>({
        from: addDays(new Date(), -30),
        to: new Date(),
    });
    const [loading, setLoading] = useState(false);
    const [generatedData, setGeneratedData] = useState<any[] | null>(null);

    const handleGenerate = async () => {
        setLoading(true);
        // Simulate API call
        await new Promise(r => setTimeout(r, 1000));
        setGeneratedData(generateMockData(reportType));
        setLoading(false);
    };

    const config = REPORT_CONFIGS[reportType];

    return (
        <div className="space-y-6">
            <Card>
                <CardHeader>
                    <CardTitle>Configuration du Rapport</CardTitle>
                </CardHeader>
                <CardContent>
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 items-end">
                        <div className="space-y-2">
                            <Label>Type de Rapport</Label>
                            <Select value={reportType} onValueChange={setReportType}>
                                <SelectTrigger>
                                    <SelectValue placeholder="Choisir un type" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="consultations">Consultations</SelectItem>
                                    <SelectItem value="inventory">Stocks & Inventaire</SelectItem>
                                    <SelectItem value="alerts">Alertes & Épidémiologie</SelectItem>
                                </SelectContent>
                            </Select>
                        </div>
                        <div className="space-y-2">
                            <Label>Période</Label>
                            <DatePickerWithRange date={date} setDate={setDate} />
                        </div>
                        <Button onClick={handleGenerate} disabled={loading} className="w-full md:w-auto">
                            {loading ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <Search className="mr-2 h-4 w-4" />}
                            Générer le rapport
                        </Button>
                    </div>
                </CardContent>
            </Card>

            {generatedData && (
                <div className="space-y-4">
                    <div className="flex justify-end">
                        <ExportButton
                            data={generatedData}
                            columns={config.columns}
                            title={config.title}
                            filename={`rapport-${reportType}-${format(new Date(), "yyyyMMdd")}`}
                        />
                    </div>
                    <ReportPreview
                        data={generatedData}
                        columns={config.columns}
                        title={config.title}
                    />
                </div>
            )}
        </div>
    );
}
