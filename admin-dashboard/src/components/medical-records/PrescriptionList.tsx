"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Pill, Calendar, Clock } from "lucide-react";
import { PrescriptionService, Prescription } from "@/services/prescription.service";
import { PrescriptionDialog } from "./PrescriptionDialog";
import { format } from "date-fns";
import { fr } from "date-fns/locale";

interface PrescriptionListProps {
    patientId: string;
}

export function PrescriptionList({ patientId }: PrescriptionListProps) {
    const [prescriptions, setPrescriptions] = useState<Prescription[]>([]);
    const [loading, setLoading] = useState(true);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [selectedPrescription, setSelectedPrescription] = useState<Prescription | undefined>();

    useEffect(() => {
        loadPrescriptions();
    }, [patientId]);

    const loadPrescriptions = async () => {
        try {
            setLoading(loading);
            const data = await PrescriptionService.getByPatient(patientId);
            setPrescriptions(data);
        } catch (error) {
            console.error("Error loading prescriptions:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleEdit = (prescription: Prescription) => {
        setSelectedPrescription(prescription);
        setDialogOpen(true);
    };

    const handleCreate = () => {
        setSelectedPrescription(undefined);
        setDialogOpen(true);
    };

    const handleSuccess = () => {
        setDialogOpen(false);
        loadPrescriptions();
    };

    const getStatusBadge = (status: Prescription["status"]) => {
        const variants: Record<Prescription["status"], { variant: any; label: string }> = {
            ACTIVE: { variant: "default", label: "Active" },
            COMPLETED: { variant: "secondary", label: "Terminée" },
            CANCELLED: { variant: "destructive", label: "Annulée" },
            EXPIRED: { variant: "outline", label: "Expirée" },
        };
        const config = variants[status];
        return <Badge variant={config.variant}>{config.label}</Badge>;
    };

    return (
        <>
            <Card>
                <CardHeader>
                    <div className="flex items-center justify-between">
                        <div>
                            <CardTitle>Prescriptions</CardTitle>
                            <CardDescription>
                                Historique des médicaments prescrits
                            </CardDescription>
                        </div>
                        <Button onClick={handleCreate}>
                            <Plus className="mr-2 h-4 w-4" />
                            Nouvelle prescription
                        </Button>
                    </div>
                </CardHeader>
                <CardContent>
                    {loading ? (
                        <p className="text-slate-500">Chargement...</p>
                    ) : prescriptions.length === 0 ? (
                        <p className="text-slate-500">Aucune prescription enregistrée</p>
                    ) : (
                        <div className="space-y-4">
                            {prescriptions.map((prescription) => (
                                <div
                                    key={prescription.id}
                                    className="flex items-start justify-between p-4 border rounded-lg hover:bg-accent/50 transition-colors cursor-pointer"
                                    onClick={() => handleEdit(prescription)}
                                >
                                    <div className="flex gap-3">
                                        <div className="mt-1">
                                            <Pill className="h-5 w-5 text-primary" />
                                        </div>
                                        <div className="space-y-1">
                                            <div className="flex items-center gap-2">
                                                <p className="font-semibold text-slate-900">{prescription.medication}</p>
                                                {getStatusBadge(prescription.status)}
                                            </div>
                                            <p className="text-sm text-slate-500">
                                                {prescription.dosage} • {prescription.frequency} • {prescription.duration}
                                            </p>
                                            {prescription.instructions && (
                                                <p className="text-sm text-slate-500 italic">
                                                    {prescription.instructions}
                                                </p>
                                            )}
                                            <div className="flex items-center gap-4 text-xs text-muted-foreground mt-2">
                                                <span className="flex items-center gap-1">
                                                    <Calendar className="h-3 w-3" />
                                                    {format(new Date(prescription.startDate), "d MMM yyyy", { locale: fr })}
                                                </span>
                                                {prescription.endDate && (
                                                    <span className="flex items-center gap-1">
                                                        <Clock className="h-3 w-3" />
                                                        Jusqu'au {format(new Date(prescription.endDate), "d MMM yyyy", { locale: fr })}
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

            <PrescriptionDialog
                open={dialogOpen}
                onOpenChange={setDialogOpen}
                patientId={patientId}
                prescription={selectedPrescription}
                onSuccess={handleSuccess}
            />
        </>
    );
}
