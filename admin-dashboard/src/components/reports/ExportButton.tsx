"use client";

import { Button } from "@/components/ui/button";
import { Download, FileJson, FileSpreadsheet } from "lucide-react";
import jsPDF from "jspdf";
import autoTable from "jspdf-autotable";
import { format } from "date-fns";

interface ExportButtonProps {
    data: any[];
    columns: { header: string; key: string }[];
    title: string;
    filename?: string;
}

export function ExportButton({ data, columns, title, filename = "rapport" }: ExportButtonProps) {
    const handleExportPDF = () => {
        const doc = new jsPDF();

        // Header
        doc.setFontSize(18);
        doc.text("Ministère de la Santé Publique et de la Population", 14, 20);
        doc.setFontSize(14);
        doc.text(title, 14, 30);
        doc.setFontSize(10);
        doc.text(`Généré le: ${format(new Date(), "dd/MM/yyyy HH:mm")}`, 14, 38);

        // Table
        const tableColumn = columns.map(col => col.header);
        const tableRows = data.map(item => columns.map(col => {
            const val = item[col.key];
            return val !== null && val !== undefined ? String(val) : "";
        }));

        autoTable(doc, {
            head: [tableColumn],
            body: tableRows,
            startY: 45,
            theme: 'grid',
            headStyles: { fillColor: [22, 163, 74] }, // Green MSPP
        });

        doc.save(`${filename}.pdf`);
    };

    const handleExportCSV = () => {
        const csvRows = [];
        // Header
        csvRows.push(columns.map(col => col.header).join(","));

        // Rows
        for (const row of data) {
            const values = columns.map(col => {
                const val = row[col.key];
                const stringVal = val !== null && val !== undefined ? String(val) : "";
                const escaped = stringVal.replace(/"/g, '""');
                return `"${escaped}"`;
            });
            csvRows.push(values.join(","));
        }

        const csvString = csvRows.join("\n");
        const blob = new Blob([csvString], { type: "text/csv" });
        const url = URL.createObjectURL(blob);
        const link = document.createElement("a");
        link.href = url;
        link.download = `${filename}.csv`;
        link.click();
    };

    return (
        <div className="flex gap-2">
            <Button variant="outline" size="sm" onClick={handleExportCSV}>
                <FileSpreadsheet className="mr-2 h-4 w-4" />
                CSV
            </Button>
            <Button variant="default" size="sm" onClick={handleExportPDF} className="bg-green-700 hover:bg-green-800">
                <FileJson className="mr-2 h-4 w-4" />
                PDF
            </Button>
        </div>
    );
}
