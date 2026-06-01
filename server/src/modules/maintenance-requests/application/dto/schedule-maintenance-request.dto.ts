import { IsDateString, IsOptional, IsString } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class ScheduleMaintenanceRequestDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  technicianName?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  technicianPhone?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  scheduledAt?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  landlordNote?: string;
}