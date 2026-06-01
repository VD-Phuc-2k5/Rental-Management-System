import {
  IsString,
  IsOptional,
  IsDateString,
  IsNumberString,
} from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateContractDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumberString()
  monthlyRent?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsNumberString()
  deposit?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  terms?: string;
}
