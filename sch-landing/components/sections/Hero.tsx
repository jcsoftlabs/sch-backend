"use client";

import { motion } from "framer-motion";
import { ArrowRight, Play } from "lucide-react";
import { Button } from "@/components/ui/button";

export function Hero() {
    return (
        <section className="relative min-h-screen flex items-center justify-center overflow-hidden bg-slate-900 pt-20">
            {/* Background with Gradient Overlay */}
            <div className="absolute inset-0 z-0">
                <div className="absolute inset-0 bg-gradient-to-r from-slate-900/90 to-slate-900/40 z-10" />
                {/* Placeholder for video or high-quality image */}
                <div className="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80')] bg-cover bg-center opacity-60 mix-blend-overlay" />
            </div>

            <div className="container relative z-20 mx-auto px-4 md:px-6">
                <div className="max-w-3xl space-y-8">
                    <motion.div
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.5 }}
                        className="inline-flex items-center rounded-full border border-blue-500/30 bg-blue-500/10 px-3 py-1 text-sm font-medium text-blue-300 backdrop-blur-xl"
                    >
                        <span className="flex h-2 w-2 rounded-full bg-blue-400 mr-2 animate-pulse" />
                        Projet de Transformation Numérique
                    </motion.div>

                    <motion.h1
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.5, delay: 0.1 }}
                        className="text-4xl md:text-6xl lg:text-7xl font-bold tracking-tight text-white leading-tight"
                    >
                        Soutenir la <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-cyan-400">Digitalisation</span> de la Santé en Haïti
                    </motion.h1>

                    <motion.p
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.5, delay: 0.2 }}
                        className="text-lg md:text-xl text-slate-300 max-w-2xl leading-relaxed"
                    >
                        Une initiative prête à être déployée pour connecter les zones rurales, gérer les urgences en temps réel et renforcer le système de santé national.
                    </motion.p>

                    <motion.div
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.5, delay: 0.3 }}
                        className="flex flex-col sm:flex-row gap-4"
                    >
                        <Button size="lg" className="bg-primary hover:bg-blue-600 text-white gap-2 h-14 px-8 text-lg shadow-blue-500/25 shadow-xl">
                            Rejoindre l'initiative
                            <ArrowRight className="h-5 w-5" />
                        </Button>
                        <Button size="lg" variant="outline" className="text-white border-white/20 hover:bg-white/10 gap-2 h-14 px-8 text-lg backdrop-blur-sm">
                            <Play className="h-5 w-5 fill-current" />
                            Voir la vidéo
                        </Button>
                    </motion.div>
                </div>
            </div>

            {/* Abstract Shapes */}
            <div className="absolute -bottom-24 -right-24 w-96 h-96 bg-blue-600/20 rounded-full blur-3xl z-10 animate-pulse" />
            <div className="absolute top-24 -left-24 w-72 h-72 bg-cyan-600/20 rounded-full blur-3xl z-10" />
        </section>
    );
}
