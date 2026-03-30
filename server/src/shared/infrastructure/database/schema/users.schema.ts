import { pgSchema, pgTable, text, timestamp, uuid } from 'drizzle-orm/pg-core';

const authSchema = pgSchema('auth');
const authUsers = authSchema.table('users', {
  id: uuid('id'),
});

export const users = pgTable('users', {
  id: uuid('id')
    .primaryKey()
    .references(() => authUsers.id, { onDelete: 'cascade' }),
  phone: text('phone').notNull(),
  fullName: text('full_name').notNull(),
  avatarUrl: text('avatar_url'),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
  updatedAt: timestamp('updated_at', { withTimezone: true })
    .defaultNow()
    .$onUpdate(() => new Date())
    .notNull(),
});
