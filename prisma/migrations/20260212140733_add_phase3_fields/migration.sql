-- CreateEnum
CREATE TYPE "HealthCenterType" AS ENUM ('HOSPITAL', 'CLINIC', 'DISPENSARY', 'HEALTH_POST');

-- AlterTable
ALTER TABLE "CaseReport" ADD COLUMN     "latitude" DOUBLE PRECISION,
ADD COLUMN     "longitude" DOUBLE PRECISION,
ADD COLUMN     "zone" TEXT;

-- AlterTable
ALTER TABLE "Consultation" ADD COLUMN     "healthCenterId" TEXT;

-- AlterTable
ALTER TABLE "HealthCenter" ADD COLUMN     "type" "HealthCenterType" NOT NULL DEFAULT 'CLINIC';

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "healthCenterId" TEXT;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_healthCenterId_fkey" FOREIGN KEY ("healthCenterId") REFERENCES "HealthCenter"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Consultation" ADD CONSTRAINT "Consultation_healthCenterId_fkey" FOREIGN KEY ("healthCenterId") REFERENCES "HealthCenter"("id") ON DELETE SET NULL ON UPDATE CASCADE;
