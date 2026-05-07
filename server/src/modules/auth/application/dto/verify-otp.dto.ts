import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, Length, Matches } from 'class-validator';

export class VerifyOtpDto {
  @IsEmail()
  @IsNotEmpty()
  @ApiProperty({ example: 'tenant@example.com' })
  email!: string;

  @IsString()
  @Length(6, 6)
  @Matches(/^[0-9]+$/, { message: 'OTP chỉ gồm 6 ký tự số' })
  @ApiProperty({ example: '123456' })
  otp!: string;
}
