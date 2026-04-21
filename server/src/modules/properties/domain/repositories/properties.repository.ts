import { PropertiesEntity } from "../entities/properties.entity";
import { Amenity } from "src/shared/infrastructure/database/enum/amenity";

export type CreatePropertiesInput = {
    landlorerId: string;
    name: string;
    address: string;
    ward: string;
    district: string;
    city: string;
    description: string;
    amenityCodes: Amenity[];
}

export abstract class PropertiesRepository {
    abstract createProperty(input: CreatePropertiesInput): Promise<PropertiesEntity>;
}