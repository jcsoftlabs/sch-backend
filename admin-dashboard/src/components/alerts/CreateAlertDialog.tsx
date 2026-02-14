"use client";

import { useState } from "react";
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select";
import { AlertService, CreateAlertRequest } from "@/services/alert.service";
import { useToast } from "@/hooks/use-toast";

interface CreateAlertDialogProps {
    open: boolean;
    onClose: () => void;
    onSuccess: () => void;
}

export function CreateAlertDialog({ open, onClose, onSuccess }: CreateAlertDialogProps) {
    const { toast } = useToast();
    const [loading, setLoading] = useState(false);
    const [formData, setFormData] = useState<CreateAlertRequest>({
        disease: "",
        zone: "",
        severity: "MEDIUM",
        threshold: 10,
        description: "",
    });

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        try {
            setLoading(true);
            await AlertService.createAlert(formData);
            toast({
                title: "Alerte créée",
                description: "L'alerte épidémiologique a été créée avec succès.",
            });
            onSuccess();
            onClose();
            // Reset form
            setFormData({
                disease: "",
                zone: "",
                severity: "MEDIUM",
                threshold: 10,
                description: "",
            });
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de créer l'alerte.",
                variant: "destructive",
            });
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={open} onOpenChange={onClose}>
            <DialogContent>
                <DialogHeader>
                    <DialogTitle className="text-slate-900">Créer une Alerte Manuelle</DialogTitle>
                    <DialogDescription className="text-slate-500">
                        Créer une nouvelle alerte épidémiologique pour une maladie spécifique
                    </DialogDescription>
                </DialogHeader>

                <form onSubmit={handleSubmit} className="space-y-4">
                    <div className="space-y-2">
                        <Label htmlFor="disease">Maladie *</Label>
                        <Input
                            id="disease"
                            placeholder="Ex: Cholera"
                            value={formData.disease}
                            onChange={(e) => setFormData({ ...formData, disease: e.target.value })}
                            required
                        />
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="zone">Zone *</Label>
                        <Input
                            id="zone"
                            placeholder="Ex: Port-au-Prince"
                            value={formData.zone}
                            onChange={(e) => setFormData({ ...formData, zone: e.target.value })}
                            required
                        />
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="severity">Sévérité *</Label>
                        <Select
                            value={formData.severity}
                            onValueChange={(value: any) => setFormData({ ...formData, severity: value })}
                        >
                            <SelectTrigger id="severity">
                                <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                                <SelectItem value="LOW">Faible</SelectItem>
                                <SelectItem value="MEDIUM">Moyenne</SelectItem>
                                <SelectItem value="HIGH">Élevée</SelectItem>
                                <SelectItem value="CRITICAL">Critique</SelectItem>
                            </SelectContent>
                        </Select>
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="threshold">Seuil de cas *</Label>
                        <Input
                            id="threshold"
                            type="number"
                            min="1"
                            value={formData.threshold}
                            onChange={(e) =>
                                setFormData({ ...formData, threshold: parseInt(e.target.value) })
                            }
                            required
                        />
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="description">Description *</Label>
                        <Textarea
                            id="description"
                            placeholder="Décrivez la situation..."
                            value={formData.description}
                            onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                            required
                        />
                    </div>

                    <DialogFooter>
                        <Button type="button" variant="outline" onClick={onClose}>
                            Annuler
                        </Button>
                        <Button type="submit" disabled={loading}>
                            {loading ? "Création..." : "Créer l'alerte"}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}
