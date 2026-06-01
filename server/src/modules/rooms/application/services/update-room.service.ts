import { Inject, NotFoundException } from "@nestjs/common";
import { RoomRepository } from "../../domain/repositories/room.repository";
import { UpdateRoomDto } from "../dto/update-room.dto";
import { RoomEntity } from "../../domain/entities/room.entity";

export class UpdateRoomService {
    constructor(@Inject(RoomRepository) private readonly roomRepository: RoomRepository) {}
    async execute(id: string, dto: UpdateRoomDto): Promise<RoomEntity> {
        const room = await this.roomRepository.findById(id);
        if (!room) throw new NotFoundException("Phong khong ton tai");
        return this.roomRepository.updateRoom(id, dto);
    }
}
