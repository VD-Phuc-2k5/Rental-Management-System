import {
    IsArray,
    IsEnum,
    IsNotEmpty,
    IsOptional,
    IsString,
} from "class-validator";
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Amenity } from "src/shared/infrastructure/database/enum/amenity";

export class CreatePropertiesDto {
    @IsOptional()
    @IsString()
    @ApiPropertyOptional({ example: 'a4b91c1b-7ed5-4d8e-b17f-2b6f6bb0f2c1' })
    landlorerId!: string;

    @IsNotEmpty()
    @IsString()
    @ApiProperty({ example: 'Nha tro Hoa Phuong' })
    name!: string;

    @IsNotEmpty()
    @IsString()
    @ApiProperty({ example: '12 Nguyen Trai' })
    address!: string;

    @IsNotEmpty()
    @IsString()
    @ApiProperty({ example: 'Phuong 5' })
    ward!: string;

    @IsNotEmpty()
    @IsString()
    @ApiProperty({ example: 'Quan 3' })
    district!: string;

    @IsNotEmpty()
    @IsString()
    @ApiProperty({ example: 'TP Ho Chi Minh' })
    city!: string;

    @IsNotEmpty()
    @IsString()
    @ApiProperty({ example: 'Khu tro an ninh, gan truong hoc.' })
    description!: string;

    @IsNotEmpty()
    @IsArray()
    @IsEnum(Amenity, { each: true })
    @ApiProperty({ example: [Amenity.WIFI, Amenity.AIR_CONDITIONER] })
    amenityCodes!: Amenity[];
}