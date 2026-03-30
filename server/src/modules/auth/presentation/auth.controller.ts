import { Body, Controller, Post } from '@nestjs/common';
import { RegisterDto } from '../application/dto/register.dto';
import { LoginDto } from '../application/dto/login.dto';
import { RegisterService } from '../application/services/register.service';
import { LoginService } from '../application/services/login.service';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly registerService: RegisterService,
    private readonly loginService: LoginService,
  ) {}

  @Post('register')
  async register(@Body() body: RegisterDto) {
    return this.registerService.execute(body);
  }

  @Post('login')
  async login(@Body() body: LoginDto) {
    const { email, password } = body;
    return this.loginService.execute(email, password); 
  }
}
