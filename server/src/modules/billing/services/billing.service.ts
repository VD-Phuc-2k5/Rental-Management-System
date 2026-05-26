import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { and, eq, inArray } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import {
  contracts,
  invoiceItems,
  invoices,
  meterReadings,
  properties,
  rooms,
} from 'src/shared/infrastructure/database/schema';
import * as XLSX from 'xlsx';
import { CreateInvoicesDto } from '../dto/create-invoices.dto';
import { CreateMeterReadingDto } from '../dto/create-meter-reading.dto';
import { PreviewInvoicesDto } from '../dto/preview-invoices.dto';
import { UpdateInvoiceDto } from '../dto/update-invoice.dto';
import { FinalizeInvoiceDto } from '../dto/finalize-invoice.dto';
import { ImportMeterReadingsDto } from '../dto/import-meter-readings.dto';

type InvoiceItemType = 'rent' | 'electric' | 'water' | 'service' | 'adjustment';
type InvoiceStatus = 'draft' | 'finalized' | 'paid' | 'void';

interface ComputedLineItem {
  type: InvoiceItemType;
  quantity: number;
  unitPrice: number;
  amount: number;
  description?: string | null;
}

interface ComputedInvoice {
  roomId: string;
  tenantId: string;
  landlordId: string;
  month: string;
  roomTitle: string;
  propertyName: string;
  electricKwh: number;
  waterM3: number;
  rentFee: number;
  electricFee: number;
  waterFee: number;
  serviceFee: number;
  lineItems: ComputedLineItem[];
  total: number;
  hasMissingReading: boolean;
}

interface ParsedReadingRow {
  roomId?: string;
  roomNumber?: string;
  month?: string;
  oldElectric?: number;
  newElectric?: number;
  oldWater?: number;
  newWater?: number;
  source?: string;
}

@Injectable()
export class BillingService {
  constructor(private readonly drizzle: DrizzleService) {}

  async upsertMeterReading(
    dto: CreateMeterReadingDto,
    userId: string,
  ): Promise<void> {
    if (dto.newElectric < dto.oldElectric) {
      throw new BadRequestException('Chỉ số điện mới nhỏ hơn chỉ số cũ.');
    }
    if (dto.newWater < dto.oldWater) {
      throw new BadRequestException('Chỉ số nước mới nhỏ hơn chỉ số cũ.');
    }

    await this.drizzle.db
      .insert(meterReadings)
      .values({
        roomId: dto.roomId,
        month: dto.month,
        oldElectric: dto.oldElectric,
        newElectric: dto.newElectric,
        oldWater: dto.oldWater,
        newWater: dto.newWater,
        source: dto.source ?? null,
        createdBy: userId,
        updatedAt: new Date(),
      })
      .onConflictDoUpdate({
        target: [meterReadings.roomId, meterReadings.month],
        set: {
          oldElectric: dto.oldElectric,
          newElectric: dto.newElectric,
          oldWater: dto.oldWater,
          newWater: dto.newWater,
          source: dto.source ?? null,
          updatedAt: new Date(),
        },
      });
  }

  async previewInvoices(
    dto: PreviewInvoicesDto,
    landlordId: string,
  ): Promise<ComputedInvoice[]> {
    return this.buildInvoices(dto, landlordId);
  }

