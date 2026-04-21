import { DrizzleService } from "src/shared/infrastructure/database/drizzle.service";
import { CreatePropertiesInput, PropertiesRepository } from "../domain/repositories/properties.repository";
import { PropertiesEntity } from "../domain/entities/properties.entity";
import { properties } from "src/shared/infrastructure/database/schema";
import { LandlordNotFoundError } from "../domain/errors/properties.error";
import { Injectable } from "@nestjs/common";
import { Amenity } from "src/shared/infrastructure/database/enum/amenity";

@Injectable()
export class DrizzlePropertiesRepository implements PropertiesRepository {
    constructor(private readonly drizzleService: DrizzleService) {}

    private toAmenityCodes(codes: string[]): Amenity[] {
        const validAmenities = new Set(Object.values(Amenity));
        const invalidCodes = codes.filter((code) => !validAmenities.has(code as Amenity));

        if (invalidCodes.length > 0) {
            throw new Error(`Invalid amenity codes from database: ${invalidCodes.join(', ')}`);
        }

        return codes as Amenity[];
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
        } catch (error: unknown) {
            const err = error as any;
            
            const code = err?.code || err?.cause?.code;
            if (code === '23503') {
                throw new LandlordNotFoundError();
            }
            throw error;
        }
    }
}