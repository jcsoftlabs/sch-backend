"use client";

import { motion } from "framer-motion";
import { Activity, Building2, Users, Map } from "lucide-react";

const stats = [
    {
        id: 1,
        name: "Objectif Cliniques",
        value: "150+",
        icon: Building2,
        description: "Centres de santé ciblés pour la phase pilote.",
    },
    {
        id: 2,
        name: "Vies Impactées (Est.)",
        value: "50k+",
        icon: Users,
        description: "Estimation des bénéficiaires directs la première année.",
    },
    {
        id: 3,
        name: "Temps de Réponse",
        value: "-60%",
        icon: Activity,
        description: "Réduction visée des délais d'intervention.",
    },
    {
        id: 4,
        name: "Couverture",
        value: "10",
        icon: Map,
        description: "Déploiement prévu dans les 10 départements.",
    },
];

export function Stats() {
    return (
        <section className="py-20 bg-slate-50 relative overflow-hidden" id="impact">
            <div className="container mx-auto px-4 md:px-6">
                <motion.div
                    initial={{ opacity: 0, y: 20 }}
                    whileInView={{ opacity: 1, y: 0 }}
                    viewport={{ once: true }}
                    className="text-center max-w-2xl mx-auto mb-16"
                >
                    <h2 className="text-3xl font-bold tracking-tight text-slate-900 sm:text-4xl mb-4">
                        Nos Objectifs d'Impact
                    </h2>
                    <p className="text-lg text-slate-600">
                        En digitalisant le réseau de santé, nous visons des résultats concrets et mesurables pour transformer l'accès aux soins.
                    </p>
                </motion.div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                    {stats.map((stat, index) => (
                        <motion.div
                            key={stat.id}
                            initial={{ opacity: 0, y: 20 }}
                            whileInView={{ opacity: 1, y: 0 }}
                            viewport={{ once: true }}
                            transition={{ delay: index * 0.1 }}
                            className="bg-white p-8 rounded-2xl shadow-sm border border-slate-100 hover:shadow-md transition-shadow"
                        >
                            <div className="h-12 w-12 rounded-xl bg-blue-50 flex items-center justify-center text-primary mb-6">
                                <stat.icon className="h-6 w-6" />
                            </div>
                            <h3 className="text-4xl font-bold text-slate-900 mb-2">{stat.value}</h3>
                            <p className="font-semibold text-slate-900 mb-2">{stat.name}</p>
                            <p className="text-sm text-slate-500 leading-relaxed">
                                {stat.description}
                            </p>
                        </motion.div>
                    ))}
                </div>
            </div>
        </section>
    );
}