  async createInvoices(
    dto: CreateInvoicesDto,
    landlordId: string,
  ): Promise<{ created: number; invoices: Array<{ id: string; roomId: string }> }> {
    const computed = await this.buildInvoices(dto, landlordId);
    const missing = computed.filter((i) => i.hasMissingReading);
    if (missing.length > 0) {
      throw new BadRequestException(
        'Thiếu chỉ số điện/nước cho một số phòng. Vui lòng cập nhật trước khi chốt hóa đơn.',
      );
    }

    const roomIds = computed.map((c) => c.roomId);
    const existing = await this.drizzle.db
      .select({ id: invoices.id, roomId: invoices.roomId })
      .from(invoices)
      .where(and(eq(invoices.month, dto.month), inArray(invoices.roomId, roomIds)));

    if (existing.length > 0) {
      throw new BadRequestException(
        'Một số phòng đã có hóa đơn trong kỳ này.',
      );
    }

    const isDraft = dto.isDraft ?? false;
    const now = new Date();
    const dueDate = dto.dueDate ?? null;
    const status: InvoiceStatus = isDraft ? 'draft' : 'finalized';

    let insertedInvoices: Array<{ id: string; roomId: string }> = [];

    await this.drizzle.db.transaction(async (tx) => {
      const inserted = await tx
        .insert(invoices)
        .values(
          computed.map((item) => ({
            roomId: item.roomId,
            tenantId: item.tenantId,
            landlordId: item.landlordId,
            month: item.month,
            status,
            total: String(item.total),
            dueDate,
            createdBy: landlordId,
            finalizedAt: isDraft ? null : now,
          })),
        )
        .returning({ id: invoices.id, roomId: invoices.roomId });

      insertedInvoices = inserted;

      const invoiceItemsPayload = inserted.flatMap((inv) => {
        const data = computed.find((item) => item.roomId === inv.roomId);
        if (!data) return [];
        return data.lineItems.map((line) => ({
          invoiceId: inv.id,
          type: line.type as InvoiceItemType,
          quantity: String(line.quantity),
          unitPrice: String(line.unitPrice),
          amount: String(line.amount),
          description: line.description ?? null,
        }));
      });

      if (invoiceItemsPayload.length > 0) {
        await tx.insert(invoiceItems).values(invoiceItemsPayload);
      }
    });

    return { created: computed.length, invoices: insertedInvoices };
  }

  async finalizeInvoice(
    invoiceId: string,
    landlordId: string,
    dto: FinalizeInvoiceDto,
  ) {
    const [invoice] = await this.drizzle.db
      .select()
      .from(invoices)
      .where(eq(invoices.id, invoiceId));

    if (!invoice) throw new NotFoundException('Invoice not found');
    if (invoice.landlordId !== landlordId) throw new ForbiddenException();
    if (invoice.status !== 'draft') {
      throw new BadRequestException('Invoice is not in draft status');
    }

    const [updated] = await this.drizzle.db
      .update(invoices)
      .set({
        status: 'finalized',
        finalizedAt: new Date(),
        dueDate: dto.dueDate ?? invoice.dueDate,
        updatedAt: new Date(),
      })
      .where(eq(invoices.id, invoiceId))
      .returning();

    return updated;
  }

  async updateInvoice(
    invoiceId: string,
    landlordId: string,
    dto: UpdateInvoiceDto,
  ) {
    const [invoice] = await this.drizzle.db
      .select()
      .from(invoices)
      .where(eq(invoices.id, invoiceId));

    if (!invoice) throw new NotFoundException('Invoice not found');
    if (invoice.landlordId !== landlordId) throw new ForbiddenException();
    if (invoice.status !== 'draft') {
      throw new BadRequestException('Invoice is not in draft status');
    }

    const items = dto.items.map((item) => {
      const quantity = item.quantity ?? 1;
      const unitPrice = item.unitPrice ?? 0;
      const amount = item.amount ?? quantity * unitPrice;
      return {
        type: item.type,
        description: item.description ?? null,
        quantity,
        unitPrice,
        amount,
      };
    });

    const total = items.reduce((sum, item) => sum + item.amount, 0);

    await this.drizzle.db.transaction(async (tx) => {
      await tx.delete(invoiceItems).where(eq(invoiceItems.invoiceId, invoiceId));
      await tx.insert(invoiceItems).values(
        items.map((item) => ({
          invoiceId,
          type: item.type as InvoiceItemType,
          quantity: String(item.quantity),
          unitPrice: String(item.unitPrice),
          amount: String(item.amount),
          description: item.description,
        })),
      );

      await tx
        .update(invoices)
        .set({ total: String(total), updatedAt: new Date() })
        .where(eq(invoices.id, invoiceId));
    });

    return { success: true };
  }

