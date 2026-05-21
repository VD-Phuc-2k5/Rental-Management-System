import { IsOptional, IsString } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  @ApiPropertyOptional({ example: 'Nguyễn Văn A' })
  fullName?: string;

  @IsOptional()
  @IsString()
  @ApiPropertyOptional({ example: '0912345678' })
  phone?: string;

  @IsOptional()
  @IsString()
  @ApiPropertyOptional({ example: 'https://example.com/avatar.png' })
  avatarUrl?: string;

  @IsOptional()
  @IsString()
  @ApiPropertyOptional({ example: '1990-01-15' })
  dateOfBirth?: string;
}
