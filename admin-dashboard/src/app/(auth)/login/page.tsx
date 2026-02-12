"use client";

import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuthStore } from "@/stores/auth.store";
import api from "@/lib/api";
import { Button } from "@/components/ui/button";
import {
    Form,
    FormControl,
    FormField,
    FormItem,
    FormLabel,
    FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2 } from "lucide-react";

const formSchema = z.object({
    email: z.string().email(),
    password: z.string().min(6),
});

export default function LoginPage() {
    const router = useRouter();
    const login = useAuthStore((state) => state.login);
    const token = useAuthStore((state) => state.token);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState("");
    const [isHydrated, setIsHydrated] = useState(false);

    useEffect(() => {
        setIsHydrated(true);
    }, []);

    useEffect(() => {
        if (isHydrated && token) {
            router.push("/dashboard");
        }
    }, [token, isHydrated, router]);

    const form = useForm<z.infer<typeof formSchema>>({
        resolver: zodResolver(formSchema),
        defaultValues: {
            email: "",
            password: "",
        },
    });

    if (!isHydrated) return null;

    async function onSubmit(values: z.infer<typeof formSchema>) {
        setIsLoading(true);
        setError("");
        try {
            const response = await api.post("/auth/login", values);
            console.log("Login response:", response.data); // DEBUG
            login(response.data.data.user, response.data.data.accessToken);
            router.push("/dashboard");
        } catch (err: any) {
            console.error(err);
            setError("Identifiants incorrects ou erreur serveur.");
        } finally {
            setIsLoading(false);
        }
    }

    return (
        <div className="flex h-screen items-center justify-center bg-slate-50">
            <Card className="w-[400px]">
                <CardHeader>
                    <CardTitle className="text-2xl text-center text-primary">SCH Admin</CardTitle>
                </CardHeader>
                <CardContent>
                    <Form {...form}>
                        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
                            <FormField
                                control={form.control}
                                name="email"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>Email</FormLabel>
                                        <FormControl>
                                            <Input placeholder="admin@sch.ht" {...field} />
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
                                        <FormLabel>Mot de passe</FormLabel>
                                        <FormControl>
                                            <Input type="password" {...field} />
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                            {error && <p className="text-destructive text-sm">{error}</p>}
                            <Button type="submit" className="w-full" disabled={isLoading}>
                                {isLoading ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : null}
                                Se connecter
                            </Button>
                        </form>
                    </Form>
                </CardContent>
            </Card>
        </div>
    );
}
