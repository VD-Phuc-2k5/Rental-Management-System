import {
  IsArray,
  IsBoolean,
  IsEnum,
  IsNumber,
  IsOptional,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { AddonAmenityDto } from './create-room.dto';

export type RoomStatus = 'AVAILABLE' | 'OCCUPIED' | 'MAINTENANCE';

export class UpdateRoomDto {
  @IsOptional()
  @IsString()
  @ApiPropertyOptional({ example: 'Phong 101' })
  title?: string;

  @IsOptional()
  @IsEnum(['AVAILABLE', 'OCCUPIED', 'MAINTENANCE'])
  @ApiPropertyOptional()
  status?: RoomStatus;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  @ApiPropertyOptional()
  area_sqm?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  @ApiPropertyOptional()
  monthly_rent?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  @ApiPropertyOptional()
  deposit_amount?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  @ApiPropertyOptional()
  electricity_rate_per_kwh?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  @ApiPropertyOptional()
  water_rate_per_m3?: number;

  @IsOptional()
  @IsBoolean()
  @ApiPropertyOptional()
  has_furniture?: boolean;

  @IsOptional()
  @IsString()
  @ApiPropertyOptional()
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
}
