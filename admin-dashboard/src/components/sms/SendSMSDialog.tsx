"use client";

import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Button } from "@/components/ui/button";
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
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
import { Textarea } from "@/components/ui/textarea";
import { Loader2, Send } from "lucide-react";
import { useEffect } from "react";

const formSchema = z.object({
    to: z.string().min(8, "Numéro de téléphone invalide"),
    message: z.string().min(1, "Le message ne peut pas être vide").max(160, "Maximum 160 caractères"),
});

interface SendSMSDialogProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
    onSubmit: (data: { to: string; message: string }) => Promise<void>;
    isLoading: boolean;
    defaultPhone?: string;
}

export function SendSMSDialog({
    open,
    onOpenChange,
    onSubmit,
    isLoading,
    defaultPhone = "",
}: SendSMSDialogProps) {
    const form = useForm<z.infer<typeof formSchema>>({
        resolver: zodResolver(formSchema),
        defaultValues: {
            to: defaultPhone,
            message: "",
        },
    });

    // Update default phone when prop changes
    useEffect(() => {
        if (defaultPhone) {
            form.setValue("to", defaultPhone);
        }
    }, [defaultPhone, form]);

    async function handleSubmit(values: z.infer<typeof formSchema>) {
        await onSubmit(values);
        form.reset();
        onOpenChange(false);
    }

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="sm:max-w-[425px]">
                <DialogHeader>
                    <DialogTitle>Envoyer un SMS</DialogTitle>
                    <DialogDescription>
                        Envoyez un message rapide à un patient ou un agent.
                    </DialogDescription>
                </DialogHeader>
                <Form {...form}>
                    <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
                        <FormField
                            control={form.control}
                            name="to"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Numéro de téléphone</FormLabel>
                                    <FormControl>
                                        <Input placeholder="+509..." {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="message"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Message</FormLabel>
                                    <FormControl>
                                        <Textarea
                                            placeholder="Tapez votre message ici..."
                                            className="resize-none"
                                            rows={4}
                                            {...field}
                                        />
                                    </FormControl>
                                    <div className="text-xs text-muted-foreground text-right">
                                        {field.value?.length || 0}/160
                                    </div>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <DialogFooter>
                            <Button type="submit" disabled={isLoading}>
                                {isLoading ? (
                                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                                ) : (
                                    <Send className="mr-2 h-4 w-4" />
                                )}
                                Envoyer
                            </Button>
                        </DialogFooter>
                    </form>
                </Form>
            </DialogContent>
        </Dialog>
    );
}
