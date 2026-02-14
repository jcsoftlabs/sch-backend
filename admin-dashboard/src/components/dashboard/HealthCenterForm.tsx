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
import { HealthCenter } from "./HealthCenterTable";

const centerSchema = z.object({
    name: z.string().min(1, "Nom requis"),
    address: z.string().min(1, "Adresse requise"),
    phone: z.string().optional(),
    capacity: z.number().min(1, "Capacité requise").optional(),
});

type CenterFormData = z.infer<typeof centerSchema>;

interface HealthCenterFormProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
    onSubmit: (data: CenterFormData) => Promise<void>;
    initialData?: HealthCenter;
    isLoading?: boolean;
}

export function HealthCenterForm({
    open,
    onOpenChange,
    onSubmit,
    initialData,
    isLoading = false,
}: HealthCenterFormProps) {
    const form = useForm<CenterFormData>({
        resolver: zodResolver(centerSchema),
        defaultValues: initialData || {
            name: "",
            address: "",
            phone: "",
            capacity: undefined,
        },
    });

    const handleSubmit = async (data: CenterFormData) => {
        await onSubmit(data);
        form.reset();
    };

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="sm:max-w-[500px]">
                <DialogHeader>
                    <DialogTitle className="text-slate-900">
                        {initialData ? "Modifier le centre" : "Nouveau centre de santé"}
                    </DialogTitle>
                </DialogHeader>
                <Form {...form}>
                    <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
                        <FormField
                            control={form.control}
                            name="name"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel className="text-slate-900">Nom *</FormLabel>
                                    <FormControl>
                                        <Input {...field} placeholder="Hôpital de l'Université d'État d'Haïti" />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="address"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel className="text-slate-900">Adresse *</FormLabel>
                                    <FormControl>
                                        <Input {...field} placeholder="Port-au-Prince, Haïti" />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <div className="grid grid-cols-2 gap-4">
                            <FormField
                                control={form.control}
                                name="phone"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel className="text-slate-900">Téléphone</FormLabel>
                                        <FormControl>
                                            <Input {...field} placeholder="+509 XXXX XXXX" />
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                            <FormField
                                control={form.control}
                                name="capacity"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel className="text-slate-900">Capacité</FormLabel>
                                        <FormControl>
                                            <Input
                                                type="number"
                                                {...field}
                                                onChange={(e) => field.onChange(e.target.value ? parseInt(e.target.value) : undefined)}
                                                value={field.value || ""}
                                            />
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                        </div>
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
