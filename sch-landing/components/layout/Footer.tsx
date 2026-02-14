import Link from "next/link";
import { Activity, Facebook, Twitter, Instagram, Mail, Phone, MapPin } from "lucide-react";

export function Footer() {
    return (
        <footer className="bg-slate-900 text-slate-300 py-12 border-t border-slate-800">
            <div className="container mx-auto px-4 md:px-6">
                <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
                    {/* Brand Column */}
                    <div className="space-y-4">
                        <Link href="/" className="flex items-center gap-2 group">
                            <div className="h-8 w-8 rounded-lg bg-primary flex items-center justify-center text-white">
                                <Activity className="h-5 w-5" />
                            </div>
                            <span className="font-bold text-lg text-white">
                                Santé Connectée
                            </span>
                        </Link>
                        <p className="text-sm leading-relaxed max-w-xs">
                            Développé par <a href="#" className="text-primary hover:underline">CODESHELL LLC</a>. Expert en solutions numériques.
                        </p>
                        <div className="flex gap-4 pt-2">
                            <Link href="#" className="hover:text-white transition-colors">
                                <Facebook className="h-5 w-5" />
                            </Link>
                            <Link href="#" className="hover:text-white transition-colors">
                                <Twitter className="h-5 w-5" />
                            </Link>
                            <Link href="#" className="hover:text-white transition-colors">
                                <Instagram className="h-5 w-5" />
                            </Link>
                        </div>
                    </div>

                    {/* Quick Links */}
                    <div>
                        <h3 className="text-white font-semibold mb-4">Navigation</h3>
                        <ul className="space-y-2 text-sm">
                            <li><Link href="/" className="hover:text-primary transition-colors">Accueil</Link></li>
                            <li><Link href="/#mission" className="hover:text-primary transition-colors">Notre Mission</Link></li>
                            <li><Link href="/#impact" className="hover:text-primary transition-colors">Impact</Link></li>
                            <li><Link href="/#partners" className="hover:text-primary transition-colors">Partenaires</Link></li>
                        </ul>
                    </div>

                    {/* Legal / Resources */}
                    <div>
                        <h3 className="text-white font-semibold mb-4">Ressources</h3>
                        <ul className="space-y-2 text-sm">
                            <li><Link href="#" className="hover:text-primary transition-colors">Télécharger l'App</Link></li>
                            <li><Link href="#" className="hover:text-primary transition-colors">Espace Bailleurs</Link></li>
                            <li><Link href="#" className="hover:text-primary transition-colors">Politique de Confidentialité</Link></li>
                            <li><Link href="#" className="hover:text-primary transition-colors">Termes d'Utilisation</Link></li>
                        </ul>
                    </div>

                    {/* Contact */}
                    <div>
                        <h3 className="text-white font-semibold mb-4">Contact</h3>
                        <ul className="space-y-4 text-sm">
                            <li className="flex items-start gap-3">
                                <MapPin className="h-5 w-5 text-primary shrink-0" />
                                <span>CODESHELL LLC<br />+509 4910 9497</span>
                            </li>
                            <li className="flex items-center gap-3">
                                <Phone className="h-5 w-5 text-primary shrink-0" />
                                <span>+509 3662-5555</span>
                            </li>
                            <li className="flex items-center gap-3">
                                <Mail className="h-5 w-5 text-primary shrink-0" />
                                <span>jeromechristopher05@gmail.com</span>
                            </li>
                        </ul>
                    </div>
                </div>

                <div className="mt-12 pt-8 border-t border-slate-800 text-center text-xs text-slate-500">
                    <p>© {new Date().getFullYear()} Santé Connectée Haïti. Tous droits réservés.</p>
                </div>
            </div>
        </footer>
    );
}
