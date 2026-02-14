"use client";

import { useEffect, useState } from "react";
import { useAuthStore } from "@/stores/auth.store";
import { UserService, User } from "@/services/user.service";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Button } from "@/components/ui/button";
import {
    Form,
    FormControl,
    FormDescription,
    FormField,
    FormItem,
    FormLabel,
    FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { useToast } from "@/hooks/use-toast";
import { Loader2, Save } from "lucide-react";

const profileSchema = z.object({
    name: z.string().min(2, "Le nom doit contenir au moins 2 caractères"),
    email: z.string().email("Email invalide"),
    phone: z.string().optional(),
    password: z.string().min(6, "Le mot de passe doit contenir au moins 6 caractères").optional().or(z.literal("")),
});

export default function ProfilePage() {
    const { user: authUser, login } = useAuthStore();
    const [loading, setLoading] = useState(false);
    const [fetching, setFetching] = useState(true);
    const { toast } = useToast();

    const form = useForm<z.infer<typeof profileSchema>>({
        resolver: zodResolver(profileSchema),
        defaultValues: {
            name: "",
            email: "",
            phone: "",
            password: "",
        },
    });

    useEffect(() => {
        const fetchProfile = async () => {
            if (authUser?.id) {
                try {
                    const userData = await UserService.getById(authUser.id);
                    form.reset({
                        name: userData.name,
                        email: userData.email,
                        phone: userData.phone || "",
                        password: "",
                    });
                } catch (error) {
                    console.error("Failed to load profile", error);
                    toast({
                        title: "Erreur",
                        description: "Impossible de charger le profil",
                        variant: "destructive",
                    });
                } finally {
                    setFetching(false);
                }
            }
        };
        fetchProfile();
    }, [authUser, toast, form]);

    const onSubmit = async (values: z.infer<typeof profileSchema>) => {
        if (!authUser?.id) return;

        setLoading(true);
        try {
            const updateData: any = {
                name: values.name,
                email: values.email,
                phone: values.phone,
            };

            if (values.password) {
                updateData.password = values.password;
            }

            const updatedUser = await UserService.update(authUser.id, updateData);

            // Update local auth store if name/email changed
            // Note: login() expects (user, token). We need to keep the existing token.
            const token = useAuthStore.getState().token;
            if (token) {
                login(updatedUser, token);
            }

            toast({
                title: "Succès",
                description: "Profil mis à jour avec succès",
            });

            // Clear password field
            form.setValue("password", "");
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de mettre à jour le profil",
                variant: "destructive",
            });
        } finally {
            setLoading(false);
        }
    };

    if (fetching) {
        return <div className="flex h-full items-center justify-center"><Loader2 className="h-8 w-8 animate-spin" /></div>;
    }

    return (
        <div className="flex-1 space-y-4 p-8 pt-6">
            <div className="flex items-center justify-between space-y-2">
                <h2 className="text-3xl font-bold tracking-tight text-slate-900">Profil Utilisateur</h2>
            </div>

            <div className="grid gap-4 md:grid-cols-2">
                <Card>
                    <CardHeader>
                        <CardTitle className="text-slate-900">Informations Personnelles</CardTitle>
                        <CardDescription className="text-slate-500">
                            Modifiez vos informations de contact et de connexion.
                        </CardDescription>
                    </CardHeader>
                    <CardContent>
                        <Form {...form}>
                            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
                                <FormField
                                    control={form.control}
                                    name="name"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel className="text-slate-900">Nom complet</FormLabel>
                                            <FormControl>
                                                <Input placeholder="Jean Valjean" {...field} />
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
                                            <FormLabel className="text-slate-900">Email</FormLabel>
                                            <FormControl>
                                                <Input placeholder="jean@example.com" {...field} />
                                            </FormControl>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <FormField
                                    control={form.control}
                                    name="phone"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel className="text-slate-900">Téléphone</FormLabel>
                                            <FormControl>
                                                <Input placeholder="+509..." {...field} />
                                            </FormControl>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <FormField
                                    control={form.control}
                                    name="password"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel className="text-slate-900">Nouveau mot de passe (optionnel)</FormLabel>
                                            <FormControl>
                                                <Input type="password" placeholder="******" {...field} />
                                            </FormControl>
                                            <FormDescription className="text-slate-500">
                                                Laissez vide pour conserver le mot de passe actuel.
                                            </FormDescription>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <Button type="submit" disabled={loading} className="bg-slate-900 text-white hover:bg-slate-800">
                                    {loading ? (
                                        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                                    ) : (
                                        <Save className="mr-2 h-4 w-4" />
                                    )}
                                    Enregistrer les modifications
                                </Button>
                            </form>
                        </Form>
                    </CardContent>
                </Card>

                <Card>
                    <CardHeader>
                        <CardTitle className="text-slate-900">Rôle et Accès</CardTitle>
                        <CardDescription className="text-slate-500">
                            Informations sur votre niveau d'accès (Lecture seule).
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-4">
                        <div className="space-y-1">
                            <h3 className="font-medium text-slate-900">Rôle</h3>
                            <p className="text-sm text-slate-500 capitalize">
                                {authUser?.role.toLowerCase()}
                            </p>
                        </div>
                        {authUser?.zone && (
                            <div className="space-y-1">
                                <h3 className="font-medium text-slate-900">Zone assignée</h3>
                                <p className="text-sm text-slate-500">
                                    {authUser.zone}
                                </p>
                            </div>
                        )}
                        <div className="space-y-1">
                            <h3 className="font-medium text-slate-900">ID Utilisateur</h3>
                            <p className="text-xs font-mono text-slate-500 bg-slate-100 p-2 rounded">
                                {authUser?.id}
                            </p>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </div>
    );
}
