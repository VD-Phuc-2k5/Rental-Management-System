import { Module } from "@nestjs/common";
import { DrizzleModule } from "src/shared/infrastructure/database/drizzle.module";
import { SupabaseModule } from "src/shared/infrastructure/supabase/supabase.module";
import { AuthGuard } from "src/shared/common/guards/auth.guard";
import { RolesGuard } from "src/shared/common/guards/roles.guard";
import { PropertiesModule } from "src/modules/properties/presentation/properties.module";
import { RoomController } from "./room.controller";
import { DrizzleRoomRepository } from "../infrastructure/drizzle-room.repository";
import { RoomRepository } from "../domain/repositories/room.repository";
import { CreateRoomService } from "../application/services/create-room.service";
import { GetRoomsService } from "../application/services/get-rooms.service";
import { GetRoomByIdService } from "../application/services/get-room-by-id.service";
import { UpdateRoomService } from "../application/services/update-room.service";
import { DeleteRoomService } from "../application/services/delete-room.service";

@Module({
    imports: [DrizzleModule, SupabaseModule, PropertiesModule],
    controllers: [RoomController],
    providers: [
        CreateRoomService, GetRoomsService, GetRoomByIdService, UpdateRoomService, DeleteRoomService,
        AuthGuard, RolesGuard,
        { provide: RoomRepository, useClass: DrizzleRoomRepository },
    ],
})
export class RoomsModule {}
