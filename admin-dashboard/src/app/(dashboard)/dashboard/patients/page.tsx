"use client";

import { Patient, createColumns } from "@/components/dashboard/PatientTable";
import { DataTable } from "@/components/ui/data-table";
import { PatientService } from "@/services/patient.service";
import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { PatientForm } from "@/components/dashboard/PatientForm";
import { ConfirmDialog } from "@/components/ui/confirm-dialog";
import { useToast } from "@/hooks/use-toast";

export default function PatientsPage() {
    const router = useRouter();
    const [data, setData] = useState<Patient[]>([]);
    const [loading, setLoading] = useState(true);
    const [formOpen, setFormOpen] = useState(false);
    const [editingPatient, setEditingPatient] = useState<Patient | undefined>();
    const [deleteId, setDeleteId] = useState<string | null>(null);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const { toast } = useToast();

    const fetchData = async () => {
        try {
            const patients = await PatientService.getAll();
            const formattedPatients = patients.map((p: any) => ({
                id: p.id,
                firstName: p.firstName,
                lastName: p.lastName,
                email: p.email,
                status: "Actif" as "Actif" | "Inactif",
                lastVisit: p.createdAt ? new Date(p.createdAt).toLocaleDateString() : "N/A"
            }));
            setData(formattedPatients);
        } catch (error) {
            console.error("Failed to load patients", error);
            toast({
                title: "Erreur",
                description: "Impossible de charger les patients",
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
            await PatientService.create(formData);
            toast({
                title: "Succès",
                description: "Patient créé avec succès",
            });
            setFormOpen(false);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de créer le patient",
                variant: "destructive",
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleUpdate = async (formData: any) => {
        if (!editingPatient) return;
        setIsSubmitting(true);
        try {
            await PatientService.update(editingPatient.id, formData);
            toast({
                title: "Succès",
                description: "Patient modifié avec succès",
            });
            setFormOpen(false);
            setEditingPatient(undefined);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de modifier le patient",
                variant: "destructive",
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleDelete = async () => {
        if (!deleteId) return;
        try {
            await PatientService.delete(deleteId);
            toast({
                title: "Succès",
                description: "Patient supprimé avec succès",
            });
            setDeleteId(null);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de supprimer le patient",
                variant: "destructive",
            });
        }
    };

    const columns = createColumns(
        (patient) => {
            setEditingPatient(patient);
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
                    <h2 className="text-2xl font-bold tracking-tight">Gestion des Patients</h2>
                    <p className="text-muted-foreground">
                        Liste complète des patients enregistrés dans le système.
                    </p>
                </div>
                <Button onClick={() => { setEditingPatient(undefined); setFormOpen(true); }}>
                    <Plus className="mr-2 h-4 w-4" />
                    Nouveau patient
                </Button>
            </div>
            <DataTable
                data={data}
                columns={columns}
                searchKey="lastName"
                onRowClick={(patient) => router.push(`/dashboard/patients/${patient.id}`)}
            />

            <PatientForm
                open={formOpen}
                onOpenChange={(open) => {
                    setFormOpen(open);
                    if (!open) setEditingPatient(undefined);
                }}
                onSubmit={editingPatient ? handleUpdate : handleCreate}
                initialData={editingPatient}
                isLoading={isSubmitting}
            />

            <ConfirmDialog
                open={!!deleteId}
                onOpenChange={(open) => !open && setDeleteId(null)}
                onConfirm={handleDelete}
                title="Supprimer le patient"
                description="Êtes-vous sûr de vouloir supprimer ce patient ? Cette action est irréversible."
            />
        </div>
    );
}
