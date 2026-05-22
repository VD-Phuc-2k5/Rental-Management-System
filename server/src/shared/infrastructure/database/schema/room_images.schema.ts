import { pgTable, uuid, text, integer, timestamp } from 'drizzle-orm/pg-core';
import { rooms } from './room.schema';

export const roomImages = pgTable('room_images', {
  id: uuid('id').defaultRandom().primaryKey(),
  roomId: uuid('room_id')
    .notNull()
    .references(() => rooms.id, { onDelete: 'cascade' }),
  url: text('url').notNull(),
  sortOrder: integer('sort_order').notNull().default(0),
  createdAt: timestamp('created_at', { withTimezone: true })
    .defaultNow()
    .notNull(),
});
