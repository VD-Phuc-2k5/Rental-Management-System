import { Inject, NotFoundException } from "@nestjs/common";
import { RoomRepository } from "../../domain/repositories/room.repository";
import { RoomEntity } from "../../domain/entities/room.entity";

export class GetRoomByIdService {
    constructor(@Inject(RoomRepository) private readonly roomRepository: RoomRepository) {}
    async execute(id: string): Promise<RoomEntity> {
        const room = await this.roomRepository.findById(id);
        if (!room) throw new NotFoundException("Phong khong ton tai");
        return room;
    }
}
