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

export class RegisterDto {
  @IsEmail()
  @IsNotEmpty()
  email!: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(2)
  @MaxLength(100)
  @Matches(/\S/, { message: 'Tên không được chứa khoảng trắng' })
  fullName!: string;

  @IsString()
  @Length(10, 15)
  @Matches(/^[0-9]+$/, { message: 'Số điện thoại chỉ được chứa chữ số' })
  @IsOptional()
  phone: string | null = null;

  @IsOptional()
  @IsUrl({ require_tld: false })
  avatarUrl?: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  @MaxLength(72)
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).+$/, {
    message: 'Mật khẩu phải có chữ hoa, chữ thường, số và ký tự đặc biệt',
  })
  password!: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  @MaxLength(72)
  confirm_password!: string;

  @IsBoolean()
  @IsNotEmpty()
  accepted_terms!: boolean;
}
