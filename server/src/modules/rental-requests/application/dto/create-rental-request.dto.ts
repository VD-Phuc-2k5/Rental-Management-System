import { IsString, IsOptional, IsUUID } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateRentalRequestDto {
  @ApiProperty()
  @IsUUID()
  roomId: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  note?: string;
}
