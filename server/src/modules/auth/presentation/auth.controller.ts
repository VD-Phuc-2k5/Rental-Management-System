import { Body, Controller, Post } from '@nestjs/common';
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { RegisterDto } from '../application/dto/register.dto';
import { LoginDto } from '../application/dto/login.dto';
import { RegisterService } from '../application/services/register.service';
import { LoginService } from '../application/services/login.service';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly registerService: RegisterService,
    private readonly loginService: LoginService,
  ) {}

  @Post('register')
  @ApiBody({
    type: RegisterDto,
    examples: {
      register: {
        value: {
          email: 'tenant@example.com',
          fullName: 'Tran Thi B',
          phone: '0912345678',
          avatarUrl: 'https://example.com/avatar.png',
          password: 'Aa123456!',
          confirm_password: 'Aa123456!',
          accepted_terms: true,
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
          id: '3d2b765f-3f41-4a36-9f04-742c339b49b5',
          email: 'tenant@example.com',
          profile: {
            phone: '0912345678',
            fullName: 'Tran Thi B',
            avatarUrl: 'https://example.com/avatar.png',
          },
          role: 'tenant',
        },
      },
    },
  })
  async register(@Body() body: RegisterDto) {
    return this.registerService.execute(body);
  }

  @Post('login')
  @ApiBody({
    type: LoginDto,
    examples: {
      login: {
        value: {
          email: 'tenant@example.com',
          password: 'Aa123456!',
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
          token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
          user: {
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
    },
  })
  async login(@Body() body: LoginDto) {
    const { email, password } = body;
    return this.loginService.execute(email, password); 
  }
}
