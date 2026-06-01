import { Controller, Get, Patch, Body, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { GetProfileService } from '../application/services/get-profile.service';
import { UpdateProfileService } from '../application/services/update-profile.service';
import { UpdateProfileDto } from '../application/dto/update-profile.dto';
import { ProfileResponseDto } from '../application/dto/profile-response.dto';
import { AuthGuard } from '../../../shared/common/guards/auth.guard';
import { CurrentUser } from '../../../shared/common/decorators/current-user.decorator';
import { UserDTO } from '../../../shared/dto/user.dto';

@ApiTags('profile')
@Controller('profile')
@UseGuards(AuthGuard)
export class ProfileController {
  constructor(
    private readonly getProfile: GetProfileService,
    private readonly updateProfile: UpdateProfileService,
  ) {}

  @Get()
  async getMyProfile(
    @CurrentUser() currentUser: UserDTO,
  ): Promise<ProfileResponseDto> {
    const entity = await this.getProfile.execute(currentUser.id);
    return ProfileResponseDto.from(entity, currentUser);
  }

  @Patch()
  async updateMyProfile(
    @Body() dto: UpdateProfileDto,
    @CurrentUser() currentUser: UserDTO,
  ): Promise<ProfileResponseDto> {
    const entity = await this.updateProfile.execute(currentUser.id, dto);
    return ProfileResponseDto.from(entity, currentUser);
  }
}
