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
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select";
import { Consultation } from "@/services/consultation.service";

const consultationSchema = z.object({
    patientId: z.string().min(1, "Patient requis"),
    doctorId: z.string().optional(),
    status: z.enum(["PENDING", "ACCEPTED", "COMPLETED", "CANCELLED"]),
});

type ConsultationFormData = z.infer<typeof consultationSchema>;

interface ConsultationFormProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
    onSubmit: (data: ConsultationFormData) => Promise<void>;
    initialData?: Partial<Consultation>;
    isLoading?: boolean;
    patients?: Array<{ id: string; firstName: string; lastName: string }>;
}

export function ConsultationForm({
    open,
    onOpenChange,
    onSubmit,
    initialData,
    isLoading = false,
    patients = [],
}: ConsultationFormProps) {
    const form = useForm<ConsultationFormData>({
        resolver: zodResolver(consultationSchema),
        defaultValues: {
            patientId: initialData?.patientId || "",
            doctorId: initialData?.doctorId || "",
            status: initialData?.status || "PENDING",
        },
    });

    const handleSubmit = async (data: ConsultationFormData) => {
        await onSubmit(data);
        form.reset();
    };

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="sm:max-w-[500px]">
                <DialogHeader>
                    <DialogTitle>
                        {initialData ? "Modifier la consultation" : "Nouvelle consultation"}
                    </DialogTitle>
                </DialogHeader>
                <Form {...form}>
                    <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
                        <FormField
                            control={form.control}
                            name="patientId"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Patient *</FormLabel>
                                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                                        <FormControl>
                                            <SelectTrigger>
                                                <SelectValue placeholder="Sélectionner un patient" />
                                            </SelectTrigger>
                                        </FormControl>
                                        <SelectContent>
                                            {patients.map((patient) => (
                                                <SelectItem key={patient.id} value={patient.id}>
                                                    {patient.firstName} {patient.lastName}
                                                </SelectItem>
                                            ))}
                                        </SelectContent>
                                    </Select>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="doctorId"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>ID Médecin (optionnel)</FormLabel>
                                    <FormControl>
                                        <Input {...field} placeholder="UUID du médecin" />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="status"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Statut</FormLabel>
                                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                                        <FormControl>
                                            <SelectTrigger>
                                                <SelectValue />
                                            </SelectTrigger>
                                        </FormControl>
                                        <SelectContent>
                                            <SelectItem value="PENDING">En attente</SelectItem>
                                            <SelectItem value="ACCEPTED">Acceptée</SelectItem>
                                            <SelectItem value="COMPLETED">Terminée</SelectItem>
                                            <SelectItem value="CANCELLED">Annulée</SelectItem>
                                        </SelectContent>
                                    </Select>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
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
