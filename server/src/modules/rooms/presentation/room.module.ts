import { Module } from "@nestjs/common";
import { DrizzleModule } from "src/shared/infrastructure/database/drizzle.module";
import { SupabaseModule } from "src/shared/infrastructure/supabase/supabase.module";
import { AuthGuard } from "src/shared/common/guards/auth.guard";
import { RolesGuard } from "src/shared/common/guards/roles.guard";
import { PropertiesModule } from "src/modules/properties/presentation/properties.module";
import { RoomController } from "./room.controller";
import { BrowseRoomController } from "./browse-room.controller";
import { DrizzleRoomRepository } from "../infrastructure/drizzle-room.repository";
import { DrizzleBrowseRoomRepository } from "../infrastructure/drizzle-browse-room.repository";
import { RoomRepository } from "../domain/repositories/room.repository";
import { BrowseRoomRepository } from "../domain/repositories/browse-room.repository";
import { CreateRoomService } from "../application/services/create-room.service";
import { GetRoomsService } from "../application/services/get-rooms.service";
import { GetRoomByIdService } from "../application/services/get-room-by-id.service";
import { UpdateRoomService } from "../application/services/update-room.service";
import { DeleteRoomService } from "../application/services/delete-room.service";
import { GetAvailableRoomsService } from "../application/services/get-available-rooms.service";
import { GetBrowseRoomDetailService } from "../application/services/get-browse-room-detail.service";

@Module({
    imports: [DrizzleModule, SupabaseModule, PropertiesModule],
    controllers: [RoomController, BrowseRoomController],
    providers: [
        CreateRoomService, GetRoomsService, GetRoomByIdService, UpdateRoomService, DeleteRoomService,
        GetAvailableRoomsService, GetBrowseRoomDetailService,
        AuthGuard, RolesGuard,
        { provide: RoomRepository, useClass: DrizzleRoomRepository },
        { provide: BrowseRoomRepository, useClass: DrizzleBrowseRoomRepository },
    ],
})
export class RoomsModule {}
