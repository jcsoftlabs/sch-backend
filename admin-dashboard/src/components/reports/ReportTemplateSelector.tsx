"use client";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ReportTemplate } from "@/services/report.service";
import { FileText, Calendar, TrendingUp } from "lucide-react";

interface ReportTemplateSelectorProps {
    templates: ReportTemplate[];
    selectedTemplate: ReportTemplate | null;
    onSelect: (template: ReportTemplate) => void;
}

export function ReportTemplateSelector({
    templates,
    selectedTemplate,
    onSelect,
}: ReportTemplateSelectorProps) {
    const getTemplateIcon = (type: string) => {
        switch (type) {
            case "WEEKLY":
                return <Calendar className="h-5 w-5" />;
            case "MONTHLY":
                return <FileText className="h-5 w-5" />;
            case "QUARTERLY":
                return <TrendingUp className="h-5 w-5" />;
            case "ANNUAL":
                return <FileText className="h-5 w-5" />;
            default:
                return <FileText className="h-5 w-5" />;
        }
    };

    return (
        <Card>
            <CardHeader>
                <CardTitle>Modèles de Rapports</CardTitle>
                <CardDescription>Sélectionnez un modèle pour générer un rapport</CardDescription>
            </CardHeader>
            <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {templates.map((template) => (
                        <div
                            key={template.id}
                            className={`p-4 border-2 rounded-lg cursor-pointer transition-all ${selectedTemplate?.id === template.id
                                    ? "border-primary bg-primary/5"
                                    : "border-gray-200 hover:border-primary/50"
                                }`}
                            onClick={() => onSelect(template)}
                        >
                            <div className="flex items-start gap-3">
                                <div className="p-2 bg-primary/10 rounded-lg">
                                    {getTemplateIcon(template.type)}
                                </div>
                                <div className="flex-1">
                                    <h3 className="font-semibold">{template.name}</h3>
                                    <p className="text-sm text-muted-foreground mt-1">
                                        {template.description}
                                    </p>
                                    <span className="inline-block mt-2 px-2 py-1 text-xs bg-gray-100 rounded">
                                        {template.type}
                                    </span>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </CardContent>
        </Card>
    );
}
