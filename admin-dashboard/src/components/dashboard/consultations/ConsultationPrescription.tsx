import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Pill, FileText } from "lucide-react";
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";

export function ConsultationPrescription({ prescription }: { prescription: any[] }) {
    if (!prescription || prescription.length === 0) {
        return (
            <Card>
                <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                        <Pill className="h-5 w-5 text-green-600" />
                        Ordonnance
                    </CardTitle>
                </CardHeader>
                <CardContent>
                    <div className="text-center py-6 text-slate-500 border-2 border-dashed rounded-lg">
                        Aucune prescription délivrée.
                    </div>
                </CardContent>
            </Card>
        );
    }

    return (
        <Card>
            <CardHeader>
                <CardTitle className="flex items-center gap-2">
                    <Pill className="h-5 w-5 text-green-600" />
                    Ordonnance Médicale
                </CardTitle>
            </CardHeader>
            <CardContent>
                <div className="rounded-md border">
                    <Table>
                        <TableHeader>
                            <TableRow className="bg-slate-50">
                                <TableHead className="font-bold text-slate-700">Médicament</TableHead>
                                <TableHead className="font-bold text-slate-700">Dosage</TableHead>
                                <TableHead className="font-bold text-slate-700">Fréquence</TableHead>
                                <TableHead className="font-bold text-slate-700">Durée</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {prescription.map((item, idx) => (
                                <TableRow key={idx}>
                                    <TableCell className="font-medium">{item.medication}</TableCell>
                                    <TableCell>{item.dosage}</TableCell>
                                    <TableCell>{item.frequency}</TableCell>
                                    <TableCell>{item.duration}</TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                </div>
                <div className="mt-4 flex justify-end">
                    <button className="text-sm text-blue-600 font-medium flex items-center hover:underline">
                        <FileText className="mr-1 h-3 w-3" />
                        Imprimer l'ordonnance
                    </button>
                </div>
            </CardContent>
        </Card>
    );
}