  async getLandlordInvoices(
    landlordId: string,
    month?: string,
    status?: string,
  ) {
    const filters = [eq(invoices.landlordId, landlordId)];
    if (month) filters.push(eq(invoices.month, month));
    if (status) filters.push(eq(invoices.status, status as any));

    return this.drizzle.db
      .select()
      .from(invoices)
      .where(and(...filters));
  }

  async getTenantInvoices(tenantId: string, month?: string) {
    const filters = [eq(invoices.tenantId, tenantId)];
    if (month) filters.push(eq(invoices.month, month));

    return this.drizzle.db
      .select()
      .from(invoices)
      .where(and(...filters));
  }

  async getInvoiceDetail(invoiceId: string, userId: string) {
    const [invoice] = await this.drizzle.db
      .select()
      .from(invoices)
      .where(eq(invoices.id, invoiceId));

    if (!invoice) throw new NotFoundException('Invoice not found');

    if (invoice.tenantId !== userId && invoice.landlordId !== userId) {
      throw new ForbiddenException();
    }

    const items = await this.drizzle.db
      .select()
      .from(invoiceItems)
      .where(eq(invoiceItems.invoiceId, invoiceId));

    return { ...invoice, items };
  }

  async importMeterReadings(
    file: Express.Multer.File,
    dto: ImportMeterReadingsDto,
    userId: string,
  ) {
    const rows = this.parseImportFile(file);
    if (rows.length === 0) {
      throw new BadRequestException('File rỗng hoặc không có dữ liệu.');
    }

    const roomLookup = await this.buildRoomLookup(dto.propertyId);
    const errors: string[] = [];
    const payload: Array<
      typeof meterReadings.$inferInsert
    > = [];

    rows.forEach((row, index) => {
      const rowIndex = index + 1;
      const month = row.month ?? dto.month;
      if (!month) {
        errors.push(`Dòng ${rowIndex}: Thiếu tháng.`);
        return;
      }

      const roomId = row.roomId ?? this.resolveRoomId(row.roomNumber, roomLookup);
      if (!roomId) {
        errors.push(`Dòng ${rowIndex}: Không xác định được phòng.`);
        return;
      }

      const oldElectric = this.toNumber(row.oldElectric);
      const newElectric = this.toNumber(row.newElectric);
      const oldWater = this.toNumber(row.oldWater);
      const newWater = this.toNumber(row.newWater);

      if (
        oldElectric < 0 ||
        newElectric < 0 ||
        oldWater < 0 ||
        newWater < 0
      ) {
        errors.push(`Dòng ${rowIndex}: Chỉ số không hợp lệ.`);
        return;
      }

      if (newElectric < oldElectric) {
        errors.push(`Dòng ${rowIndex}: Điện mới nhỏ hơn điện cũ.`);
        return;
      }
      if (newWater < oldWater) {
        errors.push(`Dòng ${rowIndex}: Nước mới nhỏ hơn nước cũ.`);
        return;
      }

      payload.push({
        roomId,
        month,
        oldElectric,
        newElectric,
        oldWater,
        newWater,
        source: row.source ?? dto.source ?? 'import',
        createdBy: userId,
        updatedAt: new Date(),
      });
    });

    if (errors.length > 0) {
      throw new BadRequestException({
        message: 'Import thất bại do dữ liệu không hợp lệ.',
        errors,
      });
    }

    await this.drizzle.db.transaction(async (tx) => {
      for (const row of payload) {
        await tx
          .insert(meterReadings)
          .values(row)
          .onConflictDoUpdate({
            target: [meterReadings.roomId, meterReadings.month],
            set: {
              oldElectric: row.oldElectric,
              newElectric: row.newElectric,
              oldWater: row.oldWater,
              newWater: row.newWater,
              source: row.source ?? null,
              updatedAt: new Date(),
            },
          });
      }
    });

    return { imported: payload.length };
  }

