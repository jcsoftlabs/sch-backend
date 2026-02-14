"use client";

import { motion } from "framer-motion";

const partners = [
    { name: "Ministère Santé Publique", logo: "🏥" },
    { name: "UNICEF", logo: "🌍" },
    { name: "Sogebank Fondation", logo: "🏦" },
    { name: "Digicel Business", logo: "📡" },
    { name: "Partners In Health", logo: "🩺" },
];

export function Partners() {
    return (
        <section className="py-20 bg-white border-t border-slate-100" id="partners">
            <div className="container mx-auto px-4 md:px-6">
                <h2 className="text-center text-xl font-medium text-slate-500 mb-2 uppercase tracking-widest">
                    Un Écosystème de Partenaires Visé
                </h2>
                <p className="text-center text-sm text-slate-400 mb-12 max-w-2xl mx-auto">
                    Nous cherchons à collaborer avec les acteurs clés du secteur pour concrétiser cette vision.
                </p>

                <div className="flex flex-wrap justify-center items-center gap-12 md:gap-24 opacity-70 grayscale hover:grayscale-0 transition-all duration-500">
                    {partners.map((partner, index) => (
                        <motion.div
                            key={partner.name}
                            initial={{ opacity: 0 }}
                            whileInView={{ opacity: 1 }}
                            viewport={{ once: true }}
                            transition={{ delay: index * 0.1 }}
                            className="flex flex-col items-center gap-2 group cursor-pointer"
                        >
                            <div className="text-4xl md:text-5xl group-hover:scale-110 transition-transform duration-300 filter drop-shadow-sm">
                                {partner.logo}
                            </div>
                            <span className="text-xs font-semibold text-slate-400 group-hover:text-primary transition-colors">{partner.name}</span>
                        </motion.div>
                    ))}
                </div>
            </div>
        </section>
    );
}
