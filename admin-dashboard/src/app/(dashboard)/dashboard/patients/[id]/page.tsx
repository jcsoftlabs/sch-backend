"use client";

import { useParams } from "next/navigation";
import { useState, useEffect } from "react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { PatientService, Patient } from "@/services/patient.service";
import { PrescriptionList } from "@/components/medical-records/PrescriptionList";
import { DiagnosisList } from "@/components/medical-records/DiagnosisList";
import { LabResultsList } from "@/components/medical-records/LabResultsList";
import { EmergencyContactList } from "@/components/medical-records/EmergencyContactList";
import { User, FileText, FlaskConical, Phone, Pill } from "lucide-react";

export default function PatientDetailPage() {
    const params = useParams();
    const patientId = params.id as string;
    const [patient, setPatient] = useState<Patient | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadPatient();
    }, [patientId]);

    const loadPatient = async () => {
        try {
            setLoading(true);
            const data = await PatientService.getById(patientId);
            setPatient(data);
        } catch (error) {
            console.error("Error loading patient:", error);
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

    if (!patient) {
        return (
            <div className="p-8">
                <Card>
                    <CardHeader>
                        <CardTitle>Patient non trouvé</CardTitle>
                        <CardDescription>
                            Le patient demandé n'existe pas ou a été supprimé.
                        </CardDescription>
                    </CardHeader>
                </Card>
            </div>
        );
    }

    const fullName = `${patient.firstName} ${patient.lastName}`;
    const age = patient.dateOfBirth
        ? Math.floor(
            (new Date().getTime() - new Date(patient.dateOfBirth).getTime()) /
            (365.25 * 24 * 60 * 60 * 1000)
        )
        : null;

    return (
        <div className="p-8 space-y-6">
            {/* Patient Header */}
            <div>
                <h1 className="text-3xl font-bold tracking-tight">{fullName}</h1>
                <p className="text-slate-500">
                    {age ? `${age} ans` : "Âge inconnu"} • {patient.gender === "MALE" ? "Homme" : "Femme"}
                    {patient.phone && ` • ${patient.phone}`}
                </p>
            </div>

            {/* Tabs for Medical Records */}
            <Tabs defaultValue="info" className="space-y-4">
                <TabsList className="grid w-full grid-cols-5">
                    <TabsTrigger value="info" className="flex items-center gap-2">
                        <User className="h-4 w-4" />
                        Informations
                    </TabsTrigger>
                    <TabsTrigger value="prescriptions" className="flex items-center gap-2">
                        <Pill className="h-4 w-4" />
                        Prescriptions
                    </TabsTrigger>
                    <TabsTrigger value="diagnoses" className="flex items-center gap-2">
                        <FileText className="h-4 w-4" />
                        Diagnostics
                    </TabsTrigger>
                    <TabsTrigger value="lab-results" className="flex items-center gap-2">
                        <FlaskConical className="h-4 w-4" />
                        Résultats Labo
                    </TabsTrigger>
                    <TabsTrigger value="emergency" className="flex items-center gap-2">
                        <Phone className="h-4 w-4" />
                        Contacts Urgence
                    </TabsTrigger>
                </TabsList>

                <TabsContent value="info">
                    <Card>
                        <CardHeader>
                            <CardTitle>Informations Générales</CardTitle>
                            <CardDescription>
                                Détails du patient et informations de contact
                            </CardDescription>
                        </CardHeader>
                        <CardContent className="space-y-4">
                            <div className="grid grid-cols-2 gap-4">
                                <div>
                                    <p className="text-sm font-medium text-slate-500">
                                        Date de naissance
                                    </p>
                                    <p className="text-base text-slate-900 font-medium">
                                        {patient.dateOfBirth
                                            ? new Date(patient.dateOfBirth).toLocaleDateString("fr-FR")
                                            : "Non renseignée"}
                                    </p>
                                </div>
                                <div>
                                    <p className="text-sm font-medium text-slate-500">Genre</p>
                                    <p className="text-base text-slate-900 font-medium">
                                        {patient.gender === "MALE" ? "Homme" : "Femme"}
                                    </p>
                                </div>
                                <div>
                                    <p className="text-sm font-medium text-slate-500">
                                        Téléphone
                                    </p>
                                    <p className="text-base text-slate-900 font-medium">{patient.phone || "Non renseigné"}</p>
                                </div>
                                <div>
                                    <p className="text-sm font-medium text-slate-500">
                                        Adresse
                                    </p>
                                    <p className="text-base text-slate-900 font-medium">{patient.address || "Non renseignée"}</p>
                                </div>
                            </div>
                        </CardContent>
                    </Card>
                </TabsContent>

                <TabsContent value="prescriptions">
                    <PrescriptionList patientId={patientId} />
                </TabsContent>

                <TabsContent value="diagnoses">
                    <DiagnosisList patientId={patientId} />
                </TabsContent>

                <TabsContent value="lab-results">
                    <LabResultsList patientId={patientId} />
                </TabsContent>

                <TabsContent value="emergency">
                    <EmergencyContactList patientId={patientId} />
                </TabsContent>
            </Tabs>
        </div>
    );
}
