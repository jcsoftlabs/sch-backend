"use client";

import { motion } from "framer-motion";
import { MapPin, Radio, Globe, CheckCircle2 } from "lucide-react";

const phases = [
    {
        id: 1,
        title: "Phase Pilote (Mois 1-6)",
        subtitle: "Validation en Zone Rurale",
        description: "Déploiement dans 10 centres de santé isolés pour valider la technologie 'Offline-First' et la connectivité satellitaire.",
        points: [
            "Sélection de 10 zones enclavées prioritaires",
            "Installation des équipements solaires et terminaux",
            "Formation de 50 agents de santé locaux"
        ],
        icon: MapPin,
        color: "bg-blue-100 text-blue-600",
        border: "border-blue-200"
    },
    {
        id: 2,
        title: "Extension (Mois 7-18)",
        subtitle: "Désenclavement Numérique",
        description: "Expansion vers 50 communes difficiles d'accès. Interconnexion des centres ruraux avec les hôpitaux départementaux.",
        points: [
            "Intégration de 50 nouveaux centres",
            "Mise en place du système de référence/contre-référence",
            "Lancement des alertes épidémiologiques par SMS"
        ],
        icon: Radio,
        color: "bg-amber-100 text-amber-600",
        border: "border-amber-200"
    },
    {
        id: 3,
        title: "Maillage National (Année 2+)",
        subtitle: "Équité d'Accès aux Soins",
        description: "Couverture de l'ensemble du territoire national, garantissant que même les sections communales les plus reculées soient connectées.",
        points: [
            "Couverture nationale (10 départements)",
            "Interopérabilité totale avec le MSPP",
            "Autonomie financière via partenariats public-privé"
        ],
        icon: Globe,
        color: "bg-green-100 text-green-600",
        border: "border-green-200"
    }
];

export function Roadmap() {
    return (
        <section className="py-24 bg-white relative overflow-hidden">
            {/* Connecting Line (Desktop) */}
            <div className="absolute top-1/2 left-0 w-full h-1 bg-slate-100 -translate-y-1/2 hidden lg:block z-0" />

            <div className="container mx-auto px-4 md:px-6 relative z-10">
                <div className="text-center max-w-3xl mx-auto mb-16">
                    <h2 className="text-primary font-bold uppercase tracking-wider text-sm mb-3">Feuille de Route</h2>
                    <h3 className="text-3xl font-bold text-slate-900 sm:text-4xl mb-4">
                        Un Déploiement Stratégique
                    </h3>
                    <p className="text-lg text-slate-600">
                        Notre priorité : atteindre les populations oubliées. Une approche progressive pour garantir l'adoption durable de la solution dans les zones enclavées.
                    </p>
                </div>

                <div className="grid lg:grid-cols-3 gap-8">
                    {phases.map((phase, index) => (
                        <motion.div
                            key={phase.id}
                            initial={{ opacity: 0, y: 20 }}
                            whileInView={{ opacity: 1, y: 0 }}
                            viewport={{ once: true }}
                            transition={{ delay: index * 0.2 }}
                            className={`bg-white p-8 rounded-2xl shadow-lg border ${phase.border} relative group hover:-translate-y-2 transition-transform duration-300`}
                        >
                            {/* Step Number */}
                            <div className="absolute -top-4 -right-4 w-12 h-12 bg-slate-900 text-white rounded-xl flex items-center justify-center font-bold text-xl shadow-xl transform rotate-3 group-hover:rotate-6 transition-transform">
                                {phase.id}
                            </div>

                            <div className={`h-14 w-14 rounded-2xl ${phase.color} flex items-center justify-center mb-6`}>
                                <phase.icon className="h-7 w-7" />
                            </div>

                            <h4 className="text-sm font-bold text-primary uppercase tracking-wide mb-1">{phase.title}</h4>
                            <h3 className="text-2xl font-bold text-slate-900 mb-4">{phase.subtitle}</h3>
                            <p className="text-slate-600 mb-6 leading-relaxed">
                                {phase.description}
                            </p>

                            <ul className="space-y-3">
                                {phase.points.map((point, idx) => (
                                    <li key={idx} className="flex items-start gap-2 text-sm text-slate-700">
                                        <CheckCircle2 className="h-4 w-4 text-green-500 shrink-0 mt-0.5" />
                                        <span>{point}</span>
                                    </li>
                                ))}
                            </ul>
                        </motion.div>
                    ))}
                </div>
            </div>
        </section>
    );
}
