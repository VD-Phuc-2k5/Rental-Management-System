import { Controller, Post, Body } from "@nestjs/common";
import { CreateUserService } from "../application/services/create-user.service";
import { CreateUserDto } from "../application/dto/create-user.dto";

@Controller("users")
export class UsersController {
  constructor(private readonly createUser: CreateUserService) {}

  @Post()
  async create(@Body() body: CreateUserDto) {
    return this.createUser.execute(body);
  }
}