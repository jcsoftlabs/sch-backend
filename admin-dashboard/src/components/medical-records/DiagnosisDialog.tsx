"use client";

import { useState, useEffect } from "react";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { DiagnosisService, Diagnosis, CreateDiagnosisDTO } from "@/services/diagnosis.service";
import { useAuthStore } from "@/stores/auth.store";

interface DiagnosisDialogProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
    patientId: string;
    diagnosis?: Diagnosis;
    onSuccess: () => void;
}

export function DiagnosisDialog({
    open,
    onOpenChange,
    patientId,
    diagnosis,
    onSuccess,
}: DiagnosisDialogProps) {
    const { user } = useAuthStore();
    const [loading, setLoading] = useState(false);
    const [formData, setFormData] = useState<CreateDiagnosisDTO>({
        patientId,
        disease: "",
        icd10Code: "",
        severity: "",
        status: "ACTIVE",
        notes: "",
    });

    useEffect(() => {
        if (diagnosis) {
            setFormData({
                patientId: diagnosis.patientId,
                disease: diagnosis.disease,
                icd10Code: diagnosis.icd10Code || "",
                severity: diagnosis.severity || "",
                status: diagnosis.status,
                notes: diagnosis.notes || "",
            });
        } else {
            setFormData({
                patientId,
                disease: "",
                icd10Code: "",
                severity: "",
                status: "ACTIVE",
                notes: "",
            });
        }
    }, [diagnosis, patientId]);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);

        try {
            const dataToSubmit = {
                ...formData,
                doctorId: user?.id,
                icd10Code: formData.icd10Code || undefined,
                severity: formData.severity || undefined,
                notes: formData.notes || undefined,
            };

            if (diagnosis) {
                await DiagnosisService.update(diagnosis.id, dataToSubmit);
            } else {
                await DiagnosisService.create(dataToSubmit);
            }

            onSuccess();
        } catch (error) {
            console.error("Error saving diagnosis:", error);
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="sm:max-w-[500px]">
                <DialogHeader>
                    <DialogTitle>
                        {diagnosis ? "Modifier le diagnostic" : "Nouveau diagnostic"}
                    </DialogTitle>
                    <DialogDescription>
                        Enregistrez les détails du diagnostic médical
                    </DialogDescription>
                </DialogHeader>

                <form onSubmit={handleSubmit} className="space-y-4">
                    <div className="space-y-2">
                        <Label htmlFor="disease">Maladie / Condition *</Label>
                        <Input
                            id="disease"
                            value={formData.disease}
                            onChange={(e) => setFormData({ ...formData, disease: e.target.value })}
                            placeholder="Ex: Paludisme"
                            required
                        />
                    </div>

                    <div className="grid grid-cols-2 gap-4">
                        <div className="space-y-2">
                            <Label htmlFor="icd10Code">Code CIM-10</Label>
                            <Input
                                id="icd10Code"
                                value={formData.icd10Code}
                                onChange={(e) => setFormData({ ...formData, icd10Code: e.target.value })}
                                placeholder="Ex: A00.1"
                            />
                        </div>

                        <div className="space-y-2">
                            <Label htmlFor="severity">Sévérité</Label>
                            <Select
                                value={formData.severity}
                                onValueChange={(value) => setFormData({ ...formData, severity: value })}
                            >
                                <SelectTrigger>
                                    <SelectValue placeholder="Sélectionner" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="Léger">Léger</SelectItem>
                                    <SelectItem value="Modéré">Modéré</SelectItem>
                                    <SelectItem value="Sévère">Sévère</SelectItem>
                                </SelectContent>
                            </Select>
                        </div>
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="status">Statut</Label>
                        <Select
                            value={formData.status}
                            onValueChange={(value) => setFormData({ ...formData, status: value })}
                        >
                            <SelectTrigger>
                                <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                                <SelectItem value="ACTIVE">Actif</SelectItem>
                                <SelectItem value="RESOLVED">Résolu</SelectItem>
                                <SelectItem value="CHRONIC">Chronique</SelectItem>
                            </SelectContent>
                        </Select>
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="notes">Notes</Label>
                        <Textarea
                            id="notes"
                            value={formData.notes}
                            onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                            placeholder="Notes additionnelles (optionnel)"
                            rows={3}
                        />
                    </div>

                    <DialogFooter>
                        <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
                            Annuler
                        </Button>
                        <Button type="submit" disabled={loading}>
                            {loading ? "Enregistrement..." : "Enregistrer"}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}
