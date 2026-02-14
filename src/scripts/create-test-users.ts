import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function createTestUsers() {
    try {
        // Hash passwords
        const password = 'Test123!'; // Simple password for testing
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create DOCTOR
        const doctor = await prisma.user.upsert({
            where: { email: 'doctor.test@sch.ht' },
            update: {},
            create: {
                email: 'doctor.test@sch.ht',
                password: hashedPassword,
                name: 'Dr. Marie Dupont',
                role: 'DOCTOR',
            },
        });

        console.log('✅ DOCTOR created:');
        console.log('   Email: doctor.test@sch.ht');
        console.log('   Password: Test123!');
        console.log('   Name:', doctor.name);
        console.log('   ID:', doctor.id);
        console.log('');

        // Create AGENT
        const agent = await prisma.user.upsert({
            where: { email: 'agent.test@sch.ht' },
            update: {},
            create: {
                email: 'agent.test@sch.ht',
                password: hashedPassword,
                name: 'Agent Paul Laurent',
                role: 'AGENT',
            },
        });

        console.log('✅ AGENT created:');
        console.log('   Email: agent.test@sch.ht');
        console.log('   Password: Test123!');
        console.log('   Name:', agent.name);
        console.log('   ID:', agent.id);
        console.log('');

        console.log('🎉 Test users created successfully!');
        console.log('');
        console.log('You can now login to the mobile app with:');
        console.log('- doctor.test@sch.ht / Test123!');
        console.log('- agent.test@sch.ht / Test123!');
    } catch (error) {
        console.error('❌ Error creating test users:', error);
        throw error;
    } finally {
        await prisma.$disconnect();
    }
}

createTestUsers();
