import { PrismaClient } from '@prisma/client'
import * as bcrypt from 'bcrypt'

const prisma = new PrismaClient()

async function main() {
    const hashedPassword = await bcrypt.hash('password123', 10)

    // 1. Create Users (Admin, Doctors)
    const admin = await prisma.user.upsert({
        where: { email: 'admin@sch.ht' },
        update: {},
        create: {
            email: 'admin@sch.ht',
            password: hashedPassword,
            name: 'Admin SCH',
            role: 'ADMIN',
        },
    })

    // 2. Create Health Centers
    // Schema: id, name, address, phone. No type/status/lat/long.
    // Name is not unique, so we can't upsert by name directly if schema doesn't allow it.
    // Using findFirst/create pattern.

    let hueh = await prisma.healthCenter.findFirst({ where: { name: "Hôpital de l'Université d'État d'Haïti" } });
    if (!hueh) {
        hueh = await prisma.healthCenter.create({
            data: {
                name: "Hôpital de l'Université d'État d'Haïti",
                address: "Rue Monseigneur Guilloux, Port-au-Prince",
                phone: "+509 2222-1234",
            }
        })
    }

    let stFrancois = await prisma.healthCenter.findFirst({ where: { name: "Hôpital Saint-François de Sales" } });
    if (!stFrancois) {
        stFrancois = await prisma.healthCenter.create({
            data: {
                name: "Hôpital Saint-François de Sales",
                address: "Rue Chareron, Port-au-Prince",
                phone: "+509 2222-5678",
            }
        })
    }

    // 3. Create Patients
    // Schema: id, firstName, lastName, dateOfBirth, gender, address, phone, healthCenterId.
    // No medicalHistory.
    const patient1 = await prisma.patient.create({
        data: {
            firstName: 'Marie',
            lastName: 'Joseph',
            dateOfBirth: new Date('1990-05-15'),
            gender: 'FEMALE',
            phone: '+509 3000-0001',
            address: 'Delmas 33',
            healthCenterId: hueh.id
        },
    })

    const patient2 = await prisma.patient.create({
        data: {
            firstName: 'Paul',
            lastName: 'Etienne',
            dateOfBirth: new Date('1985-08-20'),
            gender: 'MALE',
            phone: '+509 3000-0002',
            address: 'Carrefour Feuilles',
            healthCenterId: stFrancois.id
        },
    })

    // 4. Create Consultations
    // Schema: id, patientId, doctorId, status, notes.
    // No centerId, type, reason, startedAt, endedAt.

    // Note: We need a doctor user first.
    let doctor = await prisma.user.findFirst({ where: { email: 'dr.pierre@sch.ht' } });
    if (!doctor) {
        doctor = await prisma.user.create({
            data: {
                email: 'dr.pierre@sch.ht',
                password: hashedPassword,
                name: 'Jean Pierre',
                role: 'DOCTOR',
            }
        })
    }

    await prisma.consultation.create({
        data: {
            patientId: patient1.id,
            doctorId: doctor.id,
            status: 'COMPLETED',
            notes: 'Glycémie stable.',
        },
    })

    await prisma.consultation.create({
        data: {
            patientId: patient2.id,
            // No doctor assigned
            status: 'PENDING',
            notes: 'Douleurs thoraciques. Patient en attente de tri.',
        },
    })

    console.log('Seed data inserted successfully.')
}

main()
    .catch((e) => {
        console.error(e)
        process.exit(1)
    })
    .finally(async () => {
        await prisma.$disconnect()
    })
