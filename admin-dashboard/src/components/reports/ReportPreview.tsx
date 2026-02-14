import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

interface ReportPreviewProps {
    data: any[];
    columns: { header: string; key: string }[];
    title: string;
}

export function ReportPreview({ data, columns, title }: ReportPreviewProps) {
    if (!data || data.length === 0) {
        return (
            <Card className="mt-6 border-dashed">
                <CardContent className="py-10 text-center text-slate-500">
                    Aucune donnée à afficher. Veuillez générer le rapport.
                </CardContent>
            </Card>
        );
    }

    return (
        <Card className="mt-6">
            <CardHeader>
                <CardTitle className="text-lg">Aperçu: {title}</CardTitle>
            </CardHeader>
            <CardContent>
                <div className="rounded-md border">
                    <Table>
                        <TableHeader>
                            <TableRow>
                                {columns.map((col, idx) => (
                                    <TableHead key={idx} className="font-bold text-slate-700">{col.header}</TableHead>
                                ))}
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {data.slice(0, 10).map((row, idx) => ( // Preview limited to 10 rows
                                <TableRow key={idx}>
                                    {columns.map((col, cIdx) => (
                                        <TableCell key={cIdx}>{row[col.key]}</TableCell>
                                    ))}
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                </div>
                {data.length > 10 && (
                    <p className="text-xs text-slate-500 mt-2 text-center">
                        Affichage des 10 premiers résultats sur {data.length}
                    </p>
                )}
            </CardContent>
        </Card>
    );
}
