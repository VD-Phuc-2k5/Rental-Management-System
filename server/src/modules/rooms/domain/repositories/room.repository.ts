import { RoomEntity, RoomStatus } from "../entities/room.entity";

export type CreateRoomInput = {
    propertyId: string;
    title: string;
    area_sqm: number;
    monthly_rent: number;
    deposit_amount: number;
    electricity_rate_per_kwh: number;
    water_rate_per_m3: number;
    has_furniture: boolean;
    description?: string;
};

export type UpdateRoomInput = {
    title?: string;
    status?: RoomStatus;
    area_sqm?: number;
    monthly_rent?: number;
    deposit_amount?: number;
    electricity_rate_per_kwh?: number;
    water_rate_per_m3?: number;
    has_furniture?: boolean;
    description?: string;
};

export abstract class RoomRepository {
    abstract createRoom(input: CreateRoomInput): Promise<RoomEntity>;
    abstract findAllByPropertyId(propertyId: string): Promise<RoomEntity[]>;
    abstract findById(id: string): Promise<RoomEntity | null>;
    abstract updateRoom(id: string, input: UpdateRoomInput): Promise<RoomEntity>;
    abstract deleteRoom(id: string): Promise<void>;
}
