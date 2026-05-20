import {
	IsEmail,
	IsNotEmpty,
	IsOptional,
	IsString,
	IsUrl,
	Length,
	Matches,
	MaxLength,
	MinLength,
} from "class-validator";
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateUserDto {
	@IsEmail()
	@IsNotEmpty()
	@ApiProperty({ example: 'user@example.com' })
	email: string;

	@IsString()
	@IsNotEmpty()
	@MinLength(2)
	@MaxLength(100)
	@Matches(/\S/, { message: "Tên không được chứa khoảng trắng" })
	@ApiProperty({ example: 'Nguyen Van A' })
	fullName: string;

	@IsString()
	@IsNotEmpty()
	@Length(10, 15)
	@Matches(/^[0-9]+$/, { message: "Số điện thoại chỉ được chứa chữ số" })
	@ApiProperty({ example: '0987654321' })
	phone: string;

	@IsOptional()
	@IsUrl({ require_tld: false })
	@ApiPropertyOptional({ example: 'https://example.com/avatar.png' })
	avatarUrl?: string;
}

