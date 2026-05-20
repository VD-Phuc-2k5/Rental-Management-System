import { PropertiesEntity } from '../entities/properties.entity';
import { Amenity } from 'src/shared/infrastructure/database/enum/amenity';

export type CreatePropertiesInput = {
  landlorerId: string;
  name: string;
  address: string;
  ward: string;
  district: string;
  city: string;
  description: string;
  amenityCodes: Amenity[];
};

export type UpdatePropertiesInput = {
  name?: string;
  address?: string;
  ward?: string;
  district?: string;
  city?: string;
  description?: string;
  amenityCodes?: Amenity[];
};

export abstract class PropertiesRepository {
  abstract createProperty(
    input: CreatePropertiesInput,
  ): Promise<PropertiesEntity>;
  abstract findAllByLandlordId(
    landlorerId: string,
  ): Promise<PropertiesEntity[]>;
  abstract findById(id: string): Promise<PropertiesEntity | null>;
  abstract updateProperty(
    id: string,
    landlorerId: string,
    input: UpdatePropertiesInput,
  ): Promise<PropertiesEntity>;
  abstract deleteProperty(id: string, landlorerId: string): Promise<void>;
}
