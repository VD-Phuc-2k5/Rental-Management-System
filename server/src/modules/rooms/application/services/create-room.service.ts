import { Inject, NotFoundException } from "@nestjs/common";
import { RoomRepository, CreateRoomInput } from "../../domain/repositories/room.repository";
import { PropertiesRepository } from "src/modules/properties/domain/repositories/properties.repository";
import { RoomEntity } from "../../domain/entities/room.entity";
import { CreateRoomDto } from "../dto/create-room.dto";

export class CreateRoomService {
    constructor(
        @Inject(RoomRepository) private readonly roomRepository: RoomRepository,
        @Inject(PropertiesRepository) private readonly propertiesRepository: PropertiesRepository,
    ) {}

    async execute(propertyId: string, landlorerId: string, dto: CreateRoomDto): Promise<RoomEntity> {
        const property = await this.propertiesRepository.findById(propertyId);
        if (!property || property.landlorerId !== landlorerId) {
            throw new NotFoundException("Khu tro khong ton tai");
        }
        const input: CreateRoomInput = { propertyId, ...dto };
        return this.roomRepository.createRoom(input);
    }
}
