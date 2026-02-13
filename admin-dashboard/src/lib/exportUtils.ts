import jsPDF from "jspdf";
import autoTable from "jspdf-autotable";
import Papa from "papaparse";

export const exportToCSV = (data: any[], filename: string) => {
    const csv = Papa.unparse(data);
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    const link = document.createElement("a");
    if (link.download !== undefined) {
        const url = URL.createObjectURL(blob);
        link.setAttribute("href", url);
        link.setAttribute("download", `${filename}.csv`);
        link.style.visibility = "hidden";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
};

export const exportToPDF = (
    title: string,
    columns: string[],
    data: any[][],
    filename: string
) => {
    const doc = new jsPDF();

    // Add MSPP branding header
    doc.setFillColor(0, 102, 204); // MSPP Blue
    doc.rect(0, 0, 210, 20, "F");
    doc.setTextColor(255, 255, 255);
    doc.setFontSize(16);
    doc.text("MSPP - Système de Santé Communautaire", 14, 13);

    // Title
    doc.setTextColor(0, 0, 0);
    doc.setFontSize(14);
    doc.text(title, 14, 30);

    // Date
    doc.setFontSize(10);
    doc.setTextColor(100, 100, 100);
    doc.text(`Généré le: ${new Date().toLocaleDateString("fr-FR")}`, 14, 36);

    // Table
    autoTable(doc, {
        head: [columns],
        body: data,
        startY: 45,
        styles: {
            fontSize: 9,
            cellPadding: 3,
        },
        headStyles: {
            fillColor: [0, 102, 204],
            textColor: 255,
            fontStyle: "bold",
        },
        alternateRowStyles: {
            fillColor: [245, 247, 250],
        },
    });

    doc.save(`${filename}.pdf`);
};
