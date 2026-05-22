import {
  pgTable,
  uuid,
  date,
  numeric,
  text,
  timestamp,
  pgEnum,
} from 'drizzle-orm/pg-core';
import { users } from './users.schema';
import { rooms } from './room.schema';
import { rentalRequests } from './rental-request.schema';

export const contractStatusEnum = pgEnum('contract_status', [
  'draft',
  'sent',
  'signed',
  'cancelled',
  'finished',
]);

export const contracts = pgTable('contracts', {
  id: uuid('id').defaultRandom().primaryKey(),
  rentalRequestId: uuid('rental_request_id').references(
    () => rentalRequests.id,
  ),
  roomId: uuid('room_id')
    .notNull()
    .references(() => rooms.id),
  tenantId: uuid('tenant_id')
    .notNull()
    .references(() => users.id),
  landlordId: uuid('landlord_id')
    .notNull()
    .references(() => users.id),
  startDate: date('start_date').notNull(),
  endDate: date('end_date').notNull(),
  monthlyRent: numeric('monthly_rent', { precision: 12, scale: 2 }).notNull(),
  deposit: numeric('deposit', { precision: 12, scale: 2 }).notNull(),
  status: contractStatusEnum('status').notNull().default('draft'),
  terms: text('terms'),
  sentAt: timestamp('sent_at', { withTimezone: true }),
  signedAt: timestamp('signed_at', { withTimezone: true }),
  cancelledAt: timestamp('cancelled_at', { withTimezone: true }),
  finishedAt: timestamp('finished_at', { withTimezone: true }),
  createdAt: timestamp('created_at', { withTimezone: true })
    .defaultNow()
    .notNull(),
  updatedAt: timestamp('updated_at', { withTimezone: true })
    .defaultNow()
    .$onUpdate(() => new Date())
    .notNull(),
});
