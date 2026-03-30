import { Body, Controller, Post } from '@nestjs/common';
import { RegisterDto } from '../application/dto/register.dto';
import { RegisterService } from '../application/services/register.service';

@Controller('auth')
export class AuthController {
  constructor(private readonly registerService: RegisterService) {}

  @Post('register')
  async register(@Body() body: RegisterDto) {
    return this.registerService.execute(body);
  }
}
