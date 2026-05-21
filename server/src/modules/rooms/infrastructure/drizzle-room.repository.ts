import { Injectable } from '@nestjs/common';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import {
  RoomRepository,
  CreateRoomInput,
  UpdateRoomInput,
} from '../domain/repositories/room.repository';
import { RoomEntity, RoomStatus } from '../domain/entities/room.entity';
import { rooms } from 'src/shared/infrastructure/database/schema';
import { eq } from 'drizzle-orm';

@Injectable()
export class DrizzleRoomRepository implements RoomRepository {
  constructor(private readonly drizzleService: DrizzleService) {}

  private toEntity(row: typeof rooms.$inferSelect): RoomEntity {
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
      })
      .returning();
    return this.toEntity(row);
  }

  async findAllByPropertyId(propertyId: string): Promise<RoomEntity[]> {
    const rows = await this.drizzleService.db
      .select()
      .from(rooms)
      .where(eq(rooms.propertyId, propertyId));
    return rows.map((r) => this.toEntity(r));
  }

  async findById(id: string): Promise<RoomEntity | null> {
    const [row] = await this.drizzleService.db
      .select()
      .from(rooms)
      .where(eq(rooms.id, id));
    return row ? this.toEntity(row) : null;
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

    const [row] = await this.drizzleService.db
      .update(rooms)
      .set(updateData)
      .where(eq(rooms.id, id))
      .returning();
    return this.toEntity(row);
  }

  async deleteRoom(id: string): Promise<void> {
    await this.drizzleService.db.delete(rooms).where(eq(rooms.id, id));
  }
}
