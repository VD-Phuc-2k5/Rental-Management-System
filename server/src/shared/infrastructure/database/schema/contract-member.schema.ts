import { pgTable, uuid, text, boolean, timestamp } from 'drizzle-orm/pg-core';
import { contracts } from './contract.schema';

export const contractMembers = pgTable('contract_members', {
  id: uuid('id').defaultRandom().primaryKey(),
  contractId: uuid('contract_id')
    .notNull()
    .references(() => contracts.id, { onDelete: 'cascade' }),
  fullName: text('full_name').notNull(),
  phone: text('phone'),
  identityNumber: text('identity_number'),
  email: text('email'),
  address: text('address'),
  isRoomLeader: boolean('is_room_leader').notNull().default(false),
  leftAt: timestamp('left_at', { withTimezone: true }),
  createdAt: timestamp('created_at', { withTimezone: true })
    .defaultNow()
    .notNull(),
  updatedAt: timestamp('updated_at', { withTimezone: true })
    .defaultNow()
    .$onUpdate(() => new Date())
    .notNull(),
});
