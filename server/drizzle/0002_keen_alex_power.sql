CREATE TABLE "properties" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"landlorer_id" uuid NOT NULL,
	"name" text NOT NULL,
	"address" text NOT NULL,
	"ward" text NOT NULL,
	"district" text NOT NULL,
	"city" text NOT NULL,
	"description" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "properties" ADD CONSTRAINT "properties_landlorer_id_users_id_fk" FOREIGN KEY ("landlorer_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;