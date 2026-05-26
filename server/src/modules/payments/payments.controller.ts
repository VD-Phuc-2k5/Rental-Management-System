import {
  Body,
  Controller,
  Get,
  Logger,
  Query,
  Req,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import type { Request } from 'express';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { Roles } from 'src/shared/common/decorators/roles.decorator';
import { CurrentUser } from 'src/shared/common/decorators/current-user.decorator';
import { VnpayService } from './vnpay.service';
import { CreateDepositPaymentDto } from './dto/create-deposit-payment.dto';

interface VnpayIpnResponse {
  RspCode: string;
  Message: string;
}

@ApiTags('payments')
@Controller('payments')
export class PaymentsController {
  private readonly logger = new Logger('PaymentsController');

  constructor(private readonly vnpayService: VnpayService) {}

  @Post('vnpay/create-deposit')
  @UseGuards(AuthGuard, RolesGuard)
  @Roles('tenant')
  async createDepositPayment(
    @Body() dto: CreateDepositPaymentDto,
    @CurrentUser() user: { id: string },
    @Req() request: Request,
  ) {
    return this.vnpayService.createDepositPayment(
      dto.contractId,
      user.id,
      this.getClientIp(request),
    );
  }

  @Get('vnpay/ipn')
  async handleVnpayIpn(
    @Query() query: Record<string, string>,
  ): Promise<VnpayIpnResponse> {
    try {
      await this.vnpayService.handleIpn(query);
      return { RspCode: '00', Message: 'Confirm Success' };
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : String(error);
      this.logger.error(`VNPay IPN error: ${message}`);
      if (message === 'Invalid checksum') {
        return { RspCode: '97', Message: 'Invalid Checksum' };
      }
      return { RspCode: '99', Message: 'Unknown error' };
    }
  }

  @Get('vnpay/return')
  async handleVnpayReturn(@Query() query: Record<string, string>) {
    const result = this.vnpayService.verifyReturnQuery(query);

    if (!result.isVerified) {
      return {
        success: false,
        message: 'Invalid signature',
        responseCode: result.responseCode,
      };
    }

    if (result.isSuccess) {
      try {
        await this.vnpayService.finalizeReturn(query);
      } catch (error: unknown) {
        const message = error instanceof Error ? error.message : String(error);
        this.logger.warn(`VNPay return finalize skipped: ${message}`);
      }
      return {
        success: true,
        message: 'Payment successful',
        responseCode: result.responseCode,
        orderInfo: result.orderInfo,
      };
    }

    return {
      success: false,
      message: `Payment failed (code: ${result.responseCode})`,
      responseCode: result.responseCode,
    };
  }

  private getClientIp(request: Request): string {
    const forwardedFor = request.headers['x-forwarded-for'];
    if (typeof forwardedFor === 'string' && forwardedFor.trim().length > 0) {
      return forwardedFor.split(',')[0].trim();
    }
    return request.ip || '127.0.0.1';
  }
}
