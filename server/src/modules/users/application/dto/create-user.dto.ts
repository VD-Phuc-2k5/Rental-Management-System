import { IsEmail, IsNotEmpty, IsString, Length } from "class-validator";

export class CreateUserDto {
    @IsNotEmpty()
    @IsString()
    @Length(6, 20)
    firstName: string;

    @IsNotEmpty()
    @IsString()
    @Length(6, 20)
    lastName: string;

    @IsEmail()
    @IsNotEmpty()
    email: string;


}

