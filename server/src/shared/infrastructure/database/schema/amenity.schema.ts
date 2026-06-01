import { pgEnum, pgTable, text, timestamp } from 'drizzle-orm/pg-core';

export const amenityValues = [
	'WIFI',
	'BED',
	'FRIDGE',
	'BALCONY',
	'WATER_HEATER',
	'AIR_CONDITIONER',
	'PRIVATE_BATHROOM',
	'PARKING',
	'SECURITY',
	'CAMERA',
	'FREE_TIME',
	'ELEVATOR',
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
	{ code: 'BED', name: 'Giường' },
	{ code: 'FRIDGE', name: 'Tủ lạnh' },
	{ code: 'BALCONY', name: 'Ban công' },
	{ code: 'WATER_HEATER', name: 'Máy nước nóng' },
	{ code: 'AIR_CONDITIONER', name: 'Điều hòa' },
	{ code: 'PRIVATE_BATHROOM', name: 'WC riêng' },
	{ code: 'PARKING', name: 'Giữ xe' },
	{ code: 'SECURITY', name: 'An ninh 24/7' },
	{ code: 'CAMERA', name: 'Camera' },
	{ code: 'FREE_TIME', name: 'Giờ giấc tự do' },
	{ code: 'ELEVATOR', name: 'Thang máy' },
];
