import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, Length, Matches, MaxLength, MinLength } from 'class-validator';

export class ResetPasswordDto {
  @IsEmail()
  @IsNotEmpty()
  @ApiProperty({ example: 'tenant@example.com' })
  email!: string;

  @IsString()
  @Length(6, 6)
  @Matches(/^[0-9]+$/, { message: 'OTP chỉ gồm chữ số' })
  @ApiProperty({ example: '123456' })
  otp!: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  @MaxLength(72)
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).+$/, {
    message: 'Mật khẩu phải có chữ hoa, chữ thường, số và ký tự đặc biệt',
  })
  @ApiProperty({ example: 'Aa123456!' })
  newPassword!: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  @MaxLength(72)
  @ApiProperty({ example: 'Aa123456!' })
  confirmPassword!: string;
}
