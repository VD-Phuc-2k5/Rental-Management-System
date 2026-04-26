import { BadRequestException, Inject } from "@nestjs/common";
import { PropertiesRepository } from "../../domain/repositories/properties.repository";
import { CreatePropertiesDto } from "../dto/create-properties.dto";
import { PropertiesEntity } from "../../domain/entities/properties.entity";
import { Amenity } from "src/shared/infrastructure/database/enum/amenity";

export class CreatePropertiesService {
    constructor(
        @Inject(PropertiesRepository)
        private readonly propertiesRepository: PropertiesRepository
    ) {}

    async execute(input: CreatePropertiesDto): Promise<PropertiesEntity> {
        const validAmenities = new Set(Object.values(Amenity));
        const invalidAmenityCodes = input.amenityCodes.filter(
            (code) => !validAmenities.has(code),
        );

        if (invalidAmenityCodes.length > 0) {
            throw new BadRequestException(
                `amenityCodes không hợp lệ: ${invalidAmenityCodes.join(', ')}`,
            );
        }

        const property = await this.propertiesRepository.createProperty({
            landlorerId: input.landlorerId,
            name: input.name,
            address: input.address,
            ward: input.ward,
            district: input.district,
            city: input.city,
            description: input.description,
            amenityCodes: input.amenityCodes,
        });

        return property;
    }
}