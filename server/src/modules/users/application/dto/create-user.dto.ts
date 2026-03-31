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

export class CreateUserDto {
	@IsEmail()
	@IsNotEmpty()
	email: string;

	@IsString()
	@IsNotEmpty()
	@MinLength(2)
	@MaxLength(100)
	@Matches(/\S/, { message: "Tên không được chứa khoảng trắng" })
	fullName: string;

	@IsString()
	@IsNotEmpty()
	@Length(10, 15)
	@Matches(/^[0-9]+$/, { message: "Số điện thoại chỉ được chứa chữ số" })
	phone: string;

	@IsOptional()
	@IsUrl({ require_tld: false })
	avatarUrl?: string;
}

