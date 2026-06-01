import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsOptional } from 'class-validator';

export class FinalizeInvoiceDto {
  @ApiPropertyOptional({ example: '2026-06-05' })
  @IsOptional()
  @IsDateString()
  dueDate?: string;
}
