"use client";

import { Household, createColumns } from "@/components/dashboard/HouseholdTable";
import { DataTable } from "@/components/ui/data-table";
import { HouseholdService } from "@/services/household.service";
import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2 } from "lucide-react";
import { ConfirmDialog } from "@/components/ui/confirm-dialog";
import { useToast } from "@/hooks/use-toast";

export default function HouseholdsPage() {
    const router = useRouter();
    const [data, setData] = useState<Household[]>([]);
    const [loading, setLoading] = useState(true);
    const [deleteId, setDeleteId] = useState<string | null>(null);
    const { toast } = useToast();

    const fetchData = async () => {
        try {
            const households = await HouseholdService.getAll();
            setData(households);
        } catch (error) {
            console.error("Failed to load households", error);
            toast({
                title: "Erreur",
                description: "Impossible de charger les ménages",
                variant: "destructive",
            });
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);

    const handleDelete = async () => {
        if (!deleteId) return;
        try {
            await HouseholdService.delete(deleteId);
            toast({
                title: "Succès",
                description: "Ménage supprimé avec succès",
            });
            setDeleteId(null);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de supprimer le ménage",
                variant: "destructive",
            });
        }
    };

    const columns = createColumns(
        (household) => router.push(`/dashboard/households/${household.id}`),
        (id) => setDeleteId(id)
    );

    if (loading) {
        return <div className="flex h-full items-center justify-center"><Loader2 className="h-8 w-8 animate-spin" /></div>
    }

    return (
        <div className="hidden h-full flex-1 flex-col space-y-8 p-8 md:flex">
            <div className="flex items-center justify-between space-y-2">
                <div>
                    <h2 className="text-2xl font-bold tracking-tight text-slate-900">Gestion des Ménages</h2>
                    <p className="text-slate-500">
                        Liste complète des ménages enregistrés dans la communauté.
                    </p>
                </div>
            </div>
            <DataTable
                data={data}
                columns={columns}
                searchKey="householdHeadName"
                onRowClick={(household) => router.push(`/dashboard/households/${household.id}`)}
            />

            <ConfirmDialog
                open={!!deleteId}
                onOpenChange={(open) => !open && setDeleteId(null)}
                onConfirm={handleDelete}
                title="Supprimer le ménage"
                description="Êtes-vous sûr de vouloir supprimer ce ménage et tous ses membres ? Cette action est irréversible."
            />
        </div>
    );
}
