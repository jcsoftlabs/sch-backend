"use client";

import { useState, useEffect } from "react";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import { EmergencyContactService, EmergencyContact, CreateEmergencyContactDTO } from "@/services/emergency-contact.service";

interface EmergencyContactDialogProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
    patientId: string;
    contact?: EmergencyContact;
    onSuccess: () => void;
}

export function EmergencyContactDialog({
    open,
    onOpenChange,
    patientId,
    contact,
    onSuccess,
}: EmergencyContactDialogProps) {
    const [loading, setLoading] = useState(false);
    const [formData, setFormData] = useState<CreateEmergencyContactDTO>({
        patientId,
        name: "",
        relationship: "",
        phone: "",
        address: "",
        isPrimary: false,
    });

    useEffect(() => {
        if (contact) {
            setFormData({
                patientId: contact.patientId,
                name: contact.name,
                relationship: contact.relationship,
                phone: contact.phone,
                address: contact.address || "",
                isPrimary: contact.isPrimary,
            });
        } else {
            setFormData({
                patientId,
                name: "",
                relationship: "",
                phone: "",
                address: "",
                isPrimary: false,
            });
        }
    }, [contact, patientId]);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);

        try {
            const dataToSubmit = {
                ...formData,
                address: formData.address || undefined,
            };

            if (contact) {
                await EmergencyContactService.update(contact.id, dataToSubmit);
            } else {
                await EmergencyContactService.create(dataToSubmit);
            }

            onSuccess();
        } catch (error) {
            console.error("Error saving emergency contact:", error);
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="sm:max-w-[500px]">
                <DialogHeader>
                    <DialogTitle>
                        {contact ? "Modifier le contact" : "Nouveau contact d'urgence"}
                    </DialogTitle>
                    <DialogDescription>
                        Personne à contacter en cas d'urgence
                    </DialogDescription>
                </DialogHeader>

                <form onSubmit={handleSubmit} className="space-y-4">
                    <div className="space-y-2">
                        <Label htmlFor="name">Nom complet *</Label>
                        <Input
                            id="name"
                            value={formData.name}
                            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                            placeholder="Ex: Marie Dupont"
                            required
                        />
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="relationship">Relation *</Label>
                        <Input
                            id="relationship"
                            value={formData.relationship}
                            onChange={(e) => setFormData({ ...formData, relationship: e.target.value })}
                            placeholder="Ex: Mère, Conjoint, Ami"
                            required
                        />
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="phone">Téléphone *</Label>
                        <Input
                            id="phone"
                            value={formData.phone}
                            onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                            placeholder="Ex: +509 1234 5678"
                            required
                        />
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="address">Adresse</Label>
                        <Input
                            id="address"
                            value={formData.address}
                            onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                            placeholder="Adresse du contact (optionnel)"
                        />
                    </div>

                    <div className="flex items-center space-x-2">
                        <Checkbox
                            id="isPrimary"
                            checked={formData.isPrimary}
                            onCheckedChange={(checked) =>
                                setFormData({ ...formData, isPrimary: checked as boolean })
                            }
                        />
                        <Label htmlFor="isPrimary" className="cursor-pointer">
                            Contact principal
                        </Label>
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
