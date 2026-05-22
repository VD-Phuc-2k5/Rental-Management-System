import {
  Controller,
  Get,
  InternalServerErrorException,
  NotFoundException,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { GetAvailableRoomsService } from '../application/services/get-available-rooms.service';
import { GetBrowseRoomDetailService } from '../application/services/get-browse-room-detail.service';

@ApiTags('browse')
@Controller('browse')
@UseGuards(AuthGuard)
export class BrowseRoomController {
  constructor(
    private readonly getAvailableRoomsService: GetAvailableRoomsService,
    private readonly getBrowseRoomDetailService: GetBrowseRoomDetailService,
  ) {}

  @Get('rooms')
  @ApiQuery({ name: 'minRent', required: false, type: Number })
  @ApiQuery({ name: 'maxRent', required: false, type: Number })
  @ApiResponse({ status: 200 })
  async getAvailableRooms(
    @Query('minRent') minRent?: string,
    @Query('maxRent') maxRent?: string,
  ) {
    return this.getAvailableRoomsService.execute({
      minRent: minRent !== undefined ? Number(minRent) : undefined,
      maxRent: maxRent !== undefined ? Number(maxRent) : undefined,
    });
  }

  @Get('rooms/:id')
  @ApiResponse({ status: 200 })
  async getRoomDetail(@Param('id') id: string) {
    try {
      return await this.getBrowseRoomDetailService.execute(id);
    } catch (error) {
      if (error instanceof NotFoundException) throw error;
      throw new InternalServerErrorException();
    }
  }
}
