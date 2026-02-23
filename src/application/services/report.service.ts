import PDFDocument from 'pdfkit';
import { stringify } from 'csv-stringify/sync';

interface ReportSummary {
    totalConsultations: number;
    totalCaseReports: number;
    totalPatients: number;
    period: { startDate: string; endDate: string };
    zone: string;
}

export class ReportService {
    /**
     * Generate a PDF report using pdfkit
     * Returns a valid PDF Buffer
     */
    async generatePdfReport(data: any, summary: ReportSummary): Promise<Buffer> {
        return new Promise((resolve, reject) => {
            try {
                const doc = new PDFDocument({ margin: 50, size: 'A4' });
                const buffers: Buffer[] = [];

                doc.on('data', buffers.push.bind(buffers));
                doc.on('end', () => {
                    const pdfData = Buffer.concat(buffers);
                    resolve(pdfData);
                });
                doc.on('error', reject);

                // --- Header ---
                doc.fontSize(20).font('Helvetica-Bold')
                    .text('SCH - Rapport de Santé Communautaire', { align: 'center' });

                doc.moveDown();
                doc.fontSize(12).font('Helvetica')
                    .text(`Période : ${new Date(summary.period.startDate).toLocaleDateString()} - ${new Date(summary.period.endDate).toLocaleDateString()}`);
                doc.text(`Zone : ${summary.zone}`);
                doc.text(`Généré le: ${new Date().toLocaleString()}`);

                doc.moveDown(2);

                // --- Résumé Exécutif ---
                doc.fontSize(16).font('Helvetica-Bold').text('Résumé Exécutif');
                doc.moveDown(0.5);

                doc.rect(50, doc.y, 495, 60).stroke();
                const startY = doc.y + 10;

                doc.fontSize(12).font('Helvetica')
                    .text(`Total Patients : ${summary.totalPatients}`, 60, startY);
                doc.text(`Total Cas Triage IA : ${summary.totalCaseReports}`, 220, startY);
                doc.text(`Total Consultations : ${summary.totalConsultations}`, 380, startY);

                doc.y = startY + 50; // reset Y after box
                doc.moveDown(2);

                // --- Section: Triage IA ---
                doc.fontSize(16).font('Helvetica-Bold').text('Aperçu des Cas Récents (Triage)');
                doc.moveDown(0.5);

                if (data.caseReports && data.caseReports.length > 0) {
                    const topCases = data.caseReports.slice(0, 15); // Max 15 for the demo page
                    topCases.forEach((cr: any, index: number) => {
                        doc.fontSize(10).font('Helvetica-Bold')
                            .text(`${index + 1}. Patient: ${cr.patient?.firstName} ${cr.patient?.lastName}`);
                        doc.font('Helvetica').text(`    Symptômes: ${cr.symptoms}`);

                        let urgencyColor = 'black';
                        if (cr.urgency === 'CRITICAL') urgencyColor = 'red';
                        else if (cr.urgency === 'URGENT') urgencyColor = 'orange';

                        doc.fillColor(urgencyColor).text(`    Urgence: ${cr.urgency}`).fillColor('black');
                        doc.moveDown(0.5);
                    });
                } else {
                    doc.fontSize(12).font('Helvetica-Oblique').text('Aucun cas de triage dans cette période.');
                }

                doc.moveDown(2);

                // --- Footer ---
                const totalPages = doc.bufferedPageRange().count;
                for (let i = 0; i < totalPages; i++) {
                    doc.switchToPage(i);
                    // Add page numbers
                    doc.fontSize(10).text(
                        `Page ${i + 1} de ${totalPages}`,
                        50,
                        doc.page.height - 50,
                        { align: 'center', width: doc.page.width - 100 }
                    );
                }

                // Finalize PDF file
                doc.end();

            } catch (err) {
                reject(err);
            }
        });
    }

    /**
     * Generate a CSV string from raw data array
     */
    generateCsvReport(data: any[], entity: string): string {
        if (!data || data.length === 0) {
            return stringify([['Aucune donnée disponible']]);
        }

        let columns: Record<string, string> = {};

        // Define columns based on entity
        if (entity === 'patient') {
            columns = {
                id: 'ID',
                firstName: 'Prénom',
                lastName: 'Nom',
                gender: 'Sexe',
                dateOfBirth: 'Date de Naissance',
                zone: 'Zone (Ménage)',
                createdAt: 'Date de Création'
            };

            // Map data
            const rows = data.map(p => ({
                id: p.id,
                firstName: p.firstName,
                lastName: p.lastName,
                gender: p.gender,
                dateOfBirth: p.dateOfBirth?.toISOString().split('T')[0],
                zone: p.household?.zone || 'N/A',
                createdAt: p.createdAt?.toISOString()
            }));

            return stringify(rows, { header: true, columns });
        }
        else if (entity === 'caseReport') {
            columns = {
                id: 'ID Triage',
                patientId: 'ID Patient',
                patientName: 'Nom Patient',
                symptoms: 'Symptômes',
                clinicalAssessment: 'Évaluation Clinique',
                urgency: 'Niveau Urgence',
                status: 'Statut',
                agentName: 'Agent',
                zone: 'Zone',
                createdAt: 'Date du Triage'
            };

            const rows = data.map(cr => ({
                id: cr.id,
                patientId: cr.patientId,
                patientName: `${cr.patient?.firstName} ${cr.patient?.lastName}`,
                symptoms: cr.symptoms,
                clinicalAssessment: cr.clinicalAssessment,
                urgency: cr.urgency,
                status: cr.status,
                agentName: cr.agent?.name,
                zone: cr.agent?.zone || cr.patient?.household?.zone || 'N/A',
                createdAt: cr.createdAt?.toISOString()
            }));

            return stringify(rows, { header: true, columns });
        }
        else if (entity === 'consultation') {
            columns = {
                id: 'ID Consultation',
                patientName: 'Nom Patient',
                doctorName: 'Médecin',
                diagnosis: 'Diagnostic',
                prescription: 'Prescription',
                status: 'Statut',
                zone: 'Zone',
                createdAt: 'Date'
            };

            const rows = data.map(c => ({
                id: c.id,
                patientName: `${c.patient?.firstName} ${c.patient?.lastName}`,
                doctorName: c.doctor?.name,
                diagnosis: c.diagnosis,
                prescription: c.prescription,
                status: c.status,
                zone: c.doctor?.zone || c.patient?.household?.zone || 'N/A',
                createdAt: c.createdAt?.toISOString()
            }));

            return stringify(rows, { header: true, columns });
        }

        // Fallback for unknown entities
        return stringify(data, { header: true });
    }
}
