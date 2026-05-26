import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsInt, IsOptional, IsString, IsUUID, Matches, Min } from 'class-validator';

export class CreateMeterReadingDto {
  @ApiProperty()
  @IsUUID()
  roomId!: string;

  @ApiProperty({ example: '2026-05' })
  @IsString()
  @Matches(/^\d{4}-\d{2}$/, { message: 'month must be in YYYY-MM format' })
  month!: string;

  @ApiProperty()
  @IsInt()
  @Min(0)
  oldElectric!: number;

  @ApiProperty()
  @IsInt()
  @Min(0)
  newElectric!: number;

  @ApiProperty()
  @IsInt()
  @Min(0)
  oldWater!: number;

  @ApiProperty()
  @IsInt()
  @Min(0)
  newWater!: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  source?: string;
}
