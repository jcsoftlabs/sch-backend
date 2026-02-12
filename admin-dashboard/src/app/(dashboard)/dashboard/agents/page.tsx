"use client";

import { Agent, createColumns } from "@/components/dashboard/AgentTable";
import { DataTable } from "@/components/ui/data-table";
import { AgentService } from "@/services/agent.service";
import { useEffect, useState } from "react";
import { Loader2, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { AgentForm } from "@/components/dashboard/AgentForm";
import { ConfirmDialog } from "@/components/ui/confirm-dialog";
import { useToast } from "@/hooks/use-toast";

export default function AgentsPage() {
    const [data, setData] = useState<Agent[]>([]);
    const [loading, setLoading] = useState(true);
    const [formOpen, setFormOpen] = useState(false);
    const [editingAgent, setEditingAgent] = useState<Agent | undefined>();
    const [deleteId, setDeleteId] = useState<string | null>(null);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const { toast } = useToast();

    const fetchData = async () => {
        try {
            const agents = await AgentService.getAll();
            setData(agents);
        } catch (error) {
            console.error("Failed to load agents", error);
            toast({
                title: "Erreur",
                description: "Impossible de charger les agents",
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
            await AgentService.create(formData);
            toast({
                title: "Succès",
                description: "Agent créé avec succès",
            });
            setFormOpen(false);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de créer l'agent",
                variant: "destructive",
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleUpdate = async (formData: any) => {
        if (!editingAgent) return;
        setIsSubmitting(true);
        try {
            await AgentService.update(editingAgent.id, formData);
            toast({
                title: "Succès",
                description: "Agent modifié avec succès",
            });
            setFormOpen(false);
            setEditingAgent(undefined);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de modifier l'agent",
                variant: "destructive",
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleDelete = async () => {
        if (!deleteId) return;
        try {
            await AgentService.delete(deleteId);
            toast({
                title: "Succès",
                description: "Agent supprimé avec succès",
            });
            setDeleteId(null);
            fetchData();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de supprimer l'agent",
                variant: "destructive",
            });
        }
    };

    const columns = createColumns(
        (agent) => {
            setEditingAgent(agent);
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
                    <h2 className="text-2xl font-bold tracking-tight">Gestion des Agents</h2>
                    <p className="text-muted-foreground">
                        Liste complète des agents du système.
                    </p>
                </div>
                <Button onClick={() => { setEditingAgent(undefined); setFormOpen(true); }}>
                    <Plus className="mr-2 h-4 w-4" />
                    Nouvel agent
                </Button>
            </div>
            <DataTable data={data} columns={columns} searchKey="name" />

            <AgentForm
                open={formOpen}
                onOpenChange={(open) => {
                    setFormOpen(open);
                    if (!open) setEditingAgent(undefined);
                }}
                onSubmit={editingAgent ? handleUpdate : handleCreate}
                initialData={editingAgent}
                isLoading={isSubmitting}
            />

            <ConfirmDialog
                open={!!deleteId}
                onOpenChange={(open) => !open && setDeleteId(null)}
                onConfirm={handleDelete}
                title="Supprimer l'agent"
                description="Êtes-vous sûr de vouloir supprimer cet agent ? Cette action est irréversible."
            />
        </div>
    );
}
