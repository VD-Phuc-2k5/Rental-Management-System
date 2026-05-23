import {
  pgTable,
  uuid,
  text,
  timestamp,
  pgEnum,
  numeric,
  boolean,
  jsonb,
} from 'drizzle-orm/pg-core';
import { properties } from './properties.schema';

export const roomStatusEnum = pgEnum('room_status', [
  'AVAILABLE',
  'OCCUPIED',
  'MAINTENANCE',
]);

export const rooms = pgTable('rooms', {
  id: uuid('id').defaultRandom().primaryKey(),
  propertyId: uuid('property_id')
    .notNull()
    .references(() => properties.id, { onDelete: 'cascade' }),
  title: text('title').notNull(),
  status: roomStatusEnum('status').default('AVAILABLE').notNull(),
  area_sqm: numeric('area_sqm', { precision: 10, scale: 2 }).notNull(),
  monthly_rent: numeric('monthly_rent', { precision: 10, scale: 2 }).notNull(),
  deposit_amount: numeric('deposit_amount', {
    precision: 10,
    scale: 2,
  }).notNull(),
  electricity_rate_per_kwh: numeric('electricity_rate_per_kwh', {
    precision: 10,
    scale: 2,
  }).notNull(),
  water_rate_per_m3: numeric('water_rate_per_m3', {
    precision: 10,
    scale: 2,
  }).notNull(),
  has_furniture: boolean('has_furniture').notNull().default(false),
  description: text('description'),
  included_amenity_codes: text('included_amenity_codes')
    .array()
    .notNull()
    .default([]),
  addon_amenities: jsonb('addon_amenities')
    .$type<Array<{ code: string; monthly_price: number }>>()
    .notNull()
    .default([]),
  parking_fees: jsonb('parking_fees')
    .$type<{ motorbike: number; car: number }>()
    .notNull()
    .default({ motorbike: 150000, car: 1000000 }),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true })
    .defaultNow()
    .$onUpdate(() => new Date()),
});
