-- CreateEnum
CREATE TYPE "SMSDirection" AS ENUM ('INBOUND', 'OUTBOUND');

-- CreateEnum
CREATE TYPE "SMSStatus" AS ENUM ('PENDING', 'SENT', 'DELIVERED', 'FAILED');

-- CreateTable
CREATE TABLE "SMSMessage" (
    "id" TEXT NOT NULL,
    "messageId" TEXT,
    "direction" "SMSDirection" NOT NULL,
    "from" TEXT NOT NULL,
    "to" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "status" "SMSStatus" NOT NULL DEFAULT 'PENDING',
    "agentId" TEXT,
    "patientId" TEXT,
    "caseReportId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deliveredAt" TIMESTAMP(3),

    CONSTRAINT "SMSMessage_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "SMSMessage_agentId_idx" ON "SMSMessage"("agentId");

-- CreateIndex
CREATE INDEX "SMSMessage_patientId_idx" ON "SMSMessage"("patientId");

-- CreateIndex
CREATE INDEX "SMSMessage_caseReportId_idx" ON "SMSMessage"("caseReportId");

-- CreateIndex
CREATE INDEX "SMSMessage_createdAt_idx" ON "SMSMessage"("createdAt");

-- AddForeignKey
ALTER TABLE "SMSMessage" ADD CONSTRAINT "SMSMessage_agentId_fkey" FOREIGN KEY ("agentId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SMSMessage" ADD CONSTRAINT "SMSMessage_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SMSMessage" ADD CONSTRAINT "SMSMessage_caseReportId_fkey" FOREIGN KEY ("caseReportId") REFERENCES "CaseReport"("id") ON DELETE SET NULL ON UPDATE CASCADE;