  private async buildInvoices(
    dto: PreviewInvoicesDto,
    landlordId: string,
  ): Promise<ComputedInvoice[]> {
    const filters = [
      eq(contracts.status, 'signed'),
      eq(contracts.landlordId, landlordId),
    ];

    if (dto.roomIds && dto.roomIds.length > 0) {
      filters.push(inArray(rooms.id, dto.roomIds));
    }

    if (dto.propertyId) {
      filters.push(eq(rooms.propertyId, dto.propertyId));
    }

    const contractRows = await this.drizzle.db
      .select({
        roomId: rooms.id,
        roomTitle: rooms.title,
        propertyName: properties.name,
        tenantId: contracts.tenantId,
        landlordId: contracts.landlordId,
        monthlyRent: contracts.monthlyRent,
        electricityRate: rooms.electricity_rate_per_kwh,
        waterRate: rooms.water_rate_per_m3,
        addonAmenities: rooms.addon_amenities,
      })
      .from(contracts)
      .innerJoin(rooms, eq(contracts.roomId, rooms.id))
      .innerJoin(properties, eq(rooms.propertyId, properties.id))
      .where(and(...filters));

    if (contractRows.length === 0) return [];

    const roomIds = contractRows.map((row) => row.roomId);
    const readings = await this.drizzle.db
      .select()
      .from(meterReadings)
      .where(and(eq(meterReadings.month, dto.month), inArray(meterReadings.roomId, roomIds)));

    const readingMap = new Map(
      readings.map((r) => [r.roomId, r]),
    );

    return contractRows.map((row) => {
      const reading = readingMap.get(row.roomId);
      const hasMissingReading = !reading;

      const rentFee = this.toNumber(row.monthlyRent);
      const electricRate = this.toNumber(row.electricityRate);
      const waterRate = this.toNumber(row.waterRate);

      const electricKwh = reading
        ? Math.max(reading.newElectric - reading.oldElectric, 0)
        : 0;
      const waterM3 = reading
        ? Math.max(reading.newWater - reading.oldWater, 0)
        : 0;

      const electricFee = electricKwh * electricRate;
      const waterFee = waterM3 * waterRate;

      const addonAmenities = (row.addonAmenities ?? []) as Array<{
        code: string;
        monthly_price: number;
      }>;
      const serviceFee = addonAmenities.reduce(
        (sum, item) => sum + this.toNumber(item.monthly_price),
        0,
      );

      const lineItems: ComputedLineItem[] = [
        {
          type: 'rent',
          quantity: 1,
          unitPrice: rentFee,
          amount: rentFee,
          description: 'Tiền phòng',
        },
        {
          type: 'electric',
          quantity: electricKwh,
          unitPrice: electricRate,
          amount: electricFee,
          description: 'Tiền điện',
        },
        {
          type: 'water',
          quantity: waterM3,
          unitPrice: waterRate,
          amount: waterFee,
          description: 'Tiền nước',
        },
      ];

      if (serviceFee > 0) {
        lineItems.push({
          type: 'service',
          quantity: 1,
          unitPrice: serviceFee,
          amount: serviceFee,
          description: 'Phí dịch vụ',
        });
      }

      const total = lineItems.reduce((sum, item) => sum + item.amount, 0);

      return {
        roomId: row.roomId,
        tenantId: row.tenantId,
        landlordId: row.landlordId,
        month: dto.month,
        roomTitle: row.roomTitle,
        propertyName: row.propertyName,
        electricKwh,
        waterM3,
        rentFee,
        electricFee,
        waterFee,
        serviceFee,
        lineItems,
        total,
        hasMissingReading,
      };
    });
  }

  private toNumber(value: unknown): number {
    const num = Number(value ?? 0);
    return Number.isFinite(num) ? num : 0;
  }

