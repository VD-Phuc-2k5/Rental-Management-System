import { Injectable } from '@nestjs/common';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import {
  RoomRepository,
  CreateRoomInput,
  UpdateRoomInput,
} from '../domain/repositories/room.repository';
import {
  ParkingFees,
  RoomEntity,
  RoomImage,
  RoomStatus,
} from '../domain/entities/room.entity';
import { rooms, roomImages } from 'src/shared/infrastructure/database/schema';
import { eq, inArray } from 'drizzle-orm';

@Injectable()
export class DrizzleRoomRepository implements RoomRepository {
  constructor(private readonly drizzleService: DrizzleService) {}

  private toEntity(
    row: typeof rooms.$inferSelect,
    images: RoomImage[] = [],
  ): RoomEntity {
    const defaultFees: ParkingFees = {
      bicycle: 50000,
      motorbike: 150000,
      car: 1000000,
    };
    const parkingFees = (row.parking_fees as ParkingFees | null) ?? defaultFees;
    return new RoomEntity(
      row.id,
      row.propertyId,
      row.title,
      row.status as RoomStatus,
      row.area_sqm,
      row.monthly_rent,
      row.deposit_amount,
      row.electricity_rate_per_kwh,
      row.water_rate_per_m3,
      row.has_furniture,
      row.description ?? null,
      row.included_amenity_codes ?? [],
      (row.addon_amenities as Array<{ code: string; monthly_price: number }>) ??
        [],
      row.createdAt!.toISOString(),
      row.updatedAt!.toISOString(),
      images,
      parkingFees,
    );
  }

  async createRoom(input: CreateRoomInput): Promise<RoomEntity> {
    const [row] = await this.drizzleService.db
      .insert(rooms)
      .values({
        propertyId: input.propertyId,
        title: input.title,
        area_sqm: String(input.area_sqm),
        monthly_rent: String(input.monthly_rent),
        deposit_amount: String(input.deposit_amount),
        electricity_rate_per_kwh: String(input.electricity_rate_per_kwh),
        water_rate_per_m3: String(input.water_rate_per_m3),
        has_furniture: input.has_furniture ?? false,
        description: input.description,
        included_amenity_codes: input.included_amenity_codes ?? [],
        addon_amenities: input.addon_amenities ?? [],
        parking_fees: input.parking_fees ?? {
          bicycle: 50000,
          motorbike: 150000,
          car: 1000000,
        },
      })
      .returning();

    let images: RoomImage[] = [];
    if (input.images && input.images.length > 0) {
      images = await this.drizzleService.db
        .insert(roomImages)
        .values(
          input.images.map((img, idx) => ({
            roomId: row.id,
            url: img.url,
            sortOrder: img.sortOrder ?? idx,
          })),
        )
        .returning()
        .then((rows) =>
          rows.map((r) => ({ id: r.id, url: r.url, sortOrder: r.sortOrder })),
        );
    }

    return this.toEntity(row, images);
  }

  async findAllByPropertyId(propertyId: string): Promise<RoomEntity[]> {
    const rows = await this.drizzleService.db
      .select()
      .from(rooms)
      .where(eq(rooms.propertyId, propertyId));

    if (rows.length === 0) return [];

    const roomIds = rows.map((r) => r.id);
    const imgRows = await this.drizzleService.db
      .select()
      .from(roomImages)
      .where(inArray(roomImages.roomId, roomIds));

    const imgMap = new Map<string, RoomImage[]>();
    for (const img of imgRows) {
      const list = imgMap.get(img.roomId) ?? [];
      list.push({ id: img.id, url: img.url, sortOrder: img.sortOrder });
      imgMap.set(img.roomId, list);
    }

    return rows.map((r) => this.toEntity(r, imgMap.get(r.id) ?? []));
  }

  async findById(id: string): Promise<RoomEntity | null> {
    const [row] = await this.drizzleService.db
      .select()
      .from(rooms)
      .where(eq(rooms.id, id));

    if (!row) return null;

    const imgRows = await this.drizzleService.db
      .select()
      .from(roomImages)
      .where(eq(roomImages.roomId, id));

    const images: RoomImage[] = imgRows.map((r) => ({
      id: r.id,
      url: r.url,
      sortOrder: r.sortOrder,
    }));

    return this.toEntity(row, images);
  }

  async updateRoom(id: string, input: UpdateRoomInput): Promise<RoomEntity> {
    const updateData: Partial<typeof rooms.$inferInsert> = {};
    if (input.title !== undefined) updateData.title = input.title;
    if (input.status !== undefined) updateData.status = input.status;
    if (input.area_sqm !== undefined)
      updateData.area_sqm = String(input.area_sqm);
    if (input.monthly_rent !== undefined)
      updateData.monthly_rent = String(input.monthly_rent);
    if (input.deposit_amount !== undefined)
      updateData.deposit_amount = String(input.deposit_amount);
    if (input.electricity_rate_per_kwh !== undefined)
      updateData.electricity_rate_per_kwh = String(
        input.electricity_rate_per_kwh,
      );
    if (input.water_rate_per_m3 !== undefined)
      updateData.water_rate_per_m3 = String(input.water_rate_per_m3);
    if (input.has_furniture !== undefined)
      updateData.has_furniture = input.has_furniture;
    if (input.description !== undefined)
      updateData.description = input.description;
    if (input.included_amenity_codes !== undefined)
      updateData.included_amenity_codes = input.included_amenity_codes;
    if (input.addon_amenities !== undefined)
      updateData.addon_amenities = input.addon_amenities;
    if (input.parking_fees !== undefined)
      updateData.parking_fees = input.parking_fees;

    const [row] = await this.drizzleService.db
      .update(rooms)
      .set(updateData)
      .where(eq(rooms.id, id))
      .returning();

    let images: RoomImage[] = [];
    if (input.images !== undefined) {
      await this.drizzleService.db
        .delete(roomImages)
        .where(eq(roomImages.roomId, id));

      if (input.images.length > 0) {
        images = await this.drizzleService.db
          .insert(roomImages)
          .values(
            input.images.map((img, idx) => ({
              roomId: id,
              url: img.url,
              sortOrder: img.sortOrder ?? idx,
            })),
          )
          .returning()
          .then((rows) =>
            rows.map((r) => ({ id: r.id, url: r.url, sortOrder: r.sortOrder })),
          );
      }
    } else {
      const imgRows = await this.drizzleService.db
        .select()
        .from(roomImages)
        .where(eq(roomImages.roomId, id));
      images = imgRows.map((r) => ({
        id: r.id,
        url: r.url,
        sortOrder: r.sortOrder,
      }));
    }

    return this.toEntity(row, images);
  }

  async deleteRoom(id: string): Promise<void> {
    await this.drizzleService.db.delete(rooms).where(eq(rooms.id, id));
  }
}
