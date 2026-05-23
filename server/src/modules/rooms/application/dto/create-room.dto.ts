import {
  IsArray,
  IsBoolean,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class ParkingFeesDto {
  @IsNumber() @Min(0) bicycle!: number;
  @IsNumber() @Min(0) motorbike!: number;
  @IsNumber() @Min(0) car!: number;
}

export class AddonAmenityDto {
  @IsString()
  code!: string;

  @IsNumber()
  @Min(0)
  monthly_price!: number;
}

export class RoomImageDto {
  @IsString()
  @ApiProperty({ example: 'https://storage.example.com/rooms/img.jpg' })
  url!: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  @ApiPropertyOptional({ example: 0 })
  sortOrder?: number;
}

export class CreateRoomDto {
  @IsNotEmpty()
  @IsString()
  @ApiProperty({ example: 'Phong 101' })
  title!: string;

  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  @ApiProperty({ example: 25 })
  area_sqm!: number;

  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  @ApiProperty({ example: 3000000 })
  monthly_rent!: number;

  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  @ApiProperty({ example: 6000000 })
  deposit_amount!: number;

  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  @ApiProperty({ example: 3500 })
  electricity_rate_per_kwh!: number;

  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  @ApiProperty({ example: 15000 })
  water_rate_per_m3!: number;

  @IsOptional()
  @IsBoolean()
  @ApiPropertyOptional({ example: false })
  has_furniture?: boolean;

  @IsOptional()
  @IsString()
  @ApiPropertyOptional({ example: 'Phong sang, thoang mat' })
  description?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  @ApiPropertyOptional({ example: ['AC', 'BED'] })
  included_amenity_codes?: string[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => AddonAmenityDto)
  @ApiPropertyOptional({ example: [{ code: 'TV', monthly_price: 50000 }] })
  addon_amenities?: AddonAmenityDto[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => RoomImageDto)
  @ApiPropertyOptional({
    example: [
      { url: 'https://storage.example.com/rooms/img.jpg', sortOrder: 0 },
    ],
  })
  images?: RoomImageDto[];

  @IsOptional()
  @ValidateNested()
  @Type(() => ParkingFeesDto)
  @ApiPropertyOptional({
    example: { bicycle: 50000, motorbike: 150000, car: 1000000 },
  })
  parking_fees?: ParkingFeesDto;
}
