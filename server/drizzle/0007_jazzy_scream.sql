CREATE TYPE "public"."room_status" AS ENUM('AVAILABLE', 'OCCUPIED', 'MAINTENANCE');--> statement-breakpoint
CREATE TABLE "rooms" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"title" text NOT NULL,
	"status" "room_status" DEFAULT 'AVAILABLE' NOT NULL,
	"area_sqm" numeric(10, 2) NOT NULL,
	"monthly_rent" numeric(10, 2) NOT NULL,
	"deposit_amount" numeric(10, 2) NOT NULL,
	"electricity_rate_per_kwh" numeric(10, 2) NOT NULL,
	"water_rate_per_m3" numeric(10, 2) NOT NULL,
	"has_furniture" boolean NOT NULL,
	"description" text,
	"created_at" timestamp with time zone DEFAULT now(),
	"updated_at" timestamp with time zone DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "room_amenities" (
	"room_id" uuid NOT NULL,
	"amenity_code" "amenity" NOT NULL,
	"is_tenant_addon" boolean NOT NULL,
	"monthly_supplement_vnd" integer DEFAULT 0,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "room_amenities_room_id_amenity_code_pk" PRIMARY KEY("room_id","amenity_code"),
	CONSTRAINT "price_check" CHECK (
        (is_tenant_addon = true AND monthly_supplement_vnd > 0)
        OR
        (is_tenant_addon = false AND monthly_supplement_vnd = 0)
      )
);
--> statement-breakpoint
ALTER TABLE "room_amenities" ADD CONSTRAINT "room_amenities_room_id_rooms_id_fk" FOREIGN KEY ("room_id") REFERENCES "public"."rooms"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "room_amenities" ADD CONSTRAINT "room_amenities_amenity_code_amenities_code_fk" FOREIGN KEY ("amenity_code") REFERENCES "public"."amenities"("code") ON DELETE cascade ON UPDATE no action;