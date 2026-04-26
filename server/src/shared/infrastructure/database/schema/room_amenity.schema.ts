import {
  pgTable,
  uuid,
  boolean,
  integer,
  timestamp,
  primaryKey,
  check
} from 'drizzle-orm/pg-core';
import { rooms } from './room.schema';
import { amenities } from './amenity.schema';
import { amenityEnum } from './amenity.schema';
import { sql, relations } from 'drizzle-orm';
import { properties } from './properties.schema';

export const roomAmenities = pgTable(
  'room_amenities',
  {
    roomId: uuid('room_id')
      .notNull()
      .references(() => rooms.id, { onDelete: 'cascade' }),
    amenityCode: amenityEnum('amenity_code')
      .notNull()
      .references(() => amenities.code, { onDelete: 'cascade' }),
    isTenantAddon: boolean('is_tenant_addon').notNull(),
    monthlySupplementVnd: integer('monthly_supplement_vnd').default(0),
    createdAt: timestamp('created_at', { withTimezone: true })
      .defaultNow()
      .notNull(),
  },
  (table) => ({
    pk: primaryKey({
        columns: [table.roomId, table.amenityCode],
    }),

    // constraint chống data bẩn
    priceConstraint: check(
      'price_check',
      sql`
        (is_tenant_addon = true AND monthly_supplement_vnd > 0)
        OR
        (is_tenant_addon = false AND monthly_supplement_vnd = 0)
      `
    ),
  })
);

export const roomsRelations = relations(rooms, ({ one, many }) => ({
  roomAmenities: many(roomAmenities),
  property: one(properties, {
    fields: [rooms.propertyId],
    references: [properties.id],
  }),
}));

export const amenitiesRelations = relations(amenities, ({ many }) => ({
  roomAmenities: many(roomAmenities),
}));

export const roomAmenitiesRelations = relations(roomAmenities, ({ one }) => ({
  room: one(rooms, {
    fields: [roomAmenities.roomId],
    references: [rooms.id],
  }),

  amenity: one(amenities, {
    fields: [roomAmenities.amenityCode],
    references: [amenities.code],
  }),
}));