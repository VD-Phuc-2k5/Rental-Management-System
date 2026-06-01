import { Inject, NotFoundException } from "@nestjs/common";
import { PropertiesRepository } from "../../domain/repositories/properties.repository";
import { PropertiesEntity } from "../../domain/entities/properties.entity";
import { PropertyNotFoundError } from "../../domain/errors/properties.error";

export class GetPropertyByIdService {
    constructor(
        @Inject(PropertiesRepository)
        private readonly propertiesRepository: PropertiesRepository,
    ) {}

    async execute(id: string, landlorerId: string): Promise<PropertiesEntity> {
        const property = await this.propertiesRepository.findById(id);
        if (!property || property.landlorerId !== landlorerId) {
            throw new NotFoundException("Khu tro khong ton tai");
        }
        return property;
    }
}
