import {
  pgTable,
  uuid,
  text,
  numeric,
  timestamp,
  pgEnum,
} from 'drizzle-orm/pg-core';
import { contracts } from './contract.schema';
import { users } from './users.schema';
import { rooms } from './room.schema';

// Định nghĩa trạng thái của phiếu phạt
export const penaltyStatusEnum = pgEnum('penalty_status', [
  'pending',
  'paid',
  'cancelled',
]);

export const penalties = pgTable('penalties', {
  id: uuid('id').defaultRandom().primaryKey(),
  contractId: uuid('contract_id')
    .notNull()
    .references(() => contracts.id, { onDelete: 'cascade' }),
  tenantId: uuid('tenant_id')
    .notNull()
    .references(() => users.id),
  roomId: uuid('room_id')
    .notNull()
    .references(() => rooms.id),
  amount: numeric('amount', { precision: 12, scale: 2 }).notNull(),
  reason: text('reason').notNull(),
  status: penaltyStatusEnum('status').notNull().default('pending'),
  createdAt: timestamp('created_at', { withTimezone: true })
    .defaultNow()
    .notNull(),
  updatedAt: timestamp('updated_at', { withTimezone: true })
    .defaultNow()
    .$onUpdate(() => new Date())
    .notNull(),
});
