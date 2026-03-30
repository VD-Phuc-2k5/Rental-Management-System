import { Controller, Post, Body, Get, Param } from "@nestjs/common";
import { CreateUserService } from "../application/services/create-user.service";
import { CreateUserDto } from "../application/dto/create-user.dto";
import { FindUserService } from "../application/services/find-user.service";

@Controller("users")
export class UsersController {
  constructor(
    private readonly createUser: CreateUserService,
    private readonly findUser: FindUserService
  ) {}

  @Post()
  async create(@Body() body: CreateUserDto) {
    return this.createUser.execute(body);
  }

  @Get(":id")
  async findById(@Param("id") id: string) {
    return this.findUser.execute(id);
  }
}