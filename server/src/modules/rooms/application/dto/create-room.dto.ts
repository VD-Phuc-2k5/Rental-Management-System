export class CreateRoomDTO {
    proertyId!: string;
    title!: string;
    area_sqm!: number;
    monthly_rent!: number;
    deposit_amount!: number;
    electricity_rate_per_kwh!: number;
    water_rate_per_m3!: number;
    has_furniture!: boolean;
    description?: string;
}