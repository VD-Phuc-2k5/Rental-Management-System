import { IsBoolean, IsNotEmpty, IsNumber, IsOptional, IsString, Min } from "class-validator";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { Type } from "class-transformer";

export class CreateRoomDto {
    @IsNotEmpty() @IsString() @ApiProperty({ example: "Phong 101" })
    title!: string;

    @IsNotEmpty() @IsNumber() @Min(0) @Type(() => Number) @ApiProperty({ example: 25 })
    area_sqm!: number;

    @IsNotEmpty() @IsNumber() @Min(0) @Type(() => Number) @ApiProperty({ example: 3000000 })
    monthly_rent!: number;

    @IsNotEmpty() @IsNumber() @Min(0) @Type(() => Number) @ApiProperty({ example: 6000000 })
    deposit_amount!: number;

    @IsNotEmpty() @IsNumber() @Min(0) @Type(() => Number) @ApiProperty({ example: 3500 })
    electricity_rate_per_kwh!: number;

    @IsNotEmpty() @IsNumber() @Min(0) @Type(() => Number) @ApiProperty({ example: 15000 })
    water_rate_per_m3!: number;

    @IsNotEmpty() @IsBoolean() @ApiProperty({ example: true })
    has_furniture!: boolean;

    @IsOptional() @IsString() @ApiPropertyOptional({ example: "Phong sang, thoang mat" })
    description?: string;
}
