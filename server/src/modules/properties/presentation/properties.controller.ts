import {
    BadRequestException, Body, Controller, Delete, Get, InternalServerErrorException,
    NotFoundException, Param, Patch, Post, UseGuards
} from "@nestjs/common";
import { ApiBody, ApiResponse, ApiTags } from "@nestjs/swagger";
import { CreatePropertiesService } from "../application/services/create-properties.service";
import { GetPropertiesService } from "../application/services/get-properties.service";
import { GetPropertyByIdService } from "../application/services/get-property-by-id.service";
import { UpdatePropertiesService } from "../application/services/update-properties.service";
import { DeletePropertiesService } from "../application/services/delete-properties.service";
import { CreatePropertiesDto } from "../application/dto/create-properties.dto";
import { UpdatePropertiesDto } from "../application/dto/update-properties.dto";
import { LandlordNotFoundError, PropertiesCannotBeCreatedError } from "../domain/errors/properties.error";
import { AuthGuard } from "src/shared/common/guards/auth.guard";
import { RolesGuard } from "src/shared/common/guards/roles.guard";
import { Roles } from "src/shared/common/decorators/roles.decorator";
import { CurrentUser } from "src/shared/common/decorators/current-user.decorator";
import { UserDTO } from "src/shared/dto/user.dto";

@ApiTags("properties")
@Controller("properties")
@UseGuards(AuthGuard, RolesGuard)
@Roles("landlord")
export class PropertiesController {
    constructor(
        private readonly createPropertiesService: CreatePropertiesService,
        private readonly getPropertiesService: GetPropertiesService,
        private readonly getPropertyByIdService: GetPropertyByIdService,
        private readonly updatePropertiesService: UpdatePropertiesService,
        private readonly deletePropertiesService: DeletePropertiesService,
    ) {}

    @Post()
    @ApiBody({ type: CreatePropertiesDto })
    @ApiResponse({ status: 201, description: "Created" })
    async createProperty(@Body() input: CreatePropertiesDto, @CurrentUser() currentUser: UserDTO) {
        try {
            const property = await this.createPropertiesService.execute({ ...input, landlorerId: currentUser.id });
            return { ...property, landlored: currentUser };
        } catch (error) {
            if (error instanceof LandlordNotFoundError) throw new BadRequestException(error.message);
            if (error instanceof PropertiesCannotBeCreatedError) throw new BadRequestException(error.message);
            throw new InternalServerErrorException();
        }
    }

    @Get()
    @ApiResponse({ status: 200, description: "List of landlord properties" })
    async getProperties(@CurrentUser() currentUser: UserDTO) {
        return this.getPropertiesService.execute(currentUser.id);
    }

    @Get(":id")
    @ApiResponse({ status: 200, description: "Property detail" })
    async getPropertyById(@Param("id") id: string, @CurrentUser() currentUser: UserDTO) {
        try {
            return await this.getPropertyByIdService.execute(id, currentUser.id);
        } catch (error) {
            if (error instanceof NotFoundException) throw error;
            throw new InternalServerErrorException();
        }
    }

    @Patch(":id")
    @ApiBody({ type: UpdatePropertiesDto })
    @ApiResponse({ status: 200, description: "Updated" })
    async updateProperty(
        @Param("id") id: string,
        @Body() input: UpdatePropertiesDto,
        @CurrentUser() currentUser: UserDTO,
    ) {
        try {
            return await this.updatePropertiesService.execute(id, currentUser.id, input);
        } catch (error) {
            if (error instanceof NotFoundException) throw error;
            if (error instanceof BadRequestException) throw error;
            throw new InternalServerErrorException();
        }
    }

    @Delete(":id")
    @ApiResponse({ status: 200, description: "Deleted" })
    async deleteProperty(@Param("id") id: string, @CurrentUser() currentUser: UserDTO) {
        try {
            await this.deletePropertiesService.execute(id, currentUser.id);
        } catch (error) {
            if (error instanceof NotFoundException) throw error;
            throw new InternalServerErrorException();
        }
    }
}
