"use client";

import { useState, useEffect } from "react";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { LabResultService, LabResult, CreateLabResultDTO, LabTestType } from "@/services/lab-result.service";

interface LabResultDialogProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
    patientId: string;
    labResult?: LabResult;
    onSuccess: () => void;
}

export function LabResultDialog({
    open,
    onOpenChange,
    patientId,
    labResult,
    onSuccess,
}: LabResultDialogProps) {
    const [loading, setLoading] = useState(false);
    const [formData, setFormData] = useState<CreateLabResultDTO>({
        patientId,
        testType: "MALARIA_RDT",
        testName: "",
        result: "",
        unit: "",
        referenceRange: "",
        isAbnormal: false,
        performedBy: "",
        notes: "",
    });

    useEffect(() => {
        if (labResult) {
            setFormData({
                patientId: labResult.patientId,
                testType: labResult.testType,
                testName: labResult.testName,
                result: labResult.result,
                unit: labResult.unit || "",
                referenceRange: labResult.referenceRange || "",
                isAbnormal: labResult.isAbnormal,
                performedBy: labResult.performedBy || "",
                notes: labResult.notes || "",
            });
        } else {
            setFormData({
                patientId,
                testType: "MALARIA_RDT",
                testName: "",
                result: "",
                unit: "",
                referenceRange: "",
                isAbnormal: false,
                performedBy: "",
                notes: "",
            });
        }
    }, [labResult, patientId]);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);

        try {
            const dataToSubmit = {
                ...formData,
                unit: formData.unit || undefined,
                referenceRange: formData.referenceRange || undefined,
                performedBy: formData.performedBy || undefined,
                notes: formData.notes || undefined,
            };

            if (labResult) {
                await LabResultService.update(labResult.id, dataToSubmit);
            } else {
                await LabResultService.create(dataToSubmit);
            }

            onSuccess();
        } catch (error) {
            console.error("Error saving lab result:", error);
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="sm:max-w-[500px]">
                <DialogHeader>
                    <DialogTitle>
                        {labResult ? "Modifier le résultat" : "Nouveau résultat de labo"}
                    </DialogTitle>
                    <DialogDescription>
                        Enregistrez les résultats d'analyse de laboratoire
                    </DialogDescription>
                </DialogHeader>

                <form onSubmit={handleSubmit} className="space-y-4">
                    <div className="space-y-2">
                        <Label htmlFor="testType">Type de test *</Label>
                        <Select
                            value={formData.testType}
                            onValueChange={(value: LabTestType) => setFormData({ ...formData, testType: value })}
                        >
                            <SelectTrigger>
                                <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                                <SelectItem value="MALARIA_RDT">Test rapide paludisme</SelectItem>
                                <SelectItem value="HIV_RDT">Test rapide VIH</SelectItem>
                                <SelectItem value="BLOOD_GLUCOSE">Glycémie</SelectItem>
                                <SelectItem value="HEMOGLOBIN">Hémoglobine</SelectItem>
                                <SelectItem value="PREGNANCY_TEST">Test de grossesse</SelectItem>
                                <SelectItem value="URINALYSIS">Analyse d'urine</SelectItem>
                                <SelectItem value="STOOL_EXAM">Examen de selles</SelectItem>
                                <SelectItem value="OTHER">Autre</SelectItem>
                            </SelectContent>
                        </Select>
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="testName">Nom du test *</Label>
                        <Input
                            id="testName"
                            value={formData.testName}
                            onChange={(e) => setFormData({ ...formData, testName: e.target.value })}
                            placeholder="Ex: Test rapide paludisme"
                            required
                        />
                    </div>

                    <div className="grid grid-cols-2 gap-4">
                        <div className="space-y-2">
                            <Label htmlFor="result">Résultat *</Label>
                            <Input
                                id="result"
                                value={formData.result}
                                onChange={(e) => setFormData({ ...formData, result: e.target.value })}
                                placeholder="Ex: Positif, 12.5"
                                required
                            />
                        </div>

                        <div className="space-y-2">
                            <Label htmlFor="unit">Unité</Label>
                            <Input
                                id="unit"
                                value={formData.unit}
                                onChange={(e) => setFormData({ ...formData, unit: e.target.value })}
                                placeholder="Ex: g/dL, mg/dL"
                            />
                        </div>
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="referenceRange">Plage de référence</Label>
                        <Input
                            id="referenceRange"
                            value={formData.referenceRange}
                            onChange={(e) => setFormData({ ...formData, referenceRange: e.target.value })}
                            placeholder="Ex: 12-16 g/dL"
                        />
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="performedBy">Effectué par</Label>
                        <Input
                            id="performedBy"
                            value={formData.performedBy}
                            onChange={(e) => setFormData({ ...formData, performedBy: e.target.value })}
                            placeholder="Nom du technicien/agent"
                        />
                    </div>

                    <div className="flex items-center space-x-2">
                        <Checkbox
                            id="isAbnormal"
                            checked={formData.isAbnormal}
                            onCheckedChange={(checked) =>
                                setFormData({ ...formData, isAbnormal: checked as boolean })
                            }
                        />
                        <Label htmlFor="isAbnormal" className="cursor-pointer">
                            Résultat anormal
                        </Label>
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
