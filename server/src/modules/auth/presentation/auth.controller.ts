import { Body, Controller, Post } from '@nestjs/common';
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { RegisterDto } from '../application/dto/register.dto';
import { LoginDto } from '../application/dto/login.dto';
import { RegisterService } from '../application/services/register.service';
import { LoginService } from '../application/services/login.service';
import { ForgotPasswordDto } from '../application/dto/forgot-password.dto';
import { ResetPasswordDto } from '../application/dto/reset-password.dto';
import { RequestPasswordResetService } from '../application/services/request-password-reset.service';
import { ResetPasswordService } from '../application/services/reset-password.service';
import { VerifyOtpDto } from '../application/dto/verify-otp.dto';
import { VerifyOtpService } from '../application/services/verify-otp.service';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly registerService: RegisterService,
    private readonly loginService: LoginService,
    private readonly requestPasswordResetService: RequestPasswordResetService,
    private readonly resetPasswordService: ResetPasswordService,
    private readonly verifyOtpService: VerifyOtpService,
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

  @Post('forgot-password')
  @ApiBody({
    type: ForgotPasswordDto,
    examples: {
      forgotPassword: {
        value: {
          email: 'tenant@example.com',
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
          message: 'Neu email ton tai, ma OTP da duoc gui',
        },
      },
    },
  })
  async forgotPassword(@Body() body: ForgotPasswordDto) {
    return this.requestPasswordResetService.execute(body);
  }

  @Post('reset-password')
  @ApiBody({
    type: ResetPasswordDto,
    examples: {
      resetPassword: {
        value: {
          email: 'tenant@example.com',
          otp: '123456',
          newPassword: 'Aa123456!',
          confirmPassword: 'Aa123456!',
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
          message: 'Dat lai mat khau thanh cong',
        },
      },
    },
  })
  async resetPassword(@Body() body: ResetPasswordDto) {
    return this.resetPasswordService.execute(body);
  }

  @Post('confirm-otp')
  @ApiBody({
    type: VerifyOtpDto,
    examples: {
      confirmOtp: {
        value: {
          email: 'tenant@example.com',
          otp: '123456',
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
          message: 'OTP hop le',
        },
      },
    },
  })
  async confirmOtp(@Body() body: VerifyOtpDto) {
    return this.verifyOtpService.execute(body);
  }
}
