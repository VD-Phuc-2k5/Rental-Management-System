import { IsEmail, IsNotEmpty, IsOptional, IsString, Length } from "class-validator";

export class CreateUserDto {
	@IsString()
	@IsNotEmpty()
	@Length(36, 36)
	id: string;

	@IsEmail()
	email: string;

	@IsString()
	@IsNotEmpty()
	fullName: string;

	@IsString()
	@IsNotEmpty()
	phone: string;

	@IsOptional()
	@IsString()
	avatarUrl?: string;
}

