import {
  IsISO8601,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
} from 'class-validator';

export class CreateViewingAppointmentDto {
  @IsUUID()
  @IsNotEmpty()
  roomId: string;

  @IsISO8601()
  @IsNotEmpty()
  scheduledAt: string;

  @IsString()
  @IsOptional()
  note?: string;
}
