import { Controller, Post, Body, Get, Param } from "@nestjs/common";
import { ApiResponse, ApiTags } from '@nestjs/swagger';
import { CreateUserService } from "../application/services/create-user.service";
import { CreateUserDto } from "../application/dto/create-user.dto";
import { FindUserService } from "../application/services/find-user.service";

@ApiTags('users')
@Controller("users")
export class UsersController {
  constructor(
    private readonly findUser: FindUserService
  ) {}

  @Get(":id")
  @ApiResponse({
    status: 200,
    description: 'Success',
    schema: {
      example: {
        statusCode: 200,
        message: 'Success',
        data: {
          id: '3d2b765f-3f41-4a36-9f04-742c339b49b5',
          phone: '0912345678',
          fullName: 'Tran Thi B',
          avatarUrl: 'https://example.com/avatar.png',
          role: ['tenant'],
          createdAt: '2026-05-06T10:12:00.000Z',
          updatedAt: '2026-05-06T10:12:00.000Z',
          acceptedTerms: true,
        },
      },
    },
  })
  async findById(@Param("id") id: string) {
    return this.findUser.execute(id);
  }
}