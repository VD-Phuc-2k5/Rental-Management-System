import { Inject, NotFoundException } from "@nestjs/common";
import { RoomRepository } from "../../domain/repositories/room.repository";

export class DeleteRoomService {
    constructor(@Inject(RoomRepository) private readonly roomRepository: RoomRepository) {}
    async execute(id: string): Promise<void> {
        const room = await this.roomRepository.findById(id);
        if (!room) throw new NotFoundException("Phong khong ton tai");
        await this.roomRepository.deleteRoom(id);
    }
}
