CREATE TABLE "amenities" (
	"code" "amenity" PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "properties" ALTER COLUMN "amenities" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "amenities" ALTER COLUMN "code" SET DATA TYPE text;--> statement-breakpoint
DROP TYPE "public"."amenity";--> statement-breakpoint
CREATE TYPE "public"."amenity" AS ENUM('WIFI', 'BED', 'FRIDGE', 'BALCONY', 'WATER_HEATER', 'AIR_CONDITIONER', 'PRIVATE_BATHROOM');--> statement-breakpoint
DO $$
BEGIN
	IF EXISTS (
		SELECT 1
		FROM "properties" p
		CROSS JOIN LATERAL unnest(p."amenities"::text[]) AS a(value)
		WHERE a.value NOT IN ('WIFI', 'BED', 'FRIDGE', 'BALCONY', 'WATER_HEATER', 'AIR_CONDITIONER', 'PRIVATE_BATHROOM')
	) THEN
		RAISE EXCEPTION 'properties.amenities contains legacy/unknown values. Please map old values before running this migration.';
	END IF;
END $$;--> statement-breakpoint
ALTER TABLE "properties" ALTER COLUMN "amenities" SET DATA TYPE "public"."amenity"[] USING "amenities"::"public"."amenity"[];--> statement-breakpoint
ALTER TABLE "amenities" ALTER COLUMN "code" SET DATA TYPE "public"."amenity" USING "code"::"public"."amenity";
--> statement-breakpoint
INSERT INTO "amenities" ("code", "name") VALUES
('WIFI', 'Wifi'),
('BED', 'Bed'),
('FRIDGE', 'Fridge'),
('BALCONY', 'Balcony'),
('WATER_HEATER', 'Water Heater'),
('AIR_CONDITIONER', 'Air Conditioner'),
('PRIVATE_BATHROOM', 'Private Bathroom')
ON CONFLICT ("code") DO UPDATE SET
"name" = EXCLUDED."name",
"updated_at" = now();