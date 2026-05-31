CREATE TYPE "public"."rental_request_status" AS ENUM('pending', 'accepted', 'rejected', 'contracted');--> statement-breakpoint
CREATE TYPE "public"."contract_status" AS ENUM('draft', 'sent', 'signed', 'cancelled', 'finished');--> statement-breakpoint
CREATE TYPE "public"."viewing_appointment_status" AS ENUM('pending', 'approved', 'rejected', 'cancelled');--> statement-breakpoint
CREATE TYPE "public"."invoice_item_type" AS ENUM('rent', 'electric', 'water', 'service', 'adjustment');--> statement-breakpoint
CREATE TYPE "public"."invoice_status" AS ENUM('draft', 'finalized', 'paid', 'void');--> statement-breakpoint
ALTER TYPE "public"."amenity" ADD VALUE 'PARKING';--> statement-breakpoint
ALTER TYPE "public"."amenity" ADD VALUE 'SECURITY';--> statement-breakpoint
ALTER TYPE "public"."amenity" ADD VALUE 'CAMERA';--> statement-breakpoint
ALTER TYPE "public"."amenity" ADD VALUE 'FREE_TIME';--> statement-breakpoint
ALTER TYPE "public"."amenity" ADD VALUE 'ELEVATOR';--> statement-breakpoint
CREATE TABLE "room_images" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"room_id" uuid NOT NULL,
	"url" text NOT NULL,
	"sort_order" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "rental_requests" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"tenant_id" uuid NOT NULL,
	"room_id" uuid NOT NULL,
	"landlord_id" uuid,
	"note" text,
	"member_info" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"parking_info" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"status" "rental_request_status" DEFAULT 'pending' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "contracts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"rental_request_id" uuid,
	"room_id" uuid NOT NULL,
	"tenant_id" uuid NOT NULL,
	"landlord_id" uuid NOT NULL,
	"start_date" date NOT NULL,
	"end_date" date NOT NULL,
	"monthly_rent" numeric(12, 2) NOT NULL,
	"deposit" numeric(12, 2) NOT NULL,
	"status" "contract_status" DEFAULT 'draft' NOT NULL,
	"terms" text,
	"sent_at" timestamp with time zone,
	"signed_at" timestamp with time zone,
	"cancelled_at" timestamp with time zone,
	"finished_at" timestamp with time zone,
	"vnpay_number" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "contract_members" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"contract_id" uuid NOT NULL,
	"full_name" text NOT NULL,
	"phone" text,
	"identity_number" text,
	"email" text,
	"address" text,
	"is_room_leader" boolean DEFAULT false NOT NULL,
	"identity_image_url" text,
	"date_of_birth" text,
	"left_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "room_viewing_appointments" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"tenant_id" uuid NOT NULL,
	"room_id" uuid NOT NULL,
	"scheduled_at" timestamp with time zone NOT NULL,
	"status" "viewing_appointment_status" DEFAULT 'pending' NOT NULL,
	"note" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "invoice_items" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"invoice_id" uuid NOT NULL,
	"type" "invoice_item_type" NOT NULL,
	"quantity" numeric(12, 2) DEFAULT '1' NOT NULL,
	"unit_price" numeric(12, 2) DEFAULT '0' NOT NULL,
	"amount" numeric(12, 2) DEFAULT '0' NOT NULL,
	"description" text
);
--> statement-breakpoint
CREATE TABLE "invoices" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"room_id" uuid NOT NULL,
	"tenant_id" uuid NOT NULL,
	"landlord_id" uuid NOT NULL,
	"month" text NOT NULL,
	"status" "invoice_status" DEFAULT 'draft' NOT NULL,
	"due_date" date,
	"total" numeric(12, 2) DEFAULT '0' NOT NULL,
	"created_by" uuid,
	"finalized_at" timestamp with time zone,
	"paid_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "meter_readings" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"room_id" uuid NOT NULL,
	"month" text NOT NULL,
	"old_electric" integer NOT NULL,
	"new_electric" integer NOT NULL,
	"old_water" integer NOT NULL,
	"new_water" integer NOT NULL,
	"source" text,
	"created_by" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "rooms" ALTER COLUMN "has_furniture" SET DEFAULT false;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "date_of_birth" text;--> statement-breakpoint
ALTER TABLE "rooms" ADD COLUMN "included_amenity_codes" text[] DEFAULT '{}' NOT NULL;--> statement-breakpoint
ALTER TABLE "rooms" ADD COLUMN "addon_amenities" jsonb DEFAULT '[]'::jsonb NOT NULL;--> statement-breakpoint
ALTER TABLE "rooms" ADD COLUMN "parking_fees" jsonb DEFAULT '{"motorbike":150000,"car":1000000}'::jsonb NOT NULL;--> statement-breakpoint
ALTER TABLE "room_images" ADD CONSTRAINT "room_images_room_id_rooms_id_fk" FOREIGN KEY ("room_id") REFERENCES "public"."rooms"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "rental_requests" ADD CONSTRAINT "rental_requests_tenant_id_users_id_fk" FOREIGN KEY ("tenant_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "rental_requests" ADD CONSTRAINT "rental_requests_room_id_rooms_id_fk" FOREIGN KEY ("room_id") REFERENCES "public"."rooms"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "rental_requests" ADD CONSTRAINT "rental_requests_landlord_id_users_id_fk" FOREIGN KEY ("landlord_id") REFERENCES "public"."users"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "contracts" ADD CONSTRAINT "contracts_rental_request_id_rental_requests_id_fk" FOREIGN KEY ("rental_request_id") REFERENCES "public"."rental_requests"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "contracts" ADD CONSTRAINT "contracts_room_id_rooms_id_fk" FOREIGN KEY ("room_id") REFERENCES "public"."rooms"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "contracts" ADD CONSTRAINT "contracts_tenant_id_users_id_fk" FOREIGN KEY ("tenant_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "contracts" ADD CONSTRAINT "contracts_landlord_id_users_id_fk" FOREIGN KEY ("landlord_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "contract_members" ADD CONSTRAINT "contract_members_contract_id_contracts_id_fk" FOREIGN KEY ("contract_id") REFERENCES "public"."contracts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "room_viewing_appointments" ADD CONSTRAINT "room_viewing_appointments_tenant_id_users_id_fk" FOREIGN KEY ("tenant_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "room_viewing_appointments" ADD CONSTRAINT "room_viewing_appointments_room_id_rooms_id_fk" FOREIGN KEY ("room_id") REFERENCES "public"."rooms"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "invoice_items" ADD CONSTRAINT "invoice_items_invoice_id_invoices_id_fk" FOREIGN KEY ("invoice_id") REFERENCES "public"."invoices"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_room_id_rooms_id_fk" FOREIGN KEY ("room_id") REFERENCES "public"."rooms"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_tenant_id_users_id_fk" FOREIGN KEY ("tenant_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_landlord_id_users_id_fk" FOREIGN KEY ("landlord_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "meter_readings" ADD CONSTRAINT "meter_readings_room_id_rooms_id_fk" FOREIGN KEY ("room_id") REFERENCES "public"."rooms"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "meter_readings" ADD CONSTRAINT "meter_readings_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "invoices_room_month_unique" ON "invoices" USING btree ("room_id","month");--> statement-breakpoint
CREATE UNIQUE INDEX "meter_readings_room_month_unique" ON "meter_readings" USING btree ("room_id","month");