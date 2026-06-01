import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsArray,
  IsOptional,
  IsString,
  IsUrl,
  MinLength,
} from 'class-validator';

export class SubmitMaintenanceComplaintDto {
  @ApiProperty()
  @IsString()
  @MinLength(3)
  complaintDescription!: string;

  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @IsUrl({}, { each: true })
  complaintImageUrls?: string[];
}
