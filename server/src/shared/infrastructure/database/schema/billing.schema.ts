import {
  pgEnum,
  pgTable,
  uuid,
  text,
  integer,
  numeric,
  date,
  timestamp,
  uniqueIndex,
} from 'drizzle-orm/pg-core';
import { rooms } from './room.schema';
import { users } from './users.schema';

export const invoiceStatusEnum = pgEnum('invoice_status', [
  'draft',
  'finalized',
  'paid',
  'void',
]);

export const invoiceItemTypeEnum = pgEnum('invoice_item_type', [
  'rent',
  'electric',
  'water',
  'service',
  'adjustment',
]);

export const meterReadings = pgTable(
  'meter_readings',
  {
    id: uuid('id').defaultRandom().primaryKey(),
    roomId: uuid('room_id')
      .notNull()
      .references(() => rooms.id, { onDelete: 'cascade' }),
    month: text('month').notNull(),
    oldElectric: integer('old_electric').notNull(),
    newElectric: integer('new_electric').notNull(),
    oldWater: integer('old_water').notNull(),
    newWater: integer('new_water').notNull(),
    source: text('source'),
    createdBy: uuid('created_by').references(() => users.id),
    createdAt: timestamp('created_at', { withTimezone: true })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp('updated_at', { withTimezone: true })
      .defaultNow()
      .$onUpdate(() => new Date())
      .notNull(),
  },
  (table) => ({
    roomMonthUnique: uniqueIndex('meter_readings_room_month_unique').on(
      table.roomId,
      table.month,
    ),
  }),
);

export const invoices = pgTable(
  'invoices',
  {
    id: uuid('id').defaultRandom().primaryKey(),
    roomId: uuid('room_id')
      .notNull()
      .references(() => rooms.id, { onDelete: 'cascade' }),
    tenantId: uuid('tenant_id')
      .notNull()
      .references(() => users.id),
    landlordId: uuid('landlord_id')
      .notNull()
      .references(() => users.id),
    month: text('month').notNull(),
    status: invoiceStatusEnum('status').notNull().default('draft'),
    dueDate: date('due_date'),
    total: numeric('total', { precision: 12, scale: 2 }).notNull().default('0'),
    createdBy: uuid('created_by').references(() => users.id),
    finalizedAt: timestamp('finalized_at', { withTimezone: true }),
    paidAt: timestamp('paid_at', { withTimezone: true }),
    createdAt: timestamp('created_at', { withTimezone: true })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp('updated_at', { withTimezone: true })
      .defaultNow()
      .$onUpdate(() => new Date())
      .notNull(),
  },
  (table) => ({
    roomMonthUnique: uniqueIndex('invoices_room_month_unique').on(
      table.roomId,
      table.month,
    ),
  }),
);

export const invoiceItems = pgTable('invoice_items', {
  id: uuid('id').defaultRandom().primaryKey(),
  invoiceId: uuid('invoice_id')
    .notNull()
    .references(() => invoices.id, { onDelete: 'cascade' }),
  type: invoiceItemTypeEnum('type').notNull(),
  quantity: numeric('quantity', { precision: 12, scale: 2 })
    .notNull()
    .default('1'),
  unitPrice: numeric('unit_price', { precision: 12, scale: 2 })
    .notNull()
    .default('0'),
  amount: numeric('amount', { precision: 12, scale: 2 })
    .notNull()
    .default('0'),
  description: text('description'),
});
