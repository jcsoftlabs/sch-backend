"use client";

import { useState, useEffect } from "react";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { PrescriptionService, Prescription, CreatePrescriptionDTO } from "@/services/prescription.service";
import { useAuthStore } from "@/stores/auth.store";

interface PrescriptionDialogProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
    patientId: string;
    prescription?: Prescription;
    onSuccess: () => void;
}

export function PrescriptionDialog({
    open,
    onOpenChange,
    patientId,
    prescription,
    onSuccess,
}: PrescriptionDialogProps) {
    const { user } = useAuthStore();
    const [loading, setLoading] = useState(false);
    const [formData, setFormData] = useState<CreatePrescriptionDTO>({
        patientId,
        medication: "",
        dosage: "",
        frequency: "",
        duration: "",
        instructions: "",
        status: "ACTIVE",
    });

    useEffect(() => {
        if (prescription) {
            setFormData({
                patientId: prescription.patientId,
                medication: prescription.medication,
                dosage: prescription.dosage,
                frequency: prescription.frequency,
                duration: prescription.duration,
                instructions: prescription.instructions || "",
                status: prescription.status,
            });
        } else {
            setFormData({
                patientId,
                medication: "",
                dosage: "",
                frequency: "",
                duration: "",
                instructions: "",
                status: "ACTIVE",
            });
        }
    }, [prescription, patientId]);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);

        try {
            const dataToSubmit = {
                ...formData,
                doctorId: user?.id,
            };

            if (prescription) {
                await PrescriptionService.update(prescription.id, dataToSubmit);
            } else {
                await PrescriptionService.create(dataToSubmit);
            }

            onSuccess();
        } catch (error) {
            console.error("Error saving prescription:", error);
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="sm:max-w-[500px]">
                <DialogHeader>
                    <DialogTitle>
                        {prescription ? "Modifier la prescription" : "Nouvelle prescription"}
                    </DialogTitle>
                    <DialogDescription>
                        Enregistrez les détails de la prescription médicale
                    </DialogDescription>
                </DialogHeader>

                <form onSubmit={handleSubmit} className="space-y-4">
                    <div className="space-y-2">
                        <Label htmlFor="medication">Médicament *</Label>
                        <Input
                            id="medication"
                            value={formData.medication}
                            onChange={(e) => setFormData({ ...formData, medication: e.target.value })}
                            placeholder="Ex: Amoxicilline"
                            required
                        />
                    </div>

                    <div className="grid grid-cols-2 gap-4">
                        <div className="space-y-2">
                            <Label htmlFor="dosage">Dosage *</Label>
                            <Input
                                id="dosage"
                                value={formData.dosage}
                                onChange={(e) => setFormData({ ...formData, dosage: e.target.value })}
                                placeholder="Ex: 500mg"
                                required
                            />
                        </div>

                        <div className="space-y-2">
                            <Label htmlFor="frequency">Fréquence *</Label>
                            <Input
                                id="frequency"
                                value={formData.frequency}
                                onChange={(e) => setFormData({ ...formData, frequency: e.target.value })}
                                placeholder="Ex: 2x/jour"
                                required
                            />
                        </div>
                    </div>

                    <div className="grid grid-cols-2 gap-4">
                        <div className="space-y-2">
                            <Label htmlFor="duration">Durée *</Label>
                            <Input
                                id="duration"
                                value={formData.duration}
                                onChange={(e) => setFormData({ ...formData, duration: e.target.value })}
                                placeholder="Ex: 7 jours"
                                required
                            />
                        </div>

                        <div className="space-y-2">
                            <Label htmlFor="status">Statut</Label>
                            <Select
                                value={formData.status}
                                onValueChange={(value: any) => setFormData({ ...formData, status: value })}
                            >
                                <SelectTrigger>
                                    <SelectValue />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="ACTIVE">Active</SelectItem>
                                    <SelectItem value="COMPLETED">Terminée</SelectItem>
                                    <SelectItem value="CANCELLED">Annulée</SelectItem>
                                </SelectContent>
                            </Select>
                        </div>
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="instructions">Instructions</Label>
                        <Textarea
                            id="instructions"
                            value={formData.instructions}
                            onChange={(e) => setFormData({ ...formData, instructions: e.target.value })}
                            placeholder="Instructions spéciales (optionnel)"
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
