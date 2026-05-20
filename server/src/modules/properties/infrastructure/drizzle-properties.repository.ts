import { DrizzleService } from "src/shared/infrastructure/database/drizzle.service";
import { CreatePropertiesInput, PropertiesRepository, UpdatePropertiesInput } from "../domain/repositories/properties.repository";
import { PropertiesEntity } from "../domain/entities/properties.entity";
import { properties } from "src/shared/infrastructure/database/schema";
import { LandlordNotFoundError } from "../domain/errors/properties.error";
import { Injectable } from "@nestjs/common";
import { Amenity } from "src/shared/infrastructure/database/enum/amenity";
import { eq, and } from "drizzle-orm";

@Injectable()
export class DrizzlePropertiesRepository implements PropertiesRepository {
    constructor(private readonly drizzleService: DrizzleService) {}

    private toAmenityCodes(codes: string[]): Amenity[] {
        const validAmenities = new Set(Object.values(Amenity));
        const invalid = codes.filter(c => !validAmenities.has(c as Amenity));
        if (invalid.length > 0) {
            throw new Error(`Invalid amenity codes: ${invalid.join(", ")}`);
        }
        return codes as Amenity[];
    }

    private toEntity(row: typeof properties.$inferSelect): PropertiesEntity {
        return new PropertiesEntity(
            row.id,
            row.landlorerId,
            row.name,
            row.address,
            row.ward,
            row.district,
            row.city,
            row.description,
            this.toAmenityCodes(row.amenity_codes),
            row.createdAt.toISOString(),
            row.updatedAt.toISOString(),
        );
    }

    async createProperty(input: CreatePropertiesInput): Promise<PropertiesEntity> {
        try {
            const [row] = await this.drizzleService.db.insert(properties)
                .values({
                    landlorerId: input.landlorerId,
                    name: input.name,
                    address: input.address,
                    ward: input.ward,
                    district: input.district,
                    city: input.city,
                    description: input.description,
                    amenity_codes: input.amenityCodes,
                })
                .returning();
            return this.toEntity(row);
        } catch (error: unknown) {
            const code = (error as any)?.code || (error as any)?.cause?.code;
            if (code === "23503") throw new LandlordNotFoundError();
            throw error;
        }
    }

    async findAllByLandlordId(landlorerId: string): Promise<PropertiesEntity[]> {
        const rows = await this.drizzleService.db
            .select()
            .from(properties)
            .where(eq(properties.landlorerId, landlorerId));
        return rows.map(r => this.toEntity(r));
    }

    async findById(id: string): Promise<PropertiesEntity | null> {
        const [row] = await this.drizzleService.db
            .select()
            .from(properties)
            .where(eq(properties.id, id));
        return row ? this.toEntity(row) : null;
    }

    async updateProperty(id: string, landlorerId: string, input: UpdatePropertiesInput): Promise<PropertiesEntity> {
        const updateData: Partial<typeof properties.$inferInsert> = {};
        if (input.name !== undefined) updateData.name = input.name;
        if (input.address !== undefined) updateData.address = input.address;
        if (input.ward !== undefined) updateData.ward = input.ward;
        if (input.district !== undefined) updateData.district = input.district;
        if (input.city !== undefined) updateData.city = input.city;
        if (input.description !== undefined) updateData.description = input.description;
        if (input.amenityCodes !== undefined) updateData.amenity_codes = input.amenityCodes;

        const [row] = await this.drizzleService.db
            .update(properties)
            .set(updateData)
            .where(and(eq(properties.id, id), eq(properties.landlorerId, landlorerId)))
            .returning();
        return this.toEntity(row);
    }

    async deleteProperty(id: string, landlorerId: string): Promise<void> {
        await this.drizzleService.db
            .delete(properties)
            .where(and(eq(properties.id, id), eq(properties.landlorerId, landlorerId)));
    }
}
