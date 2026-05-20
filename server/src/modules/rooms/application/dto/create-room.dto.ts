import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateRoomDTO {
    @ApiProperty({ example: 'c8b5b7f2-1c9a-4c72-8b91-ff3f69e0f79f' })
    proertyId!: string;

    @ApiProperty({ example: 'Phong 201 - Tang 2' })
    title!: string;

    @ApiProperty({ example: 22 })
    area_sqm!: number;

    @ApiProperty({ example: 3500000 })
    monthly_rent!: number;

    @ApiProperty({ example: 3500000 })
    deposit_amount!: number;

    @ApiProperty({ example: 3500 })
    electricity_rate_per_kwh!: number;

    @ApiProperty({ example: 18000 })
    water_rate_per_m3!: number;

    @ApiProperty({ example: true })
    has_furniture!: boolean;

    @ApiPropertyOptional({ example: 'Phong co ban cong, thoang mat.' })
    description?: string;
}