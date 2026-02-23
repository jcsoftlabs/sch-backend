import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const patients = await prisma.patient.findMany({
    where: {
      OR: [
        { firstName: { contains: 'Jean' } },
        { lastName: { contains: 'Pierre' } }
      ]
    }
  });
  console.log(JSON.stringify(patients, null, 2));
}

main().catch(e => {
  console.error(e);
  process.exit(1);
}).finally(async () => {
  await prisma.$disconnect();
});
