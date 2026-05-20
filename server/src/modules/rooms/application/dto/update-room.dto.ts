import { IsBoolean, IsEnum, IsNumber, IsOptional, IsString, Min } from "class-validator";
import { ApiPropertyOptional } from "@nestjs/swagger";
import { Type } from "class-transformer";

export type RoomStatus = "AVAILABLE" | "OCCUPIED" | "MAINTENANCE";

export class UpdateRoomDto {
    @IsOptional() @IsString() @ApiPropertyOptional({ example: "Phong 101" })
    title?: string;

    @IsOptional() @IsEnum(["AVAILABLE", "OCCUPIED", "MAINTENANCE"]) @ApiPropertyOptional()
    status?: RoomStatus;

    @IsOptional() @IsNumber() @Min(0) @Type(() => Number) @ApiPropertyOptional()
    area_sqm?: number;

    @IsOptional() @IsNumber() @Min(0) @Type(() => Number) @ApiPropertyOptional()
    monthly_rent?: number;

    @IsOptional() @IsNumber() @Min(0) @Type(() => Number) @ApiPropertyOptional()
    deposit_amount?: number;

    @IsOptional() @IsNumber() @Min(0) @Type(() => Number) @ApiPropertyOptional()
    electricity_rate_per_kwh?: number;

    @IsOptional() @IsNumber() @Min(0) @Type(() => Number) @ApiPropertyOptional()
    water_rate_per_m3?: number;

    @IsOptional() @IsBoolean() @ApiPropertyOptional()
    has_furniture?: boolean;

    @IsOptional() @IsString() @ApiPropertyOptional()
    description?: string;
}
