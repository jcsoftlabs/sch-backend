/*
  Warnings:

  - Added the required column `householdHeadName` to the `Household` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Household" ADD COLUMN     "commune" TEXT,
ADD COLUMN     "gpsAccuracy" DOUBLE PRECISION,
ADD COLUMN     "hasElectricity" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "householdHeadName" TEXT NOT NULL,
ADD COLUMN     "housingType" TEXT,
ADD COLUMN     "memberCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "neighborhood" TEXT,
ADD COLUMN     "numberOfRooms" INTEGER,
ADD COLUMN     "phone" TEXT,
ADD COLUMN     "sanitationType" TEXT,
ADD COLUMN     "waterSource" TEXT;
