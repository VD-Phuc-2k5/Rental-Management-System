import { pgTable, uuid, text, timestamp } from "drizzle-orm/pg-core";
import { users } from "./users.schema";
import { relations } from "drizzle-orm/relations";
import { Amenity } from "../enum/amenity";
import { amenityEnum } from "./amenity.schema";

export const properties = pgTable('properties', {
    id: uuid('id').defaultRandom().primaryKey(),
    landlorerId: uuid('landlorer_id').references(() => users.id).notNull(),
    name: text('name').notNull(),
    address: text('address').notNull(),
    ward: text('ward').notNull(),
    district: text('district').notNull(),
    city: text('city').notNull(),
    description: text('description').notNull(),
    amenity_codes: amenityEnum('amenities').array().$type<Amenity[]>().notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
    updatedAt: timestamp('updated_at', { withTimezone: true })
        .defaultNow()
        .$onUpdate(() => new Date())
        .notNull(),
});

export const propertiesRelations = relations(properties, ({ one }) => ({
    landlord: one(users, {
        fields: [properties.landlorerId],
        references: [users.id],
    }),
}));