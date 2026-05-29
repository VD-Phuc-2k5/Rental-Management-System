import { IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export enum MaintenanceStatusDto {
  pending = 'pending',
  processing = 'processing',
  completed = 'completed',
  rejected = 'rejected',
}

export class UpdateMaintenanceStatusDto {
  @ApiProperty({ enum: MaintenanceStatusDto })
  @IsEnum(MaintenanceStatusDto)
  status!: MaintenanceStatusDto;
}