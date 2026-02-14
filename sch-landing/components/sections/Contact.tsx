"use client";

import { motion } from "framer-motion";
import { Mail, Phone, Heart } from "lucide-react";
import { Button } from "@/components/ui/button";

export function Contact() {
    return (
        <section className="py-24 bg-slate-900 text-white relative overflow-hidden" id="contact">
            <div className="absolute inset-0 bg-blue-600/10 z-0" />
            <div className="absolute -top-24 -right-24 w-96 h-96 bg-blue-500/20 rounded-full blur-3xl z-0" />

            <div className="container relative z-10 mx-auto px-4 md:px-6">
                <div className="max-w-4xl mx-auto bg-slate-800/50 backdrop-blur-sm border border-slate-700 rounded-3xl p-8 md:p-12 shadow-2xl">
                    <div className="text-center mb-12">
                        <h2 className="text-3xl font-bold mb-4">Rejoignez le Mouvement</h2>
                        <p className="text-slate-300 text-lg max-w-2xl mx-auto">
                            Votre soutien permet de digitaliser de nouvelles cliniques et de sauver plus de vies. Devenez partenaire de Santé Connectée Haïti.
                        </p>
                    </div>

                    <div className="grid md:grid-cols-2 gap-8">
                        <div className="space-y-6">
                            <div className="bg-slate-800 p-6 rounded-xl border border-slate-700">
                                <Heart className="h-8 w-8 text-accent mb-4" />
                                <h3 className="font-bold text-xl mb-2">Faire un Don</h3>
                                <p className="text-slate-400 mb-4 text-sm">Soutenez directement le déploiement de la solution dans les zones reculées.</p>
                                <Button className="w-full bg-accent hover:bg-amber-600 text-white">Contribuer</Button>
                            </div>

                            <div className="bg-slate-800 p-6 rounded-xl border border-slate-700">
                                <Mail className="h-8 w-8 text-blue-400 mb-4" />
                                <h3 className="font-bold text-xl mb-2">Partenariat Institutionnel</h3>
                                <p className="text-slate-400 mb-4 text-sm">Pour les ONG et bailleurs souhaitant intégrer le réseau.</p>
                                <Button variant="outline" className="w-full border-slate-600 text-slate-200 hover:bg-slate-700">Contacter l'équipe</Button>
                            </div>
                        </div>

                        <form
                            className="space-y-4"
                            action="https://formsubmit.co/jeromechristopher05@gmail.com"
                            method="POST"
                        >
                            <input type="hidden" name="_subject" value="Nouveau message - Landing Page SCH" />
                            <input type="hidden" name="_captcha" value="false" />

                            <div className="grid grid-cols-2 gap-4">
                                <div className="space-y-2">
                                    <label className="text-sm font-medium text-slate-300">Prénom</label>
                                    <input name="prenom" required className="w-full bg-slate-900/50 border border-slate-700 rounded-lg p-3 text-sm focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Jean" />
                                </div>
                                <div className="space-y-2">
                                    <label className="text-sm font-medium text-slate-300">Nom</label>
                                    <input name="nom" required className="w-full bg-slate-900/50 border border-slate-700 rounded-lg p-3 text-sm focus:ring-2 focus:ring-blue-500 outline-none" placeholder="Pierre" />
                                </div>
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-medium text-slate-300">Email</label>
                                <input type="email" name="email" required className="w-full bg-slate-900/50 border border-slate-700 rounded-lg p-3 text-sm focus:ring-2 focus:ring-blue-500 outline-none" placeholder="jean.pierre@exemple.com" />
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-medium text-slate-300">Message</label>
                                <textarea name="message" required className="w-full bg-slate-900/50 border border-slate-700 rounded-lg p-3 text-sm focus:ring-2 focus:ring-blue-500 outline-none h-32" placeholder="Je souhaite en savoir plus..." />
                            </div>
                            <Button type="submit" className="w-full bg-primary hover:bg-blue-600">Envoyer le message</Button>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    );
}
