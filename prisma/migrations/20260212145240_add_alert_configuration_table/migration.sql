-- CreateTable
CREATE TABLE "AlertConfiguration" (
    "id" TEXT NOT NULL,
    "config" TEXT NOT NULL,
    "updatedBy" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AlertConfiguration_pkey" PRIMARY KEY ("id")
);
