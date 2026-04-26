import { pgEnum, pgTable, text, timestamp } from 'drizzle-orm/pg-core';

export const amenityValues = [
	'WIFI',
	'BED',
	'FRIDGE',
	'BALCONY',
	'WATER_HEATER',
	'AIR_CONDITIONER',
	'PRIVATE_BATHROOM',
] as const;

export const amenityEnum = pgEnum('amenity', amenityValues);

export const amenities = pgTable('amenities', {
	code: amenityEnum('code').primaryKey(),
	name: text('name').notNull(),
	createdAt: timestamp('created_at', { withTimezone: true }).defaultNow().notNull(),
	updatedAt: timestamp('updated_at', { withTimezone: true })
		.defaultNow()
		.$onUpdate(() => new Date())
		.notNull(),
});

export const amenitySeed: Array<{ code: (typeof amenityValues)[number]; name: string }> = [
	{ code: 'WIFI', name: 'Wifi' },
	{ code: 'BED', name: 'Bed' },
	{ code: 'FRIDGE', name: 'Fridge' },
	{ code: 'BALCONY', name: 'Balcony' },
	{ code: 'WATER_HEATER', name: 'Water Heater' },
	{ code: 'AIR_CONDITIONER', name: 'Air Conditioner' },
	{ code: 'PRIVATE_BATHROOM', name: 'Private Bathroom' },
];
