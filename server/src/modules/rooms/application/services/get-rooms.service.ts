import { Inject } from "@nestjs/common";
import { RoomRepository } from "../../domain/repositories/room.repository";
import { RoomEntity } from "../../domain/entities/room.entity";

export class GetRoomsService {
    constructor(@Inject(RoomRepository) private readonly roomRepository: RoomRepository) {}
    async execute(propertyId: string): Promise<RoomEntity[]> {
        return this.roomRepository.findAllByPropertyId(propertyId);
    }
}
