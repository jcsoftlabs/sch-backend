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
        <div className="min-h-screen flex flex-col items-center justify-center bg-slate-50 relative overflow-hidden">
            {/* Background decoration */}
            <div className="absolute top-0 left-0 w-full h-64 bg-slate-900 skew-y-3 origin-top-left transform -translate-y-20 z-0"></div>
            <div className="absolute inset-0 z-0 opacity-5 bg-[radial-gradient(#0066CC_1px,transparent_1px)] [background-size:16px_16px]"></div>

            <Card className="w-full max-w-md shadow-2xl z-10 border-t-4 border-t-primary animate-fade-in relative bg-white">
                <CardHeader className="space-y-3 pb-8 text-center pt-8">
                    <div className="mx-auto h-16 w-16 bg-gradient-mspp rounded-xl flex items-center justify-center shadow-lg mb-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-white"><path d="M22 12h-4l-3 9L9 3l-3 9H2" /></svg>
                    </div>
                    <div>
                        <CardTitle className="text-2xl font-bold text-slate-900">MSPP Admin</CardTitle>
                        <p className="text-sm font-medium text-slate-500 mt-2">Système de Santé Communautaire</p>
                    </div>
                </CardHeader>
                <CardContent className="px-8 pb-8">
                    <Form {...form}>
                        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-5">
                            <FormField
                                control={form.control}
                                name="email"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel className="text-slate-700 font-semibold">Adresse Email</FormLabel>
                                        <FormControl>
                                            <div className="relative">
                                                <Input
                                                    placeholder="admin@mspp.ht"
                                                    {...field}
                                                    className="pl-10 h-11 border-slate-300 focus:border-blue-500 focus:ring-blue-500 bg-slate-50/50"
                                                />
                                                <div className="absolute left-3 top-3 text-slate-400">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" /><polyline points="22,6 12,13 2,6" /></svg>
                                                </div>
                                            </div>
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
                                        <FormLabel className="text-slate-700 font-semibold">Mot de passe</FormLabel>
                                        <FormControl>
                                            <div className="relative">
                                                <Input
                                                    type="password"
                                                    placeholder="••••••••"
                                                    {...field}
                                                    className="pl-10 h-11 border-slate-300 focus:border-blue-500 focus:ring-blue-500 bg-slate-50/50"
                                                />
                                                <div className="absolute left-3 top-3 text-slate-400">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect width="18" height="11" x="3" y="11" rx="2" ry="2" /><path d="M7 11V7a5 5 0 0 1 10 0v4" /></svg>
                                                </div>
                                            </div>
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />

                            {error && (
                                <div className="p-3 rounded-md bg-red-50 border border-red-200 text-red-600 text-sm flex items-center gap-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10" /><line x1="12" x2="12" y1="8" y2="12" /><line x1="12" x2="12.01" y1="16" y2="16" /></svg>
                                    {error}
                                </div>
                            )}

                            <Button
                                type="submit"
                                className="w-full h-11 bg-primary hover:bg-blue-700 text-white font-semibold text-base shadow-md transition-all duration-200 mt-2"
                                disabled={isLoading}
                            >
                                {isLoading ? (
                                    <>
                                        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                                        Connexion en cours...
                                    </>
                                ) : "Se connecter"}
                            </Button>
                        </form>
                    </Form>
                </CardContent>
            </Card>
            <div className="mt-8 text-center text-slate-500 text-sm z-10">
                <p>© 2026 Ministère de la Santé Publique et de la Population</p>
                <p className="mt-1">Haiti - Support Technique: 3662-5555</p>
            </div>
        </div>
    );
}
