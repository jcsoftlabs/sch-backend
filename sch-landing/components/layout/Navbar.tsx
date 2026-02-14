"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import { Activity, Menu, X, Globe, Heart } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

const navigation = [
    { name: "Accueil", href: "/" },
    { name: "Notre Mission", href: "/#mission" },
    { name: "Impact", href: "/#impact" },
    { name: "Partenaires", href: "/#partners" },
    { name: "Contact", href: "/#contact" },
];

export function Navbar() {
    const [isScrolled, setIsScrolled] = useState(false);
    const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
    const pathname = usePathname();

    useEffect(() => {
        const handleScroll = () => {
            setIsScrolled(window.scrollY > 10);
        };
        window.addEventListener("scroll", handleScroll);
        return () => window.removeEventListener("scroll", handleScroll);
    }, []);

    return (
        <header
            className={cn(
                "fixed top-0 left-0 right-0 z-50 transition-all duration-300",
                isScrolled
                    ? "bg-white/90 backdrop-blur-md shadow-sm py-2"
                    : "bg-transparent py-4"
            )}
        >
            <div className="container mx-auto px-4 md:px-6">
                <div className="flex items-center justify-between">
                    {/* Logo */}
                    <Link href="/" className="flex items-center gap-2 group z-50">
                        <div className="h-10 w-10 rounded-lg bg-primary flex items-center justify-center text-white group-hover:bg-blue-700 transition-colors">
                            <Activity className="h-6 w-6" />
                        </div>
                        <div className="flex flex-col">
                            <span className={cn(
                                "font-bold text-lg leading-none",
                                isScrolled ? "text-slate-900" : "text-white"
                            )}>
                                Santé Connectée
                            </span>
                            <span className={cn(
                                "text-xs uppercase tracking-wider font-medium",
                                isScrolled ? "text-slate-500" : "text-slate-200"
                            )}>
                                Haïti
                            </span>
                        </div>
                    </Link>

                    {/* Desktop Navigation */}
                    <nav className="hidden md:flex items-center gap-8">
                        {navigation.map((item) => (
                            <Link
                                key={item.name}
                                href={item.href}
                                className={cn(
                                    "text-sm font-medium transition-colors hover:text-accent",
                                    isScrolled ? "text-slate-600" : "text-slate-100"
                                )}
                            >
                                {item.name}
                            </Link>
                        ))}
                    </nav>

                    {/* Actions */}
                    <div className="hidden md:flex items-center gap-4">
                        <Button
                            variant="ghost"
                            size="sm"
                            className={cn(
                                "gap-2",
                                isScrolled ? "text-slate-600" : "text-white hover:text-slate-900"
                            )}
                        >
                            <Globe className="h-4 w-4" />
                            <span>FR</span>
                        </Button>
                        <Button size="sm" className="gap-2 bg-accent hover:bg-amber-600 text-white border-none">
                            <Heart className="h-4 w-4 fill-current" />
                            Faire un Don
                        </Button>
                    </div>

                    {/* Mobile Menu Button */}
                    <button
                        className="md:hidden z-50 p-2 text-slate-800"
                        onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
                    >
                        {mobileMenuOpen ? (
                            <X className={cn("h-6 w-6", isScrolled ? "text-slate-900" : "text-white")} />
                        ) : (
                            <Menu className={cn("h-6 w-6", isScrolled ? "text-slate-900" : "text-white")} />
                        )}
                    </button>
                </div>
            </div>

            {/* Mobile Menu Overlay */}
            <AnimatePresence>
                {mobileMenuOpen && (
                    <motion.div
                        initial={{ opacity: 0, y: -20 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -20 }}
                        className="absolute top-0 left-0 right-0 bg-white shadow-xl p-4 pt-20 md:hidden"
                    >
                        <nav className="flex flex-col gap-4">
                            {navigation.map((item) => (
                                <Link
                                    key={item.name}
                                    href={item.href}
                                    className="text-lg font-medium text-slate-900 py-2 border-b border-slate-100"
                                    onClick={() => setMobileMenuOpen(false)}
                                >
                                    {item.name}
                                </Link>
                            ))}
                            <div className="flex flex-col gap-3 mt-4">
                                <Button className="w-full justify-start gap-2" variant="outline">
                                    <Globe className="h-4 w-4" />
                                    Changer Langue (FR)
                                </Button>
                                <Button className="w-full gap-2 bg-accent hover:bg-amber-600">
                                    <Heart className="h-4 w-4 fill-current" />
                                    Faire un Don
                                </Button>
                            </div>
                        </nav>
                    </motion.div>
                )}
            </AnimatePresence>
        </header>
    );
}
