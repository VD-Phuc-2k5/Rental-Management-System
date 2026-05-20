import { Inject, NotFoundException } from "@nestjs/common";
import { PropertiesRepository } from "../../domain/repositories/properties.repository";

export class DeletePropertiesService {
    constructor(
        @Inject(PropertiesRepository)
        private readonly propertiesRepository: PropertiesRepository,
    ) {}

    async execute(id: string, landlorerId: string): Promise<void> {
        const existing = await this.propertiesRepository.findById(id);
        if (!existing || existing.landlorerId !== landlorerId) {
            throw new NotFoundException("Khu tro khong ton tai");
        }
        await this.propertiesRepository.deleteProperty(id, landlorerId);
    }
}
