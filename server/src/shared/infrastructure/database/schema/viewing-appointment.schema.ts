import { pgTable, uuid, text, timestamp, pgEnum } from 'drizzle-orm/pg-core';
import { users } from './users.schema';
import { rooms } from './room.schema';

export const viewingAppointmentStatusEnum = pgEnum(
  'viewing_appointment_status',
  ['pending', 'approved', 'rejected', 'cancelled'],
);

export const viewingAppointments = pgTable('room_viewing_appointments', {
  id: uuid('id').defaultRandom().primaryKey(),
  tenantId: uuid('tenant_id')
    .notNull()
    .references(() => users.id, { onDelete: 'cascade' }),
  roomId: uuid('room_id')
    .notNull()
    .references(() => rooms.id, { onDelete: 'cascade' }),
  scheduledAt: timestamp('scheduled_at', { withTimezone: true }).notNull(),
  status: viewingAppointmentStatusEnum('status').notNull().default('pending'),
  note: text('note'),
  createdAt: timestamp('created_at', { withTimezone: true })
    .defaultNow()
    .notNull(),
  updatedAt: timestamp('updated_at', { withTimezone: true })
    .defaultNow()
    .$onUpdate(() => new Date())
    .notNull(),
});
