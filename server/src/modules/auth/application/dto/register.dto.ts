import {
  IsBoolean,
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUrl,
  Length,
  Matches,
  MaxLength,
  MinLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RegisterDto {
  @IsEmail()
  @IsNotEmpty()
  @ApiProperty({ example: 'tenant@example.com' })
  email!: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(2)
  @MaxLength(100)
  @Matches(/\S/, { message: 'Tên không được chứa khoảng trắng' })
  @ApiProperty({ example: 'Tran Thi B' })
  fullName!: string;

  @IsString()
  @Length(10, 15)
  @Matches(/^[0-9]+$/, { message: 'Số điện thoại chỉ được chứa chữ số' })
  @IsOptional()
  @ApiPropertyOptional({ example: '0912345678' })
  phone: string | null = null;

  @IsOptional()
  @IsUrl({ require_tld: false })
  @ApiPropertyOptional({ example: 'https://example.com/avatar.png' })
  avatarUrl?: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  @MaxLength(72)
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).+$/, {
    message: 'Mật khẩu phải có chữ hoa, chữ thường, số và ký tự đặc biệt',
  })
  @ApiProperty({ example: 'Aa123456!' })
  password!: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  @MaxLength(72)
  @ApiProperty({ example: 'Aa123456!' })
  confirm_password!: string;

  @IsBoolean()
  @IsNotEmpty()
  @ApiProperty({ example: true })
  accepted_terms!: boolean;
}
