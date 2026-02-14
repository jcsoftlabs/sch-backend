"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { DashboardSkeleton } from "@/components/skeletons";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Edit, Trash2 } from "lucide-react";
import { CenterOverview } from "@/components/dashboard/centers/CenterOverview";
import { CenterStats } from "@/components/dashboard/centers/CenterStats";
import { CenterStaff } from "@/components/dashboard/centers/CenterStaff";
import { CenterInventory } from "@/components/dashboard/centers/CenterInventory";
import { useToast } from "@/hooks/use-toast";

export default function CenterDetailsPage() {
    const params = useParams();
    const router = useRouter();
    const { toast } = useToast();
    const [center, setCenter] = useState<any | null>(null);
    const [loading, setLoading] = useState(true);

    // Mock data
    const mockStaff = [
        { id: "s1", name: "Dr. Paul", role: "Médecin Chef", phone: "+509 3700-1111", status: "ACTIVE" },
        { id: "s2", name: "Inf. Marie", role: "Infirmière", phone: "+509 3700-2222", status: "ACTIVE" },
        { id: "s3", name: "Agt. Jean", role: "Agent Santé", phone: "+509 3700-3333", status: "ACTIVE" },
    ];

    const mockInventory = [
        { id: "i1", name: "Amoxicilline", category: "Médicaments", quantity: 50, unit: "boîtes", minThreshold: 100, maxCapacity: 500 },
        { id: "i2", name: "Paracétamol", category: "Médicaments", quantity: 200, unit: "boîtes", minThreshold: 50, maxCapacity: 500 },
        { id: "i3", name: "Gants Stériles", category: "Équipement", quantity: 10, unit: "paires", minThreshold: 50, maxCapacity: 200 },
    ];

    const mockStats = {
        monthlyPatients: 450,
        totalConsultations: 120,
        availableBeds: 8,
        totalBeds: 12,
        criticalCases: 2
    };

    useEffect(() => {
        const fetchCenter = async () => {
            try {
                // Mock fetch
                await new Promise(r => setTimeout(r, 800));
                setCenter({
                    id: params.id as string,
                    name: "Centre de Santé de Delmas 32",
                    type: "Centre de Santé",
                    address: "Rue Charlemagne Péralte, Delmas 32",
                    phone: "+509 2940-0000",
                    email: "cs.delmas32@mspp.ht",
                    status: "OUVERT"
                });
            } catch (error) {
                console.error(error);
                toast({
                    title: "Erreur",
                    description: "Impossible de charger les détails du centre",
                    variant: "destructive",
                });
            } finally {
                setLoading(false);
            }
        };

        if (params.id) {
            fetchCenter();
        }
    }, [params.id, toast]);

    if (loading) return <DashboardSkeleton />;
    if (!center) return <div className="p-8">Centre non trouvé</div>;

    return (
        <div className="flex-1 space-y-6 p-8">
            {/* Header */}
            <div className="flex items-center justify-between">
                <div className="flex items-center space-x-4">
                    <Button variant="outline" size="icon" onClick={() => router.back()}>
                        <ArrowLeft className="h-4 w-4" />
                    </Button>
                    <div>
                        <h2 className="text-2xl font-bold tracking-tight text-slate-900">
                            {center.name}
                        </h2>
                        <p className="text-slate-500">
                            Vue d'ensemble et gestion du centre
                        </p>
                    </div>
                </div>
                <div className="flex space-x-2">
                    <Button variant="outline">
                        <Edit className="mr-2 h-4 w-4" />
                        Modifier
                    </Button>
                </div>
            </div>

            {/* Content Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">

                {/* Left Column: Overview */}
                <div className="lg:col-span-1 space-y-6">
                    <CenterOverview center={center} />
                </div>

                {/* Right Column: Stats & Tables */}
                <div className="lg:col-span-2 space-y-6">
                    <CenterStats stats={mockStats} />

                    <div className="space-y-4">
                        <h3 className="text-lg font-semibold text-slate-900">Personnel Assigné</h3>
                        <CenterStaff staff={mockStaff} />
                    </div>

                    <div className="space-y-4">
                        <h3 className="text-lg font-semibold text-slate-900">Inventaire Critique</h3>
                        <CenterInventory inventory={mockInventory} />
                    </div>
                </div>
            </div>
        </div>
    );
}
