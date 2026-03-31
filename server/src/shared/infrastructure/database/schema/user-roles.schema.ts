import { pgEnum, pgTable, timestamp, unique, uuid } from 'drizzle-orm/pg-core';
import { users } from './users.schema';
import { relations } from 'drizzle-orm/relations';

export const roleType = pgEnum('role_type', ['tenant', 'landlord']);

export const userRoles = pgTable(
  'user_roles',
  {
    id: uuid('id').defaultRandom().primaryKey(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    role: roleType('role').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
  },
  (table) => ({
    userRoleUnique: unique('user_roles_user_id_role_unique').on(table.userId, table.role),
  }),
);

export const userRolesRelations = relations(userRoles, ({ one }) => ({
  user: one(users, {
    fields: [userRoles.userId],
    references: [users.id],
  }),
}));