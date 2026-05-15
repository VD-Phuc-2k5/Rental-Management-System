ALTER TABLE "users" ADD COLUMN "identity_number" text;--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_identity_number_unique" UNIQUE("identity_number");