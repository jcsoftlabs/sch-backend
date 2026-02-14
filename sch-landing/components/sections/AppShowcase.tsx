"use client";

import Image from "next/image";
import { motion } from "framer-motion";
import { Download, Laptop, Smartphone, Activity } from "lucide-react";
import { Button } from "@/components/ui/button";

export function AppShowcase() {
    return (
        <section className="py-24 bg-slate-50 overflow-hidden">
            <div className="container mx-auto px-4 md:px-6">
                <div className="text-center max-w-3xl mx-auto mb-16">
                    <h2 className="text-3xl font-bold tracking-tight text-slate-900 sm:text-4xl mb-4">
                        La Solution Technologique
                    </h2>
                    <p className="text-lg text-slate-600">
                        Une architecture modulaire conçue pour être déployée rapidement : Dashboard centralisé pour le Ministère et application mobile offline-first pour les agents.
                    </p>
                </div>
            </div>

            <div className="relative">
                {/* Background Decoration */}
                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-gradient-to-b from-blue-100/50 to-transparent rounded-full blur-3xl -z-10" />

                <div className="grid md:grid-cols-2 gap-12 items-center">
                    {/* Dashboard Screenshot Mockup */}
                    <motion.div
                        initial={{ opacity: 0, x: -50 }}
                        whileInView={{ opacity: 1, x: 0 }}
                        viewport={{ once: true }}
                        className="relative rounded-xl overflow-hidden shadow-2xl border border-slate-200 bg-white"
                    >
                        {/* Browser Chrome */}
                        <div className="bg-slate-100 p-2 border-b border-slate-200 flex items-center gap-2">
                            <div className="flex gap-1.5">
                                <div className="w-2.5 h-2.5 rounded-full bg-red-400" />
                                <div className="w-2.5 h-2.5 rounded-full bg-amber-400" />
                                <div className="w-2.5 h-2.5 rounded-full bg-green-400" />
                            </div>
                            <div className="text-[10px] text-slate-400 font-mono ml-2 flex-1 text-center pr-12">
                                dashboard.mspp.ht
                            </div>
                        </div>

                        {/* Dashboard Image */}
                        <div className="relative aspect-video bg-slate-50">
                            <Image
                                src="/dashboard-preview.png"
                                alt="Interface du Dashboard Administratif SCH"
                                fill
                                className="object-cover"
                            />
                        </div>

                        <div className="absolute bottom-4 right-4 bg-slate-900/90 text-white px-3 py-1 rounded-md text-xs backdrop-blur-sm flex items-center gap-2">
                            <Laptop className="h-3 w-3" />
                            Dashboard Admin
                        </div>
                    </motion.div>

                    {/* Mobile App Mockup */}
                    <motion.div
                        initial={{ opacity: 0, x: 50 }}
                        whileInView={{ opacity: 1, x: 0 }}
                        viewport={{ once: true }}
                        className="relative mx-auto"
                    >
                        <div className="relative w-[280px] h-[580px] bg-slate-900 rounded-[3rem] p-3 shadow-2xl border-4 border-slate-800">
                            {/* Notch */}
                            <div className="absolute top-0 left-1/2 -translate-x-1/2 w-32 h-6 bg-slate-900 rounded-b-2xl z-20" />

                            {/* Screen */}
                            <div className="w-full h-full bg-white rounded-[2.5rem] overflow-hidden relative">
                                {/* Header */}
                                <div className="h-32 bg-primary p-6 pt-12 text-white">
                                    <Activity className="h-8 w-8 mb-2" />
                                    <div className="text-lg font-bold">Bonjour, Dr. Jean</div>
                                </div>

                                {/* Body */}
                                <div className="p-4 space-y-4 bg-slate-50 h-full">
                                    <div className="bg-white p-4 rounded-xl shadow-sm border border-slate-100">
                                        <div className="text-xs text-slate-500 uppercase font-semibold mb-2">Patients du jour</div>
                                        <div className="text-3xl font-bold text-slate-900">12</div>
                                    </div>
                                    <div className="bg-white p-4 rounded-xl shadow-sm border border-slate-100">
                                        <div className="text-xs text-slate-500 uppercase font-semibold mb-2">Alertes</div>
                                        <div className="flex items-center gap-2 text-red-600 font-bold">
                                            Warnings: 2
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </motion.div>
                </div>

                <div className="text-center mt-12">
                    <a href="/Santé_Connectée_Haïti_SCH.pdf" download="Santé_Connectée_Haïti_SCH.pdf">
                        <Button className="bg-primary text-white hover:bg-blue-700 shadow-xl shadow-blue-500/20 gap-2">
                            <Download className="h-4 w-4" />
                            Télécharger la présentation technique
                        </Button>
                    </a>
                </div>
            </div>
        </section>
    );
}
