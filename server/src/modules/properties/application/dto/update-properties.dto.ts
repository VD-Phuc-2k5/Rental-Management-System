import { IsArray, IsEnum, IsOptional, IsString } from "class-validator";
import { ApiPropertyOptional } from "@nestjs/swagger";
import { Amenity } from "src/shared/infrastructure/database/enum/amenity";

export class UpdatePropertiesDto {
    @IsOptional()
    @IsString()
    @ApiPropertyOptional({ example: 'Nha tro Hoa Phuong' })
    name?: string;

    @IsOptional()
    @IsString()
    @ApiPropertyOptional({ example: '12 Nguyen Trai' })
    address?: string;

    @IsOptional()
    @IsString()
    @ApiPropertyOptional({ example: 'Phuong 5' })
    ward?: string;

    @IsOptional()
    @IsString()
    @ApiPropertyOptional({ example: 'Quan 3' })
    district?: string;

    @IsOptional()
    @IsString()
    @ApiPropertyOptional({ example: 'TP Ho Chi Minh' })
    city?: string;

    @IsOptional()
    @IsString()
    @ApiPropertyOptional({ example: 'Khu tro an ninh, gan truong hoc.' })
    description?: string;

    @IsOptional()
    @IsArray()
    @IsEnum(Amenity, { each: true })
    @ApiPropertyOptional({ example: [Amenity.WIFI, Amenity.AIR_CONDITIONER] })
    amenityCodes?: Amenity[];
}
