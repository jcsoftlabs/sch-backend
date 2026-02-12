"use client";

import { Consultation } from "@/services/consultation.service";
import { createColumns } from "@/components/dashboard/ConsultationTable";
import { DataTable } from "@/components/ui/data-table";
import { ConsultationService } from "@/services/consultation.service";
import { PatientService } from "@/services/patient.service";
import { useEffect, useState } from "react";
import { Loader2, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { ConsultationForm } from "@/components/dashboard/ConsultationForm";
import { ConfirmDialog } from "@/components/ui/confirm-dialog";
import { useToast } from "@/hooks/use-toast";

export default function ConsultationsPage() {
    const [data, setData] = useState<Consultation[]>([]);
    const [patients, setPatients] = useState<Array<{ id: string; firstName: string; lastName: string }>>([]);
    const [loading, setLoading] = useState(true);
    const [formOpen, setFormOpen] = useState(false);
    const [editingConsultation, setEditingConsultation] = useState<Consultation | undefined>();
    const [deleteId, setDeleteId] = useState<string | null>(null);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const { toast } = useToast();

    const fetchData = async () => {
        try {
            const [consultations, patientsData] = await Promise.all([
                ConsultationService.getAll(),
                PatientService.getAll()
            ]);
            setData(consultations);
            setPatients(patientsData.map(p => ({ id: p.id, firstName: p.firstName, lastName: p.lastName })));
        } catch (error) {
            console.error("Failed to load consultations", error);
            toast({
                title: "Erreur",
                description: "Impossible de charger les consultations",
                variant: "destructive",
            });
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);

    const handleCreate = async (formData: any) => {
        setIsSubmitting(true);
        try {
            await ConsultationService.create(formData);
            toast({
                title: "Succès",
                description: "Consultation créée avec succès",
            });
            setFormOpen(false);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de créer la consultation",
                variant: "destructive",
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleUpdate = async (formData: any) => {
        if (!editingConsultation) return;
        setIsSubmitting(true);
        try {
            await ConsultationService.update(editingConsultation.id, formData);
            toast({
                title: "Succès",
                description: "Consultation modifiée avec succès",
            });
            setFormOpen(false);
            setEditingConsultation(undefined);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de modifier la consultation",
                variant: "destructive",
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleDelete = async () => {
        if (!deleteId) return;
        try {
            await ConsultationService.delete(deleteId);
            toast({
                title: "Succès",
                description: "Consultation supprimée avec succès",
            });
            setDeleteId(null);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de supprimer la consultation",
                variant: "destructive",
            });
        }
    };

    const columns = createColumns(
        (consultation) => {
            setEditingConsultation(consultation);
            setFormOpen(true);
        },
        (id) => setDeleteId(id)
    );

    if (loading) {
        return <div className="flex h-full items-center justify-center"><Loader2 className="h-8 w-8 animate-spin" /></div>
    }

    return (
        <div className="hidden h-full flex-1 flex-col space-y-8 p-8 md:flex">
            <div className="flex items-center justify-between space-y-2">
                <div>
                    <h2 className="text-2xl font-bold tracking-tight">Téléconsultations</h2>
                    <p className="text-muted-foreground">
                        Gestion des demandes de téléconsultation.
                    </p>
                </div>
                <Button onClick={() => { setEditingConsultation(undefined); setFormOpen(true); }}>
                    <Plus className="mr-2 h-4 w-4" />
                    Nouvelle consultation
                </Button>
            </div>
            <DataTable data={data} columns={columns} searchKey="patient" />

            <ConsultationForm
                open={formOpen}
                onOpenChange={(open) => {
                    setFormOpen(open);
                    if (!open) setEditingConsultation(undefined);
                }}
                onSubmit={editingConsultation ? handleUpdate : handleCreate}
                initialData={editingConsultation}
                isLoading={isSubmitting}
                patients={patients}
            />

            <ConfirmDialog
                open={!!deleteId}
                onOpenChange={(open) => !open && setDeleteId(null)}
                onConfirm={handleDelete}
                title="Supprimer la consultation"
                description="Êtes-vous sûr de vouloir supprimer cette consultation ? Cette action est irréversible."
            />
        </div>
    );
}
