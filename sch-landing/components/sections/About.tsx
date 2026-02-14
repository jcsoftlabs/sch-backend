"use client";

import { motion } from "framer-motion";
import { CheckCircle2, ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";

const features = [
    "Digitalisation des dossiers patients (EMR)",
    "Surveillance épidémiologique en temps réel",
    "Gestion des stocks de médicaments",
    "Coordination des agents de santé communautaire",
];

export function About() {
    return (
        <section className="py-24 bg-white" id="mission">
            <div className="container mx-auto px-4 md:px-6">
                <div className="grid lg:grid-cols-2 gap-16 items-center">

                    <motion.div
                        initial={{ opacity: 0, x: -50 }}
                        whileInView={{ opacity: 1, x: 0 }}
                        viewport={{ once: true }}
                        className="relative order-2 lg:order-1"
                    >
                        <div className="relative rounded-2xl overflow-hidden shadow-2xl border-4 border-white aspect-[4/3] bg-slate-100">
                            <div className="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1579684385127-1ef15d508118?ixlib=rb-4.0.3&auto=format&fit=crop&w=1760&q=80')] bg-cover bg-center" />
                            {/* Stats Card Overlay (Desktop) */}
                            <div className="absolute -bottom-6 -right-6 bg-white p-6 rounded-xl shadow-xl border border-slate-100 max-w-xs hidden md:block">
                                <div className="flex items-center gap-3 mb-2">
                                    <div className="h-2 w-2 rounded-full bg-blue-500 animate-pulse" />
                                    <span className="text-xs font-semibold text-slate-500 uppercase tracking-wide">Prototype Fonctionnel</span>
                                </div>
                                <p className="text-slate-900 font-bold text-lg">Prêt au déploiement</p>
                                <p className="text-xs text-slate-500 mt-1">Architecture validée.</p>
                            </div>
                        </div>
                    </motion.div>

                    <motion.div
                        initial={{ opacity: 0, x: 50 }}
                        whileInView={{ opacity: 1, x: 0 }}
                        viewport={{ once: true }}
                        className="space-y-8 order-1 lg:order-2"
                    >
                        <div>
                            <h2 className="text-primary font-bold uppercase tracking-wider text-sm mb-3">Notre Mission</h2>
                            <h3 className="text-3xl md:text-4xl font-bold text-slate-900 leading-tight">
                                Construire l'infrastructure numérique de la santé de demain.
                            </h3>
                        </div>

                        <p className="text-lg text-slate-600 leading-relaxed">
                            Santé Connectée Haïti (SCH) n'est pas seulement une application, c'est un écosystème complet conçu pour résoudre les défis structurels du système de santé haïtien. En connectant les cliniques rurales aux centres urbains, nous réduisons les délais de prise en charge et sauvons des vies.
                        </p>

                        <ul className="space-y-4">
                            {features.map((feature, idx) => (
                                <li key={idx} className="flex items-start gap-3">
                                    <div className="mt-1 h-5 w-5 rounded-full bg-blue-100 flex items-center justify-center text-primary shrink-0">
                                        <CheckCircle2 className="h-3.5 w-3.5" />
                                    </div>
                                    <span className="text-slate-700 font-medium">{feature}</span>
                                </li>
                            ))}
                        </ul>

                        <div className="pt-2">
                            <Button className="bg-slate-900 hover:bg-slate-800 text-white gap-2">
                                En savoir plus sur notre approche
                                <ArrowRight className="h-4 w-4" />
                            </Button>
                        </div>
                    </motion.div>

                </div>
            </div>
        </section>
    );
}
