import {
    BadRequestException, Body, Controller, Delete, Get, InternalServerErrorException,
    NotFoundException, Param, Patch, Post, UseGuards
} from "@nestjs/common";
import { ApiBody, ApiResponse, ApiTags } from "@nestjs/swagger";
import { CreateRoomService } from "../application/services/create-room.service";
import { GetRoomsService } from "../application/services/get-rooms.service";
import { GetRoomByIdService } from "../application/services/get-room-by-id.service";
import { UpdateRoomService } from "../application/services/update-room.service";
import { DeleteRoomService } from "../application/services/delete-room.service";
import { CreateRoomDto } from "../application/dto/create-room.dto";
import { UpdateRoomDto } from "../application/dto/update-room.dto";
import { AuthGuard } from "src/shared/common/guards/auth.guard";
import { RolesGuard } from "src/shared/common/guards/roles.guard";
import { Roles } from "src/shared/common/decorators/roles.decorator";
import { CurrentUser } from "src/shared/common/decorators/current-user.decorator";
import { UserDTO } from "src/shared/dto/user.dto";

@ApiTags("rooms")
@Controller()
@UseGuards(AuthGuard, RolesGuard)
@Roles("landlord")
export class RoomController {
    constructor(
        private readonly createRoomService: CreateRoomService,
        private readonly getRoomsService: GetRoomsService,
        private readonly getRoomByIdService: GetRoomByIdService,
        private readonly updateRoomService: UpdateRoomService,
        private readonly deleteRoomService: DeleteRoomService,
    ) {}

    @Post("properties/:propertyId/rooms")
    @ApiBody({ type: CreateRoomDto })
    @ApiResponse({ status: 201 })
    async createRoom(
        @Param("propertyId") propertyId: string,
        @Body() dto: CreateRoomDto,
        @CurrentUser() currentUser: UserDTO,
    ) {
        try {
            return await this.createRoomService.execute(propertyId, currentUser.id, dto);
        } catch (error) {
            if (error instanceof NotFoundException) throw error;
            if (error instanceof BadRequestException) throw error;
            throw new InternalServerErrorException();
        }
    }

    @Get("properties/:propertyId/rooms")
    @ApiResponse({ status: 200 })
    async getRooms(@Param("propertyId") propertyId: string) {
        return this.getRoomsService.execute(propertyId);
    }

    @Get("rooms/:id")
    @ApiResponse({ status: 200 })
    async getRoomById(@Param("id") id: string) {
        try {
            return await this.getRoomByIdService.execute(id);
        } catch (error) {
            if (error instanceof NotFoundException) throw error;
            throw new InternalServerErrorException();
        }
    }

    @Patch("rooms/:id")
    @ApiBody({ type: UpdateRoomDto })
    @ApiResponse({ status: 200 })
    async updateRoom(@Param("id") id: string, @Body() dto: UpdateRoomDto) {
        try {
            return await this.updateRoomService.execute(id, dto);
        } catch (error) {
            if (error instanceof NotFoundException) throw error;
            throw new InternalServerErrorException();
        }
    }

    @Delete("rooms/:id")
    @ApiResponse({ status: 200 })
    async deleteRoom(@Param("id") id: string) {
        try {
            await this.deleteRoomService.execute(id);
        } catch (error) {
            if (error instanceof NotFoundException) throw error;
            throw new InternalServerErrorException();
        }
    }
}
