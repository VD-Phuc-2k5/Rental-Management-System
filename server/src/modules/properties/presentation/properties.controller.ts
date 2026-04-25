import { BadRequestException, Body, Controller, InternalServerErrorException, Post, UseGuards } from "@nestjs/common";
import { CreatePropertiesService } from "../application/services/create-properties.service";
import { PropertiesEntity } from "../domain/entities/properties.entity";
import { CreatePropertiesDto } from "../application/dto/create-properties.dto";
import { PropertiesCannotBeCreatedError } from "../domain/errors/properties.error";
import { LandlordNotFoundError } from "../domain/errors/properties.error";
import { AuthGuard } from "src/shared/common/guards/auth.guard";
import { RolesGuard } from "src/shared/common/guards/roles.guard";
import { Roles } from "src/shared/common/decorators/roles.decorator";
import { CurrentUser } from "src/shared/common/decorators/current-user.decorator";
import { UserDTO } from "src/shared/dto/user.dto";

@Controller("properties")
export class PropertiesController {
  constructor(
    private readonly createPropertiesService: CreatePropertiesService
  ) {}

  @UseGuards(AuthGuard, RolesGuard)
  @Roles("landlord")
  @Post()
  async createProperty(
    @Body() input: CreatePropertiesDto,
    @CurrentUser() currentUser: UserDTO,
  ) {
    try {
      const property= await this.createPropertiesService.execute({
        ...input,
        landlorerId: currentUser.id,
      });

      return {
        ...property,
        landlored: currentUser
      }
    } catch (error) {
      if (error instanceof LandlordNotFoundError) {
        throw new BadRequestException(error.message);
      }
      if (error instanceof PropertiesCannotBeCreatedError) {
        throw new BadRequestException(error.message);
      }
      throw new InternalServerErrorException();
    }
  }
}