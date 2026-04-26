import { Amenity } from "src/shared/infrastructure/database/enum/amenity";

export class PropertiesEntity {
    constructor(
        public readonly id: string,
        public readonly landlorerId: string,
        public readonly name: string,
        public readonly address: string,
        public readonly ward: string,
        public readonly district: string,
        public readonly city: string,
        public readonly description: string,
        public readonly amenityCodes: Amenity[],
        public readonly createdAt: string,
        public readonly updatedAt: string,
    ) {}

    isValidAmenity(amenityCode: Amenity): boolean {
        return this.amenityCodes.includes(amenityCode);
    }
}