import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function seedMedicalProtocols() {
    console.log('🌱 Seeding medical protocols...');

    const protocols = [
        {
            name: 'Protocole Paludisme',
            nameKr: 'Pwotokòl Malarya',
            keywords: ['paludisme', 'malaria', 'fièvre', 'frissons'],
            steps: JSON.stringify({
                diagnostic: 'Test de diagnostic rapide (TDR) obligatoire',
                traitement: 'Artéméther-Luméfantrine (Coartem) selon poids',
                referral: 'Paludisme grave, femme enceinte, enfant < 5 ans avec complications',
            }),
            urgencyLevel: 'URGENT',
            category: 'Maladies infectieuses',
        },
        {
            name: 'Protocole Diarrhée Aiguë',
            nameKr: 'Pwotokòl Dyare',
            keywords: ['diarrhée', 'dyare', 'selles liquides', 'déshydratation'],
            steps: JSON.stringify({
                diagnostic: 'Évaluation de la déshydratation',
                traitement: 'Réhydratation orale (SRO), Zinc pour enfants < 5 ans',
                referral: 'Déshydratation sévère, sang dans les selles, fièvre > 39°C',
            }),
            urgencyLevel: 'URGENT',
            category: 'Maladies infectieuses',
        },
        {
            name: 'Protocole IRA (Infection Respiratoire Aiguë)',
            nameKr: 'Pwotokòl Enfeksyon Respiratwa',
            keywords: ['ira', 'toux', 'pneumonie', 'difficulté respiratoire'],
            steps: JSON.stringify({
                diagnostic: 'Évaluation fréquence respiratoire et tirage',
                traitement: 'Amoxicilline 50mg/kg/jour si pneumonie',
                referral: 'Tirage sévère, cyanose, saturation O2 < 90%',
            }),
            urgencyLevel: 'CRITICAL',
            category: 'Urgences respiratoires',
        },
        {
            name: 'Protocole Malnutrition Aiguë Sévère',
            nameKr: 'Pwotokòl Malnoutrisyon',
            keywords: ['malnutrition', 'mas', 'œdèmes', 'périmètre brachial'],
            steps: JSON.stringify({
                diagnostic: 'Périmètre brachial < 115mm ou œdèmes bilatéraux',
                traitement: 'ATPE (Aliment Thérapeutique Prêt à l\'Emploi)',
                referral: 'Complications médicales, refus de manger',
            }),
            urgencyLevel: 'CRITICAL',
            category: 'Nutrition',
        },
        {
            name: 'Protocole Tuberculose',
            nameKr: 'Pwotokòl Tibilkoz',
            keywords: ['tuberculose', 'tb', 'toux persistante', 'crachats sanglants'],
            steps: JSON.stringify({
                diagnostic: 'Toux > 2 semaines, GeneXpert',
                traitement: 'Phase intensive (2 mois) RHZE, Phase continuation (4 mois) RH',
                referral: 'Tout cas suspect pour confirmation diagnostique',
            }),
            urgencyLevel: 'URGENT',
            category: 'Maladies infectieuses',
        },
    ];

    for (const protocol of protocols) {
        await prisma.medicalProtocol.upsert({
            where: { name: protocol.name },
            update: protocol,
            create: protocol,
        });
    }

    console.log(`✅ ${protocols.length} protocoles médicaux créés/mis à jour`);
}

async function main() {
    try {
        await seedMedicalProtocols();
        console.log('✅ Seed terminé avec succès');
    } catch (error) {
        console.error('❌ Erreur lors du seed:', error);
        throw error;
    } finally {
        await prisma.$disconnect();
    }
}

main();
