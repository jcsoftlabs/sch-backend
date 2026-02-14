"use client";

import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Button } from "@/components/ui/button";
import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogFooter,
} from "@/components/ui/dialog";
import {
    Form,
    FormControl,
    FormField,
    FormItem,
    FormLabel,
    FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Agent } from "@/services/agent.service";

const agentSchema = z.object({
    name: z.string().min(1, "Nom requis"),
    email: z.string().email("Email invalide"),
    password: z.string().min(6, "Minimum 6 caractères").optional(),
});

type AgentFormData = z.infer<typeof agentSchema>;

interface AgentFormProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
    onSubmit: (data: AgentFormData) => Promise<void>;
    initialData?: Agent;
    isLoading?: boolean;
}

export function AgentForm({
    open,
    onOpenChange,
    onSubmit,
    initialData,
    isLoading = false,
}: AgentFormProps) {
    const form = useForm<AgentFormData>({
        resolver: zodResolver(agentSchema),
        defaultValues: initialData || {
            name: "",
            email: "",
            password: "",
        },
    });

    const handleSubmit = async (data: AgentFormData) => {
        await onSubmit(data);
        form.reset();
    };

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="sm:max-w-[500px]">
                <DialogHeader>
                    <DialogTitle className="text-slate-900">
                        {initialData ? "Modifier l'agent" : "Nouvel agent"}
                    </DialogTitle>
                </DialogHeader>
                <Form {...form}>
                    <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
                        <FormField
                            control={form.control}
                            name="name"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel className="text-slate-900">Nom complet *</FormLabel>
                                    <FormControl>
                                        <Input {...field} placeholder="Jean Dupont" />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="email"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel className="text-slate-900">Email *</FormLabel>
                                    <FormControl>
                                        <Input {...field} type="email" placeholder="agent@sch.ht" />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        {!initialData && (
                            <FormField
                                control={form.control}
                                name="password"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel className="text-slate-900">Mot de passe *</FormLabel>
                                        <FormControl>
                                            <Input {...field} type="password" placeholder="••••••" />
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                        )}
                        <DialogFooter>
                            <Button
                                type="button"
                                variant="outline"
                                onClick={() => onOpenChange(false)}
                                disabled={isLoading}
                            >
                                Annuler
                            </Button>
                            <Button type="submit" disabled={isLoading}>
                                {isLoading ? "Enregistrement..." : "Enregistrer"}
                            </Button>
                        </DialogFooter>
                    </form>
                </Form>
            </DialogContent>
        </Dialog>
    );
}
