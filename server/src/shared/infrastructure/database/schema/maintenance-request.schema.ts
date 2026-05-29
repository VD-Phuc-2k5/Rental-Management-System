import {
  pgTable,
  uuid,
  text,
  timestamp,
  pgEnum,
  jsonb,
} from 'drizzle-orm/pg-core';

import { users } from './users.schema';
import { rooms } from './room.schema';

export const maintenancePriorityEnum = pgEnum('maintenance_priority', [
  'low',
  'medium',
  'high',
]);

export const maintenanceRequestStatusEnum = pgEnum(
  'maintenance_request_status',
  ['pending', 'processing', 'completed', 'rejected', 'complaint'],
);

export const maintenanceRequests = pgTable('maintenance_requests', {
  id: uuid('id').defaultRandom().primaryKey(),

  tenantId: uuid('tenant_id')
    .notNull()
    .references(() => users.id, { onDelete: 'cascade' }),

  landlordId: uuid('landlord_id').references(() => users.id, {
    onDelete: 'set null',
  }),

  roomId: uuid('room_id').references(() => rooms.id, {
    onDelete: 'set null',
  }),

  title: text('title').notNull(),
  description: text('description').notNull().default(''),
  location: text('location').notNull().default('Chưa xác định'),

  priority: maintenancePriorityEnum('priority').notNull().default('low'),
  status: maintenanceRequestStatusEnum('status').notNull().default('pending'),

  imageUrls: jsonb('image_urls').notNull().default([]),

  technicianName: text('technician_name'),
  technicianPhone: text('technician_phone'),
  scheduledAt: timestamp('scheduled_at', { withTimezone: true }),
  landlordNote: text('landlord_note'),

  createdAt: timestamp('created_at', { withTimezone: true })
    .defaultNow()
    .notNull(),

  updatedAt: timestamp('updated_at', { withTimezone: true })
    .defaultNow()
    .$onUpdate(() => new Date())
    .notNull(),
});