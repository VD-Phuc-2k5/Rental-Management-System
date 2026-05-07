import { BadRequestException, Body, Controller, InternalServerErrorException, Post, UseGuards } from "@nestjs/common";
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
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

@ApiTags('properties')
@Controller("properties")
export class PropertiesController {
  constructor(
    private readonly createPropertiesService: CreatePropertiesService
  ) {}

  @UseGuards(AuthGuard, RolesGuard)
  @Roles("landlord")
  @ApiBody({
    type: CreatePropertiesDto,
    examples: {
      createProperty: {
        value: {
          name: 'Nha tro Hoa Phuong',
          address: '12 Nguyen Trai',
          ward: 'Phuong 5',
          district: 'Quan 3',
          city: 'TP Ho Chi Minh',
          description: 'Khu tro an ninh, gan truong hoc.',
          amenityCodes: ['WIFI', 'AIR_CONDITIONER'],
        },
      },
    },
  })
  @ApiResponse({
    status: 201,
    description: 'Success',
    schema: {
      example: {
        statusCode: 201,
        message: 'Success',
        data: {
          id: '2c1d4e31-2c7f-4b5c-b6a2-7c1a8b24c73d',
          landlorerId: 'a4b91c1b-7ed5-4d8e-b17f-2b6f6bb0f2c1',
          name: 'Nha tro Hoa Phuong',
          address: '12 Nguyen Trai',
          ward: 'Phuong 5',
          district: 'Quan 3',
          city: 'TP Ho Chi Minh',
          description: 'Khu tro an ninh, gan truong hoc.',
          amenityCodes: ['WIFI', 'AIR_CONDITIONER'],
          createdAt: '2026-05-06T10:12:00.000Z',
          updatedAt: '2026-05-06T10:12:00.000Z',
          landlored: {
            id: 'a4b91c1b-7ed5-4d8e-b17f-2b6f6bb0f2c1',
            email: 'landlord@example.com',
            phone: '0912345678',
            full_name: 'Le Van C',
            avartar_url: null,
            roles: ['landlord'],
          },
        },
      },
    },
  })
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