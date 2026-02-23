"use client";

import { useParams, useRouter } from "next/navigation";
import { useState, useEffect } from "react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { HouseholdService } from "@/services/household.service";
import { Home, Users, MapPin, Map as MapIcon, Info, Phone } from "lucide-react";
import { columns, Patient } from "@/components/dashboard/PatientTable";
import { DataTable } from "@/components/ui/data-table";
import dynamic from "next/dynamic";

const HouseholdMap = dynamic(() => import('@/components/dashboard/map/HouseholdMap'), {
    ssr: false,
    loading: () => <div className="h-full w-full bg-slate-100 animate-pulse rounded-lg flex items-center justify-center text-slate-400">Chargement de la carte...</div>
});

// Type based on backend schema
type HouseholdData = {
    id: string;
    householdHeadName: string;
    address: string;
    neighborhood?: string;
    commune?: string;
    phone?: string;
    latitude: number;
    longitude: number;
    gpsAccuracy?: number;
    housingType?: string;
    numberOfRooms?: number;
    waterSource?: string;
    sanitationType?: string;
    hasElectricity: boolean;
    createdAt: string;
    members: Patient[];
};

export default function HouseholdDetailPage() {
    const params = useParams();
    const router = useRouter();
    const householdId = params.id as string;
    const [household, setHousehold] = useState<HouseholdData | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadHousehold();
    }, [householdId]);

    const loadHousehold = async () => {
        try {
            setLoading(true);
            const data = await HouseholdService.getById(householdId);
            setHousehold(data);
        } catch (error) {
            console.error("Error loading household:", error);
        } finally {
            setLoading(false);
        }
    };

    if (loading) {
        return (
            <div className="p-8 space-y-6">
                <Skeleton className="h-12 w-64" />
                <Skeleton className="h-96 w-full" />
            </div>
        );
    }

    if (!household) {
        return (
            <div className="p-8">
                <Card>
                    <CardHeader>
                        <CardTitle>Ménage non trouvé</CardTitle>
                        <CardDescription>
                            Le ménage demandé n'existe pas ou a été supprimé.
                        </CardDescription>
                    </CardHeader>
                </Card>
            </div>
        );
    }

    const memberCount = household.members?.length || 0;

    return (
        <div className="p-8 space-y-6">
            {/* Header */}
            <div>
                <h1 className="text-3xl font-bold tracking-tight">Ménage de {household.householdHeadName}</h1>
                <p className="text-slate-500 flex items-center gap-2 mt-1">
                    <MapPin className="h-4 w-4" />
                    {household.address}, {household.commune || 'Commune non spécifiée'}
                    <span className="mx-2">•</span>
                    <Users className="h-4 w-4" />
                    {memberCount} membre{memberCount > 1 ? 's' : ''}
                </p>
            </div>

            <Tabs defaultValue="info" className="space-y-4">
                <TabsList className="grid w-full max-w-md grid-cols-2">
                    <TabsTrigger value="info" className="flex items-center gap-2">
                        <Info className="h-4 w-4" />
                        Détails & Logement
                    </TabsTrigger>
                    <TabsTrigger value="members" className="flex items-center gap-2">
                        <Users className="h-4 w-4" />
                        Membres du Ménage
                    </TabsTrigger>
                </TabsList>

                <TabsContent value="info" className="space-y-4">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        {/* Demographics Card */}
                        <Card>
                            <CardHeader>
                                <CardTitle className="flex items-center gap-2">
                                    <Home className="h-5 w-5 text-blue-500" />
                                    Informations Générales
                                </CardTitle>
                            </CardHeader>
                            <CardContent className="space-y-4">
                                <div>
                                    <p className="text-sm font-medium text-slate-500">Chef de Famille</p>
                                    <p className="text-base text-slate-900 font-medium">{household.householdHeadName}</p>
                                </div>
                                <div>
                                    <p className="text-sm font-medium text-slate-500">Téléphone de contact</p>
                                    <p className="text-base text-slate-900 font-medium">{household.phone || "Non renseigné"}</p>
                                </div>
                                <div>
                                    <p className="text-sm font-medium text-slate-500">Adresse Complète</p>
                                    <p className="text-base text-slate-900 font-medium">
                                        {household.address}
                                        {household.neighborhood && <><br />Quartier: {household.neighborhood}</>}
                                        {household.commune && <><br />Commune: {household.commune}</>}
                                    </p>
                                </div>
                                <div>
                                    <p className="text-sm font-medium text-slate-500">Coordonnées GPS</p>
                                    <p className="text-base text-slate-900 font-medium font-mono text-sm mt-1">
                                        Lat: {household.latitude.toFixed(6)} <br />
                                        Lng: {household.longitude.toFixed(6)}
                                    </p>
                                </div>
                            </CardContent>
                        </Card>

                        {/* Housing & Sanitation Card */}
                        <Card>
                            <CardHeader>
                                <CardTitle className="flex items-center gap-2">
                                    <Info className="h-5 w-5 text-emerald-500" />
                                    Conditions de Logement
                                </CardTitle>
                            </CardHeader>
                            <CardContent className="space-y-4">
                                <div className="grid grid-cols-2 gap-4">
                                    <div>
                                        <p className="text-sm font-medium text-slate-500">Type de logement</p>
                                        <p className="text-base text-slate-900 font-medium capitalize">{household.housingType || "Non spécifié"}</p>
                                    </div>
                                    <div>
                                        <p className="text-sm font-medium text-slate-500">Nombre de pièces</p>
                                        <p className="text-base text-slate-900 font-medium">{household.numberOfRooms !== null ? household.numberOfRooms : "Non spécifié"}</p>
                                    </div>
                                    <div>
                                        <p className="text-sm font-medium text-slate-500">Source d'eau</p>
                                        <p className="text-base text-slate-900 font-medium capitalize">{household.waterSource || "Non spécifiée"}</p>
                                    </div>
                                    <div>
                                        <p className="text-sm font-medium text-slate-500">Sanitaires</p>
                                        <p className="text-base text-slate-900 font-medium capitalize">{household.sanitationType || "Non spécifiés"}</p>
                                    </div>
                                    <div className="col-span-2">
                                        <p className="text-sm font-medium text-slate-500">Électricité</p>
                                        <div className={`mt-1 inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${household.hasElectricity ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>
                                            {household.hasElectricity ? 'Oui, accès à l\'électricité' : 'Non, sans électricité'}
                                        </div>
                                    </div>
                                </div>
                            </CardContent>
                        </Card>

                        {/* Map Card */}
                        <Card className="md:col-span-2">
                            <CardHeader>
                                <CardTitle className="flex items-center gap-2">
                                    <MapIcon className="h-5 w-5 text-purple-500" />
                                    Localisation GPS
                                </CardTitle>
                                <CardDescription>
                                    Position exacte où le ménage a été enregistré par l'agent.
                                </CardDescription>
                            </CardHeader>
                            <CardContent>
                                <div className="h-[400px] w-full rounded-lg overflow-hidden border border-slate-200">
                                    <HouseholdMap
                                        location={{
                                            lat: household.latitude,
                                            lng: household.longitude,
                                            name: `Ménage: ${household.householdHeadName}`,
                                            address: household.address
                                        }}
                                    />
                                </div>
                            </CardContent>
                        </Card>
                    </div>
                </TabsContent>

                <TabsContent value="members">
                    <Card>
                        <CardHeader>
                            <CardTitle>Membres enregistrés</CardTitle>
                            <CardDescription>
                                Liste des patients / membres assignés à ce ménage.
                            </CardDescription>
                        </CardHeader>
                        <CardContent>
                            <DataTable
                                columns={columns}
                                data={household.members || []}
                                searchKey="lastName"
                                onRowClick={(patient) => router.push(`/dashboard/patients/${patient.id}`)}
                            />
                        </CardContent>
                    </Card>
                </TabsContent>
            </Tabs>
        </div>
    );
}
