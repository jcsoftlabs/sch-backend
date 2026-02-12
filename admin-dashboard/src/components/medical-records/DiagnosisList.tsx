"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, FileText, Calendar, CheckCircle2 } from "lucide-react";
import { DiagnosisService, Diagnosis } from "@/services/diagnosis.service";
import { DiagnosisDialog } from "./DiagnosisDialog";
import { format } from "date-fns";
import { fr } from "date-fns/locale";

interface DiagnosisListProps {
    patientId: string;
}

export function DiagnosisList({ patientId }: DiagnosisListProps) {
    const [diagnoses, setDiagnoses] = useState<Diagnosis[]>([]);
    const [loading, setLoading] = useState(true);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [selectedDiagnosis, setSelectedDiagnosis] = useState<Diagnosis | undefined>();

    useEffect(() => {
        loadDiagnoses();
    }, [patientId]);

    const loadDiagnoses = async () => {
        try {
            setLoading(true);
            const data = await DiagnosisService.getByPatient(patientId);
            setDiagnoses(data);
        } catch (error) {
            console.error("Error loading diagnoses:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleEdit = (diagnosis: Diagnosis) => {
        setSelectedDiagnosis(diagnosis);
        setDialogOpen(true);
    };

    const handleCreate = () => {
        setSelectedDiagnosis(undefined);
        setDialogOpen(true);
    };

    const handleSuccess = () => {
        setDialogOpen(false);
        loadDiagnoses();
    };

    const getStatusBadge = (status: string) => {
        const variants: Record<string, { variant: any; label: string }> = {
            ACTIVE: { variant: "destructive", label: "Actif" },
            RESOLVED: { variant: "secondary", label: "Résolu" },
            CHRONIC: { variant: "default", label: "Chronique" },
        };
        const config = variants[status] || { variant: "outline", label: status };
        return <Badge variant={config.variant}>{config.label}</Badge>;
    };

    return (
        <>
            <Card>
                <CardHeader>
                    <div className="flex items-center justify-between">
                        <div>
                            <CardTitle>Diagnostics</CardTitle>
                            <CardDescription>
                                Historique des diagnostics médicaux
                            </CardDescription>
                        </div>
                        <Button onClick={handleCreate}>
                            <Plus className="mr-2 h-4 w-4" />
                            Nouveau diagnostic
                        </Button>
                    </div>
                </CardHeader>
                <CardContent>
                    {loading ? (
                        <p className="text-muted-foreground">Chargement...</p>
                    ) : diagnoses.length === 0 ? (
                        <p className="text-muted-foreground">Aucun diagnostic enregistré</p>
                    ) : (
                        <div className="space-y-4">
                            {diagnoses.map((diagnosis) => (
                                <div
                                    key={diagnosis.id}
                                    className="flex items-start justify-between p-4 border rounded-lg hover:bg-accent/50 transition-colors cursor-pointer"
                                    onClick={() => handleEdit(diagnosis)}
                                >
                                    <div className="flex gap-3">
                                        <div className="mt-1">
                                            <FileText className="h-5 w-5 text-primary" />
                                        </div>
                                        <div className="space-y-1">
                                            <div className="flex items-center gap-2">
                                                <p className="font-semibold">{diagnosis.disease}</p>
                                                {getStatusBadge(diagnosis.status)}
                                            </div>
                                            {diagnosis.icd10Code && (
                                                <p className="text-sm text-muted-foreground">
                                                    Code CIM-10: {diagnosis.icd10Code}
                                                </p>
                                            )}
                                            {diagnosis.severity && (
                                                <p className="text-sm text-muted-foreground">
                                                    Sévérité: {diagnosis.severity}
                                                </p>
                                            )}
                                            {diagnosis.notes && (
                                                <p className="text-sm text-muted-foreground italic">
                                                    {diagnosis.notes}
                                                </p>
                                            )}
                                            <div className="flex items-center gap-4 text-xs text-muted-foreground mt-2">
                                                <span className="flex items-center gap-1">
                                                    <Calendar className="h-3 w-3" />
                                                    {format(new Date(diagnosis.diagnosedAt), "d MMM yyyy", { locale: fr })}
                                                </span>
                                                {diagnosis.resolvedAt && (
                                                    <span className="flex items-center gap-1">
                                                        <CheckCircle2 className="h-3 w-3" />
                                                        Résolu le {format(new Date(diagnosis.resolvedAt), "d MMM yyyy", { locale: fr })}
                                                    </span>
                                                )}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </CardContent>
            </Card>

            <DiagnosisDialog
                open={dialogOpen}
                onOpenChange={setDialogOpen}
                patientId={patientId}
                diagnosis={selectedDiagnosis}
                onSuccess={handleSuccess}
            />
        </>
    );
}
