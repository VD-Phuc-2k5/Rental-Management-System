import {
  IsString,
  IsOptional,
  IsUUID,
  IsArray,
  IsBoolean,
  IsInt,
  Min,
  ValidateNested,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class MemberInfoDto {
  @IsString()
  fullName: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsString()
  identityNumber?: string;

  @IsOptional()
  @IsString()
  identityImageUrl?: string;

  @IsOptional()
  @IsString()
  email?: string;

  @IsOptional()
  @IsString()
  address?: string;

  @IsOptional()
  @IsString()
  dateOfBirth?: string;

  @IsBoolean()
  isRoomLeader: boolean;
}

export class VehicleInfoDto {
  @IsString()
  type: string;

  @IsString()
  plate: string;

  @IsInt()
  @Min(1)
  quantity: number;
}

export class CreateRentalRequestDto {
  @ApiProperty()
  @IsUUID()
  roomId: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  note?: string;

  @ApiPropertyOptional({ type: [MemberInfoDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => MemberInfoDto)
  memberInfo?: MemberInfoDto[];

  @ApiPropertyOptional({ type: [VehicleInfoDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => VehicleInfoDto)
  parkingInfo?: VehicleInfoDto[];
}
