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

import { useRouter } from "next/navigation";
import dynamic from "next/dynamic";

export default function CentersPage() {
    const router = useRouter();
    const [data, setData] = useState<HealthCenter[]>([]);
    const [loading, setLoading] = useState(true);
    const [formOpen, setFormOpen] = useState(false);
    const [editingCenter, setEditingCenter] = useState<HealthCenter | undefined>();
    const [deleteId, setDeleteId] = useState<string | null>(null);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [viewMode, setViewMode] = useState<'list' | 'map'>('list');
    const { toast } = useToast();

    // Map component needs to be imported dynamically inside the component to work with recent NextJS/Leaflet patterns 
    // or we use the existing dynamic import pattern for the whole component if applicable. 
    // Here we reuse the pattern from map/page.tsx but importing the refactored HaitiMap

    const MapWithNoSSR = dynamic(
        () => import("@/components/dashboard/map/HaitiMap"),
        {
            ssr: false,
            loading: () => <Loader2 className="h-8 w-8 animate-spin" />,
        }
    );

    const fetchData = async () => {
        try {
            const centers = await CenterService.getAll();

            // MOCK COORDINATES FOR DEMO - Distribute them randomly across Haiti
            // Haiti approx: Lat 18.0 - 20.0, Lng -74.5 - -71.5
            const centersWithCoords = centers.map((c, i) => ({
                ...c,
                lat: c.lat || (18.5 + (Math.random() * 1.2)),
                lng: c.lng || (-74.0 + (Math.random() * 2.0))
            }));

            setData(centersWithCoords);
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
                <div className="flex items-center space-x-2">
                    <div className="flex bg-slate-100 p-1 rounded-lg">
                        <Button
                            variant={viewMode === 'list' ? 'default' : 'ghost'}
                            size="sm"
                            onClick={() => setViewMode('list')}
                            className="h-8"
                        >
                            Liste
                        </Button>
                        <Button
                            variant={viewMode === 'map' ? 'default' : 'ghost'}
                            size="sm"
                            onClick={() => setViewMode('map')}
                            className="h-8"
                        >
                            Carte
                        </Button>
                    </div>
                    <Button onClick={() => { setEditingCenter(undefined); setFormOpen(true); }}>
                        <Plus className="mr-2 h-4 w-4" />
                        Nouveau centre
                    </Button>
                </div>
            </div>

            {viewMode === 'list' ? (
                <DataTable
                    data={data}
                    columns={columns}
                    searchKey="name"
                    onRowClick={(center) => router.push(`/dashboard/centers/${center.id}`)}
                />
            ) : (
                <div className="h-[600px] w-full border rounded-lg overflow-hidden relative z-0">
                    <MapWithNoSSR centers={data} />
                </div>
            )}

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
