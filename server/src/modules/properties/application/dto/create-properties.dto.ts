import {
    IsArray,
    IsEnum,
	IsNotEmpty,
	IsOptional,
	IsString,
} from "class-validator";
import { Amenity } from "src/shared/infrastructure/database/enum/amenity";

export class CreatePropertiesDto {
    @IsOptional()
    @IsString()
    landlorerId!: string;

    @IsNotEmpty()
    @IsString()
    name!: string;

    @IsNotEmpty()
    @IsString()
    address!: string;

    @IsNotEmpty()
    @IsString()
    ward!: string;

    @IsNotEmpty()
    @IsString()
    district!: string;

    @IsNotEmpty()
    @IsString()
    city!: string;

    @IsNotEmpty()
    @IsString()
    description!: string;

    @IsNotEmpty()
    @IsArray()
    @IsEnum(Amenity, { each: true })
    amenityCodes!: Amenity[];
}