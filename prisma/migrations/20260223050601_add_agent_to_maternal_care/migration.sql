/*
  Warnings:

  - Added the required column `agentId` to the `MaternalCare` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "MaternalCare" ADD COLUMN     "agentId" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "MaternalCare" ADD CONSTRAINT "MaternalCare_agentId_fkey" FOREIGN KEY ("agentId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