  private parseImportFile(file: Express.Multer.File): ParsedReadingRow[] {
    const name = file.originalname.toLowerCase();
    if (name.endsWith('.json')) {
      const raw = JSON.parse(file.buffer.toString('utf8')) as
        | ParsedReadingRow[]
        | { data: ParsedReadingRow[] };
      if (Array.isArray(raw)) return raw;
      if (raw && Array.isArray((raw as any).data)) return (raw as any).data;
      return [];
    }

    if (name.endsWith('.xlsx') || name.endsWith('.xls')) {
      const workbook = XLSX.read(file.buffer, { type: 'buffer' });
      const sheetName = workbook.SheetNames[0];
      const sheet = workbook.Sheets[sheetName];
      if (!sheet) return [];
      const rows = XLSX.utils.sheet_to_json<Record<string, unknown>>(sheet, {
        defval: null,
      });
      return rows.map((row) => this.normalizeRow(row));
    }

    throw new BadRequestException('Định dạng file chưa được hỗ trợ.');
  }

  private normalizeRow(row: Record<string, unknown>): ParsedReadingRow {
    const map = new Map<string, unknown>();
    Object.keys(row).forEach((key) => {
      map.set(this.normalizeKey(key), row[key]);
    });

    return {
      roomId: this.pickString(map, ['roomid', 'room_id']),
      roomNumber: this.pickString(map, [
        'roomnumber',
        'room_number',
        'room',
        'phong',
        'phongso',
      ]),
      month: this.pickString(map, ['month', 'thang']),
      oldElectric: this.pickNumber(map, ['oldelectric', 'old_electric', 'electric_old', 'diencu']),
      newElectric: this.pickNumber(map, ['newelectric', 'new_electric', 'electric_new', 'dienmoi']),
      oldWater: this.pickNumber(map, ['oldwater', 'old_water', 'water_old', 'nuoccu']),
      newWater: this.pickNumber(map, ['newwater', 'new_water', 'water_new', 'nuocmoi']),
      source: this.pickString(map, ['source']),
    };
  }

  private normalizeKey(key: string): string {
    return key.toLowerCase().replace(/\s+/g, '').replace(/[^a-z0-9_]/g, '');
  }

  private pickString(map: Map<string, unknown>, keys: string[]): string | undefined {
    for (const key of keys) {
      const value = map.get(key);
      if (value === null || value === undefined) continue;
      const text = String(value).trim();
      if (text.length > 0) return text;
    }
    return undefined;
  }

  private pickNumber(map: Map<string, unknown>, keys: string[]): number | undefined {
    for (const key of keys) {
      const value = map.get(key);
      if (value === null || value === undefined || value === '') continue;
      const num = Number(value);
      if (Number.isFinite(num)) return num;
    }
    return undefined;
  }

  private async buildRoomLookup(
    propertyId?: string,
  ): Promise<Map<string, string>> {
    if (!propertyId) return new Map();
    const rows = await this.drizzle.db
      .select({ id: rooms.id, title: rooms.title })
      .from(rooms)
      .where(eq(rooms.propertyId, propertyId));

    const map = new Map<string, string>();
    for (const row of rows) {
      map.set(this.normalizeRoomLabel(row.title), row.id);
    }
    return map;
  }

  private resolveRoomId(
    roomNumber: string | undefined,
    lookup: Map<string, string>,
  ): string | undefined {
    if (!roomNumber) return undefined;
    if (lookup.size === 0) return undefined;

    const candidates = [
      roomNumber,
      `Phòng ${roomNumber}`,
      `Phong ${roomNumber}`,
    ];

    for (const candidate of candidates) {
      const normalized = this.normalizeRoomLabel(candidate);
      const match = lookup.get(normalized);
      if (match) return match;
    }
    return undefined;
  }

  private normalizeRoomLabel(value: string): string {
    return value.toLowerCase().replace(/\s+/g, '').replace(/[^a-z0-9]/g, '');
  }
}
