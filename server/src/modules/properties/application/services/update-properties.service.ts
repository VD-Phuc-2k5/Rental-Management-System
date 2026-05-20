import { BadRequestException, Inject, NotFoundException } from "@nestjs/common";
import { PropertiesRepository } from "../../domain/repositories/properties.repository";
import { UpdatePropertiesDto } from "../dto/update-properties.dto";
import { PropertiesEntity } from "../../domain/entities/properties.entity";
import { Amenity } from "src/shared/infrastructure/database/enum/amenity";

export class UpdatePropertiesService {
    constructor(
        @Inject(PropertiesRepository)
        private readonly propertiesRepository: PropertiesRepository,
    ) {}

    async execute(id: string, landlorerId: string, input: UpdatePropertiesDto): Promise<PropertiesEntity> {
        const existing = await this.propertiesRepository.findById(id);
        if (!existing || existing.landlorerId !== landlorerId) {
            throw new NotFoundException("Khu tro khong ton tai");
        }

        if (input.amenityCodes) {
            const validAmenities = new Set(Object.values(Amenity));
            const invalid = input.amenityCodes.filter(c => !validAmenities.has(c));
            if (invalid.length > 0) {
                throw new BadRequestException(`amenityCodes khong hop le: ${invalid.join(", ")}`);
            }
        }

        return this.propertiesRepository.updateProperty(id, landlorerId, input);
    }
}
