"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, FlaskConical, AlertTriangle } from "lucide-react";
import { LabResultService, LabResult } from "@/services/lab-result.service";
import { LabResultDialog } from "./LabResultDialog";
import { format } from "date-fns";
import { fr } from "date-fns/locale";

interface LabResultsListProps {
    patientId: string;
}

export function LabResultsList({ patientId }: LabResultsListProps) {
    const [results, setResults] = useState<LabResult[]>([]);
    const [loading, setLoading] = useState(true);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [selectedResult, setSelectedResult] = useState<LabResult | undefined>();

    useEffect(() => {
        loadResults();
    }, [patientId]);

    const loadResults = async () => {
        try {
            setLoading(true);
            const data = await LabResultService.getByPatient(patientId);
            setResults(data);
        } catch (error) {
            console.error("Error loading lab results:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleEdit = (result: LabResult) => {
        setSelectedResult(result);
        setDialogOpen(true);
    };

    const handleCreate = () => {
        setSelectedResult(undefined);
        setDialogOpen(true);
    };

    const handleSuccess = () => {
        setDialogOpen(false);
        loadResults();
    };

    return (
        <>
            <Card>
                <CardHeader>
                    <div className="flex items-center justify-between">
                        <div>
                            <CardTitle>Résultats de Laboratoire</CardTitle>
                            <CardDescription>
                                Tests rapides et analyses de laboratoire
                            </CardDescription>
                        </div>
                        <Button onClick={handleCreate}>
                            <Plus className="mr-2 h-4 w-4" />
                            Nouveau résultat
                        </Button>
                    </div>
                </CardHeader>
                <CardContent>
                    {loading ? (
                        <p className="text-muted-foreground">Chargement...</p>
                    ) : results.length === 0 ? (
                        <p className="text-muted-foreground">Aucun résultat enregistré</p>
                    ) : (
                        <div className="space-y-4">
                            {results.map((result) => (
                                <div
                                    key={result.id}
                                    className="flex items-start justify-between p-4 border rounded-lg hover:bg-accent/50 transition-colors cursor-pointer"
                                    onClick={() => handleEdit(result)}
                                >
                                    <div className="flex gap-3">
                                        <div className="mt-1">
                                            <FlaskConical className="h-5 w-5 text-primary" />
                                        </div>
                                        <div className="space-y-1">
                                            <div className="flex items-center gap-2">
                                                <p className="font-semibold">{result.testName}</p>
                                                {result.isAbnormal && (
                                                    <Badge variant="destructive" className="flex items-center gap-1">
                                                        <AlertTriangle className="h-3 w-3" />
                                                        Anormal
                                                    </Badge>
                                                )}
                                            </div>
                                            <p className="text-sm text-muted-foreground">
                                                Résultat: <span className="font-medium">{result.result}</span>
                                                {result.unit && ` ${result.unit}`}
                                            </p>
                                            {result.referenceRange && (
                                                <p className="text-sm text-muted-foreground">
                                                    Plage normale: {result.referenceRange}
                                                </p>
                                            )}
                                            {result.notes && (
                                                <p className="text-sm text-muted-foreground italic">
                                                    {result.notes}
                                                </p>
                                            )}
                                            <div className="flex items-center gap-4 text-xs text-muted-foreground mt-2">
                                                <span>
                                                    {format(new Date(result.performedAt), "d MMM yyyy", { locale: fr })}
                                                </span>
                                                {result.performedBy && (
                                                    <span>Par: {result.performedBy}</span>
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

            <LabResultDialog
                open={dialogOpen}
                onOpenChange={setDialogOpen}
                patientId={patientId}
                labResult={selectedResult}
                onSuccess={handleSuccess}
            />
        </>
    );
}
