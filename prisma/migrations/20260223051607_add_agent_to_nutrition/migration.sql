/*
  Warnings:

  - Added the required column `agentId` to the `NutritionRecord` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "NutritionRecord" ADD COLUMN     "agentId" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "NutritionRecord" ADD CONSTRAINT "NutritionRecord_agentId_fkey" FOREIGN KEY ("agentId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
