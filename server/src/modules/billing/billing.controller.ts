import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { ApiConsumes, ApiTags } from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { Roles } from 'src/shared/common/decorators/roles.decorator';
import { CurrentUser } from 'src/shared/common/decorators/current-user.decorator';
import { BillingService } from './services/billing.service';
import { CreateMeterReadingDto } from './dto/create-meter-reading.dto';
import { PreviewInvoicesDto } from './dto/preview-invoices.dto';
import { CreateInvoicesDto } from './dto/create-invoices.dto';
import { UpdateInvoiceDto } from './dto/update-invoice.dto';
import { FinalizeInvoiceDto } from './dto/finalize-invoice.dto';
import { ImportMeterReadingsDto } from './dto/import-meter-readings.dto';

@ApiTags('billing')
@Controller('billing')
@UseGuards(AuthGuard, RolesGuard)
export class BillingController {
  constructor(private readonly billingService: BillingService) {}

  @Post('meter-readings')
  @Roles('landlord')
  async upsertMeterReading(
    @Body() dto: CreateMeterReadingDto,
    @CurrentUser() user: { id: string },
  ) {
    await this.billingService.upsertMeterReading(dto, user.id);
    return { success: true };
  }

  @Post('meter-readings/import')
  @Roles('landlord')
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file'))
  async importMeterReadings(
    @UploadedFile() file: Express.Multer.File,
    @Body() dto: ImportMeterReadingsDto,
    @CurrentUser() user: { id: string },
  ) {
    if (!file) throw new BadRequestException('No file provided');
    return this.billingService.importMeterReadings(file, dto, user.id);
  }

  @Post('invoices/preview')
  @Roles('landlord')
  async previewInvoices(
    @Body() dto: PreviewInvoicesDto,
    @CurrentUser() user: { id: string },
  ): Promise<unknown> {
    return this.billingService.previewInvoices(dto, user.id);
  }

  @Post('invoices')
  @Roles('landlord')
  async createInvoices(
    @Body() dto: CreateInvoicesDto,
    @CurrentUser() user: { id: string },
  ) {
    return this.billingService.createInvoices(dto, user.id);
  }

  @Post('invoices/:id/finalize')
  @Roles('landlord')
  async finalizeInvoice(
    @Param('id') id: string,
    @Body() dto: FinalizeInvoiceDto,
    @CurrentUser() user: { id: string },
  ) {
    return this.billingService.finalizeInvoice(id, user.id, dto);
  }

  @Patch('invoices/:id')
  @Roles('landlord')
  async updateInvoice(
    @Param('id') id: string,
    @Body() dto: UpdateInvoiceDto,
    @CurrentUser() user: { id: string },
  ) {
    return this.billingService.updateInvoice(id, user.id, dto);
  }

  @Get('invoices/landlord')
  @Roles('landlord')
  async getLandlordInvoices(
    @CurrentUser() user: { id: string },
    @Query('month') month?: string,
    @Query('status') status?: string,
  ) {
    return this.billingService.getLandlordInvoices(user.id, month, status);
  }

  @Get('invoices/tenant')
  @Roles('tenant')
  async getTenantInvoices(
    @CurrentUser() user: { id: string },
    @Query('month') month?: string,
  ) {
    return this.billingService.getTenantInvoices(user.id, month);
  }

  @Get('invoices/:id')
  async getInvoiceDetail(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.billingService.getInvoiceDetail(id, user.id);
  }
}
