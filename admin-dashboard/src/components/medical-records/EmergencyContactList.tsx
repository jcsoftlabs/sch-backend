"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Phone, Star } from "lucide-react";
import { EmergencyContactService, EmergencyContact } from "@/services/emergency-contact.service";
import { EmergencyContactDialog } from "./EmergencyContactDialog";

interface EmergencyContactListProps {
    patientId: string;
}

export function EmergencyContactList({ patientId }: EmergencyContactListProps) {
    const [contacts, setContacts] = useState<EmergencyContact[]>([]);
    const [loading, setLoading] = useState(true);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [selectedContact, setSelectedContact] = useState<EmergencyContact | undefined>();

    useEffect(() => {
        loadContacts();
    }, [patientId]);

    const loadContacts = async () => {
        try {
            setLoading(true);
            const data = await EmergencyContactService.getByPatient(patientId);
            setContacts(data);
        } catch (error) {
            console.error("Error loading emergency contacts:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleEdit = (contact: EmergencyContact) => {
        setSelectedContact(contact);
        setDialogOpen(true);
    };

    const handleCreate = () => {
        setSelectedContact(undefined);
        setDialogOpen(true);
    };

    const handleSuccess = () => {
        setDialogOpen(false);
        loadContacts();
    };

    return (
        <>
            <Card>
                <CardHeader>
                    <div className="flex items-center justify-between">
                        <div>
                            <CardTitle>Contacts d'Urgence</CardTitle>
                            <CardDescription>
                                Personnes à contacter en cas d'urgence
                            </CardDescription>
                        </div>
                        <Button onClick={handleCreate}>
                            <Plus className="mr-2 h-4 w-4" />
                            Ajouter un contact
                        </Button>
                    </div>
                </CardHeader>
                <CardContent>
                    {loading ? (
                        <p className="text-slate-500">Chargement...</p>
                    ) : contacts.length === 0 ? (
                        <p className="text-slate-500">Aucun contact d'urgence enregistré</p>
                    ) : (
                        <div className="grid gap-4 md:grid-cols-2">
                            {contacts.map((contact) => (
                                <div
                                    key={contact.id}
                                    className="flex items-start justify-between p-4 border rounded-lg hover:bg-accent/50 transition-colors cursor-pointer"
                                    onClick={() => handleEdit(contact)}
                                >
                                    <div className="flex gap-3">
                                        <div className="mt-1">
                                            <Phone className="h-5 w-5 text-primary" />
                                        </div>
                                        <div className="space-y-1">
                                            <div className="flex items-center gap-2">
                                                <p className="font-semibold text-slate-900">{contact.name}</p>
                                                {contact.isPrimary && (
                                                    <Badge variant="default" className="flex items-center gap-1">
                                                        <Star className="h-3 w-3" />
                                                        Principal
                                                    </Badge>
                                                )}
                                            </div>
                                            <p className="text-sm text-slate-500">
                                                {contact.relationship}
                                            </p>
                                            <p className="text-sm font-medium text-slate-900">{contact.phone}</p>
                                            {contact.address && (
                                                <p className="text-sm text-slate-500">
                                                    {contact.address}
                                                </p>
                                            )}
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </CardContent>
            </Card>

            <EmergencyContactDialog
                open={dialogOpen}
                onOpenChange={setDialogOpen}
                patientId={patientId}
                contact={selectedContact}
                onSuccess={handleSuccess}
            />
        </>
    );
}
