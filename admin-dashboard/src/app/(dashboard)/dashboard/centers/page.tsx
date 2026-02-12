"use client";

import { HealthCenter, createColumns } from "@/components/dashboard/HealthCenterTable";
import { DataTable } from "@/components/ui/data-table";
import { CenterService } from "@/services/center.service";
import { useEffect, useState } from "react";
import { Loader2, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { HealthCenterForm } from "@/components/dashboard/HealthCenterForm";
import { ConfirmDialog } from "@/components/ui/confirm-dialog";
import { useToast } from "@/hooks/use-toast";

export default function CentersPage() {
    const [data, setData] = useState<HealthCenter[]>([]);
    const [loading, setLoading] = useState(true);
    const [formOpen, setFormOpen] = useState(false);
    const [editingCenter, setEditingCenter] = useState<HealthCenter | undefined>();
    const [deleteId, setDeleteId] = useState<string | null>(null);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const { toast } = useToast();

    const fetchData = async () => {
        try {
            const centers = await CenterService.getAll();
            setData(centers);
        } catch (error) {
            console.error("Failed to load centers", error);
            toast({
                title: "Erreur",
                description: "Impossible de charger les centres",
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
            await CenterService.create(formData);
            toast({
                title: "Succès",
                description: "Centre créé avec succès",
            });
            setFormOpen(false);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de créer le centre",
                variant: "destructive",
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleUpdate = async (formData: any) => {
        if (!editingCenter) return;
        setIsSubmitting(true);
        try {
            await CenterService.update(editingCenter.id, formData);
            toast({
                title: "Succès",
                description: "Centre modifié avec succès",
            });
            setFormOpen(false);
            setEditingCenter(undefined);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de modifier le centre",
                variant: "destructive",
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleDelete = async () => {
        if (!deleteId) return;
        try {
            await CenterService.delete(deleteId);
            toast({
                title: "Succès",
                description: "Centre supprimé avec succès",
            });
            setDeleteId(null);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de supprimer le centre",
                variant: "destructive",
            });
        }
    };

    const columns = createColumns(
        (center) => {
            setEditingCenter(center);
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
                    <h2 className="text-2xl font-bold tracking-tight">Gestion des Centres de Santé</h2>
                    <p className="text-muted-foreground">
                        Liste complète des centres de santé enregistrés.
                    </p>
                </div>
                <Button onClick={() => { setEditingCenter(undefined); setFormOpen(true); }}>
                    <Plus className="mr-2 h-4 w-4" />
                    Nouveau centre
                </Button>
            </div>
            <DataTable data={data} columns={columns} searchKey="name" />

            <HealthCenterForm
                open={formOpen}
                onOpenChange={(open) => {
                    setFormOpen(open);
                    if (!open) setEditingCenter(undefined);
                }}
                onSubmit={editingCenter ? handleUpdate : handleCreate}
                initialData={editingCenter}
                isLoading={isSubmitting}
            />

            <ConfirmDialog
                open={!!deleteId}
                onOpenChange={(open) => !open && setDeleteId(null)}
                onConfirm={handleDelete}
                title="Supprimer le centre"
                description="Êtes-vous sûr de vouloir supprimer ce centre de santé ? Cette action est irréversible."
            />
        </div>
    );
}
