ALTER TABLE "rooms" ADD COLUMN "included_amenity_codes" text[] NOT NULL DEFAULT '{}';
ALTER TABLE "rooms" ADD COLUMN "addon_amenities" jsonb NOT NULL DEFAULT '[]';
