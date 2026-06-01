# Kế hoạch Kiểm thử Automation - Rental Management System API

## 1. Tổng quan

| Mục | Thông tin |
|-----|-----------|
| **Dự án** | Rental Management System (Quản lý nhà trọ) |
| **Framework test** | Jest + Supertest + @nestjs/testing |
| **Loại test** | E2E (Endpoint-to-Endpoint) — gọi API thật qua HTTP |
| **Kỹ thuật thiết kế test** | Phân lớp tương đương (EP), Phân tích giá trị biên (BVA), Bảng quyết định (DT) |
| **Môi trường** | Test DB riêng (PostgreSQL) + Supabase Auth |
| **Ngôn ngữ** | TypeScript |
| **Cấu trúc file test** | `server/test/*.e2e-spec.ts` (theo module) |

### Cấu trúc thư mục test

```
server/test/
  jest-e2e.json
  app.e2e-spec.ts
  auth/
    auth.e2e-spec.ts
  profile/
    profile.e2e-spec.ts
  properties/
    properties.e2e-spec.ts
  rooms/
    rooms.e2e-spec.ts
    browse-rooms.e2e-spec.ts
  rental-requests/
    rental-requests.e2e-spec.ts
    landlord-rental-requests.e2e-spec.ts
  viewing-appointments/
    viewing-appointments.e2e-spec.ts
    landlord-viewing-appointments.e2e-spec.ts
  billing/
    billing.e2e-spec.ts
  payments/
    payments.e2e-spec.ts
  maintenance-requests/
    maintenance-requests.e2e-spec.ts
    landlord-maintenance-requests.e2e-spec.ts
  upload/
    upload.e2e-spec.ts
  fixtures/
    test-data.ts
    setup.ts
    constants.ts
  utils/
    auth-helper.ts
    db-helper.ts
```

---

## 2. Kiến trúc API

### Global
- **Base path:** `/api`
- **Response format (success):**
  ```json
  { "statusCode": 200, "message": "Success", "data": { ... } }
  ```
- **Response format (error):**
  ```json
  { "statusCode": 400, "message": "...", "error": "BadRequestException", "details": {...}, "path": "/api/..." }
  ```
- **Auth:** Bearer token (JWT từ Supabase Auth)
- **Guards:** `AuthGuard` (xác thực) + `RolesGuard` (phân quyền: `tenant` / `landlord`)

---

## 3. Kỹ thuật thiết kế test cases

### 3.1 Phân lớp tương đương (Equivalence Partitioning - EP)

Chia miền dữ liệu đầu vào thành các lớp tương đương, mỗi lớp chọn **1 giá trị đại diện** để test.

#### 3.1.1 Auth - Register

| Trường | Lớp tương đương hợp lệ | Lớp tương đương không hợp lệ |
|--------|----------------------|-----------------------------|
| **Email** | `user@domain.com` (đúng format) | `invalid` (sai format), `""` (rỗng), `null` |
| **Password** | `Test@1234` (8-72 ký tự, có đủ hoa/thường/số/đb) | `Aa111111` (thiếu ký tự đặc biệt), `weak` (<8 ký tự), `A`*73 (>72), `onlylowercase1@` (thiếu hoa), `ALLUPPERCASE1@` (thiếu thường), `NoNumber@` (thiếu số) |
| **Phone** | `0912345678` (10-15 số) | `abc123` (có chữ), `09123` (<10 số), `0`*16 (>15 số) |
| **fullName** | `Nguyen Van A` (2-100 ký tự, không khoảng trắng đầu) | `A` (1 ký tự), `"  "` (toàn khoảng trắng), `"A"*101` (>100) |
| **identity_number** | `123456789012` (12 số) | `12345678901` (11 số), `1234567890123` (13 số), `abc123456789` (có chữ) |
| **accepted_terms** | `true` | `false` |

#### 3.1.2 Properties - Create

| Trường | Lớp hợp lệ | Lớp không hợp lệ |
|--------|-----------|-----------------|
| **name** | `"Nha tro Hoa Phuong"` | `""` (rỗng), `null` |
| **address** | `"12 Nguyen Trai"` | `""`, `null` |
| **amenityCodes** | `["WIFI", "AIR_CONDITIONER"]` | `["INVALID_AMENITY"]`, `["WIFI", "INVALID"]`, `[]` |

#### 3.1.3 Rooms - Create

| Trường | Lớp hợp lệ | Lớp không hợp lệ |
|--------|-----------|-----------------|
| **monthly_rent** | `3000000` (> 0) | `-1000000` (< 0), `0` |
| **deposit_amount** | `6000000` (> 0) | `-1`, `0` |
| **area_sqm** | `25` (> 0) | `-5`, `0` |
| **electricity_rate_per_kwh** | `3500` (> 0) | `-1000`, `0` |
| **water_rate_per_m3** | `15000` (> 0) | `-500`, `0` |
| **status** | `AVAILABLE`, `OCCUPIED`, `MAINTENANCE` | `INVALID_STATUS`, `RENTED` |
| **title** | `"Phong 101"` | `""`, `null` |

#### 3.1.4 Billing - Meter Reading

| Trường | Lớp hợp lệ | Lớp không hợp lệ |
|--------|-----------|-----------------|
| **month** | `"2026-05"` (YYYY-MM) | `"2026/05"` (sai format), `"2026-13"` (tháng 13), `"abc"` |
| **oldElectric / newElectric** | `100`, `150` (>= 0, new >= old) | `-1`, `new=50, old=100` (new < old) |
| **oldWater / newWater** | `50`, `70` (>= 0, new >= old) | `-5`, `new=30, old=60` (new < old) |

#### 3.1.5 Maintenance Request

| Trường | Lớp hợp lệ | Lớp không hợp lệ |
|--------|-----------|-----------------|
| **title** | `"Den hu"` (>= 1 ký tự) | `""` (rỗng) |
| **priority** | `low`, `medium`, `high` | `urgent`, `critical` |
| **status** | `pending`, `processing`, `completed`, `rejected`, `complaint` | `invalid_status` |

#### 3.1.6 Viewing Appointment

| Trường | Lớp hợp lệ | Lớp không hợp lệ |
|--------|-----------|-----------------|
| **scheduledAt** | Ngày trong tương lai | Ngày trong quá khứ, `"abc"` (sai ISO format) |
| **roomId** | UUID hợp lệ | `"not-a-uuid"`, `""` |

### 3.2 Phân tích giá trị biên (Boundary Value Analysis - BVA)

Kiểm tra tại các **giá trị biên** của miền dữ liệu.

#### 3.2.1 Auth - Password (`@MinLength(8) @MaxLength(72)`)

```
Biên dưới:  6, 7, [8], 9
Biên trên: 71, [72], 73, 74
```

| Test | Độ dài | Kết quả |
|------|--------|:-------:|
| 6 ký tự | `"A1@bc"` (6) | 400 |
| 7 ký tự | `"A1@bcde"` (7) | 400 |
| 8 ký tự | `"A1@bcdef"` (8) | 201 |
| 9 ký tự | `"A1@bcdefg"` (9) | 201 |
| 71 ký tự | `"A1@" + "a"*68` (71) | 201 |
| 72 ký tự | `"A1@" + "a"*69` (72) | 201 |
| 73 ký tự | `"A1@" + "a"*70` (73) | 400 |

#### 3.2.2 Auth - Phone (`@Length(10, 15)`)

```
Biên dưới:  8, 9, [10], 11
Biên trên: 14, [15], 16, 17
```

| Test | Độ dài | Kết quả |
|------|--------|:-------:|
| 8 số | `"01234567"` | 400 |
| 9 số | `"012345678"` | 400 |
| 10 số | `"0123456789"` | 201 |
| 11 số | `"01234567890"` | 201 |
| 14 số | `"01234567890123"` | 201 |
| 15 số | `"012345678901234"` | 201 |
| 16 số | `"0123456789012345"` | 400 |

#### 3.2.3 Auth - fullName (`@MinLength(2) @MaxLength(100)`)

```
Biên dưới:  0, 1, [2], 3
Biên trên: 99, [100], 101
```

| Test | Độ dài | Kết quả |
|------|--------|:-------:|
| 0 ký tự | `""` | 400 |
| 1 ký tự | `"A"` | 400 |
| 2 ký tự | `"An"` | 201 |
| 99 ký tự | `"A"*99` | 201 |
| 100 ký tự | `"A"*100` | 201 |
| 101 ký tự | `"A"*101` | 400 |

#### 3.2.4 Auth - identity_number (`@Length(12, 12)`)

```
Biên: 10, 11, [12], 13, 14
```

| Test | Độ dài | Kết quả |
|------|--------|:-------:|
| 11 số | `"1"*11` | 400 |
| 12 số | `"1"*12` | 201 |
| 13 số | `"1"*13` | 400 |

#### 3.2.5 Rooms - monthly_rent (`@Min(0)`)

```
Biên: [-2], [-1], [0], [1], [2]
```

| Test | Giá trị | Kết quả |
|------|---------|:-------:|
| -2 | `-2000000` | 400 |
| -1 | `-1000000` | 400 |
| 0 | `0` | 400 |
| 1 | `1` | 201 |
| 2 | `2` | 201 |

#### 3.2.6 Billing - oldElectric / newElectric (`@Min(0)`)

```
Biên: -2, -1, [0], 1
```

| Test | Giá trị | Kết quả |
|------|---------|:-------:|
| oldElectric = -1 | `-1` | 400 |
| oldElectric = 0 | `0` | 201 |
| oldElectric = 1 | `1` | 201 |

#### 3.2.7 Maintenance - complaintDescription (`@MinLength(3)`)

```
Biên: 0, 1, 2, [3], 4
```

| Test | Độ dài | Kết quả |
|------|--------|:-------:|
| 0 ký tự | `""` | 400 |
| 1 ký tự | `"a"` | 400 |
| 2 ký tự | `"ab"` | 400 |
| 3 ký tự | `"abc"` | 200 |
| 4 ký tự | `"abcd"` | 200 |

### 3.3 Bảng quyết định (Decision Table - DT)

#### 3.3.1 DT - Access Control (AuthGuard + RolesGuard)

| Điều kiện | Rule 1 | Rule 2 | Rule 3 | Rule 4 | Rule 5 | Rule 6 |
|-----------|:------:|:------:|:------:|:------:|:------:|:------:|
| Có token? | Y | Y | Y | N | Y | Y |
| Token hợp lệ? | Y | Y | Y | - | N | Y |
| Role phù hợp? | Y | N | Y | - | - | N/A |
| Endpoint public? | N | N | N | Y/N | Y/N | Y |
| **Kết quả** | **200** | **403** | **401/403** | **401** | **401** | **200** |

Trong đó:
- **Rule 1:** Token valid + đúng role -> endpoint trả về thành công (200/201)
- **Rule 2:** Token valid + sai role -> 403 Forbidden
- **Rule 3:** Token valid + đúng role nhưng gọi sai endpoint của role khác -> 401/403
- **Rule 4:** Không có token -> 401 Unauthorized
- **Rule 5:** Token hết hạn/không hợp lệ -> 401 Unauthorized
- **Rule 6:** Endpoint public (không cần role cụ thể) -> thành công

#### 3.3.2 DT - Rental Request Flow

Điều kiện:
- Trạng thái yêu cầu thuê: `pending`, `accepted`, `rejected`, `cancelled`
- Hành động: `cancel` (tenant), `reject` (landlord)

| Điều kiện | Rule 1 | Rule 2 | Rule 3 | Rule 4 | Rule 5 | Rule 6 |
|-----------|:------:|:------:|:------:|:------:|:------:|:------:|
| Trạng thái hiện tại | pending | pending | accepted | rejected | cancelled | pending |
| Người thực hiện | tenant | landlord | tenant | landlord | tenant | tenant khác |
| Hành động | cancel | reject | cancel | reject | cancel | cancel |
| **Kết quả** | **204** | **200** | **400** | **400** | **400** | **403/404** |

#### 3.3.3 DT - Contract Lifecycle

Điều kiện:
- Trạng thái hợp đồng: `draft`, `sent`, `signed`, `cancelled`, `finished`
- Hành động: `send` (landlord), `sign` (tenant), `cancel` (tenant), `finish` (landlord)

| Điều kiện | R1 | R2 | R3 | R4 | R5 | R6 | R7 | R8 |
|-----------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Trạng thái | draft | sent | signed | draft | draft | signed | cancelled | finished |
| Người thực hiện | landlord | tenant | tenant | tenant | landlord (send) | landlord | tenant | landlord |
| Hành động | send | sign | cancel | cancel | send | finish | cancel | finish |
| **Kết quả** | **200** | **200** | **200** | **400** | **400** | **200** | **400** | **400** |

#### 3.3.4 DT - Viewing Appointment

| Điều kiện | R1 | R2 | R3 | R4 | R5 | R6 |
|-----------|:--:|:--:|:--:|:--:|:--:|:--:|
| Trạng thái | pending | pending | approved | approved | rejected | pending |
| Người thực hiện | landlord | landlord | landlord | tenant | landlord | tenant khác |
| Hành động | approve | reject | approve | cancel | reject | cancel |
| **Kết quả** | **200** | **200** | **400** | **204** | **400** | **403/404** |

#### 3.3.5 DT - Invoice Status

| Điều kiện | R1 | R2 | R3 | R4 | R5 |
|-----------|:--:|:--:|:--:|:--:|:--:|
| Trạng thái | draft | finalized | paid | void | draft |
| Người thực hiện | landlord | landlord | tenant | landlord | landlord khác |
| Hành động | finalize | finalize | - | finalize | finalize |
| **Kết quả** | **200** | **400** | **400** | **400** | **403/404** |

#### 3.3.6 DT - Maintenance Request Status

| Điều kiện | R1 | R2 | R3 | R4 | R5 | R6 |
|-----------|:--:|:--:|:--:|:--:|:--:|:--:|
| Trạng thái | pending | pending | processing | completed | rejected | pending |
| Người thực hiện | landlord | landlord | tenant | tenant | landlord | tenant |
| Hành động | update→processing | update→completed | complete | complete | reject | complete |
| **Kết quả** | **200** | **400** | **200** | **400** | **200** | **200** |

---

## 4. Test Data Strategy

### 4.1 Factory functions (`test/fixtures/test-data.ts`)

```typescript
export const testData = {
  // ==================== AUTH ====================
  auth: {
    validTenant: {
      email: `tenant-${Date.now()}@test.com`,
      fullName: 'Nguyen Van A',
      phone: '0912345678',
      password: 'Test@1234',
      confirm_password: 'Test@1234',
      accepted_terms: true,
    },
    validLandlord: {
      email: `landlord-${Date.now()}@test.com`,
      fullName: 'Tran Thi B',
      phone: '0987654321',
      identity_number: '123456789012',
      password: 'Test@1234',
      confirm_password: 'Test@1234',
      accepted_terms: true,
    },
    // EP - Invalid email
    invalidEmail: 'not-an-email',
    // BVA - Password length
    passwordTooShort: 'Ab1@def',
    passwordMin: 'Ab1@defg',
    passwordMax: 'A1@' + 'a'.repeat(69),
    passwordTooLong: 'A1@' + 'a'.repeat(70),
    weakPassword: 'Aa111111',
    missingField: {},
    wrongOtp: '000000',
    validOtp: '123456',
    // BVA - Phone length
    phoneTooShort: '012345678',
    phoneMin: '0123456789',
    phoneMax: '012345678901234',
    phoneTooLong: '0123456789012345',
    // BVA - fullName length
    nameSingleChar: 'A',
    nameMin: 'An',
    nameMax: 'A'.repeat(100),
    nameTooLong: 'A'.repeat(101),
    // BVA - identity_number length
    identityTooShort: '1'.repeat(11),
    identityValid: '1'.repeat(12),
    identityTooLong: '1'.repeat(13),
  },

  // ==================== USERS / PROFILE ====================
  profile: {
    update: {
      fullName: 'Nguyen Van B',
      phone: '0909123456',
      avatarUrl: 'https://example.com/avatar-new.png',
      dateOfBirth: '1995-06-15',
    },
  },

  // ==================== PROPERTIES ====================
  properties: {
    valid: {
      name: 'Nha tro Hoa Phuong',
      address: '12 Nguyen Trai',
      ward: 'Phuong 5',
      district: 'Quan 3',
      city: 'TP Ho Chi Minh',
      description: 'Khu tro an ninh, gan truong hoc.',
      amenityCodes: ['WIFI', 'AIR_CONDITIONER'],
    },
    missingName: {
      address: '123',
      ward: 'P1',
      district: 'Q1',
      city: 'HCM',
      description: 'test',
      amenityCodes: ['WIFI'],
    },
    invalidAmenity: {
      name: 'Test',
      address: '123',
      ward: 'P1',
      district: 'Q1',
      city: 'HCM',
      description: 'test',
      amenityCodes: ['INVALID_AMENITY'],
    },
    update: {
      name: 'Nha tro Hoa Phuong Updated',
      description: 'Da duoc nang cap',
    },
  },

  // ==================== ROOMS ====================
  rooms: {
    valid: {
      title: 'Phong 101',
      area_sqm: 25,
      monthly_rent: 3000000,
      deposit_amount: 6000000,
      electricity_rate_per_kwh: 3500,
      water_rate_per_m3: 15000,
    },
    validWithOptions: {
      title: 'Phong 102',
      area_sqm: 30,
      monthly_rent: 3500000,
      deposit_amount: 7000000,
      electricity_rate_per_kwh: 3500,
      water_rate_per_m3: 15000,
      has_furniture: true,
      description: 'Phong sang, thoang mat',
      included_amenity_codes: ['AC', 'BED'],
      addon_amenities: [{ code: 'TV', monthly_price: 50000 }],
      parking_fees: { motorbike: 150000, car: 1000000 },
      images: [{ url: 'https://storage.example.com/rooms/img.jpg', sortOrder: 0 }],
    },
    // BVA - monthly_rent boundary
    negativeRent: { title: 'Phong 103', area_sqm: 20, monthly_rent: -1000000, deposit_amount: 2000000, electricity_rate_per_kwh: 3500, water_rate_per_m3: 15000 },
    zeroRent: { title: 'Phong 104', area_sqm: 20, monthly_rent: 0, deposit_amount: 2000000, electricity_rate_per_kwh: 3500, water_rate_per_m3: 15000 },
    update: { title: 'Phong 101 Updated', status: 'MAINTENANCE', monthly_rent: 3200000 },
    invalidStatus: { status: 'INVALID_STATUS' },
  },

  // ==================== BROWSE ====================
  browse: {
    filters: { minRent: '2000000', maxRent: '5000000' },
  },

  // ==================== RENTAL REQUESTS ====================
  rentalRequests: {
    valid: (roomId: string) => ({ roomId, note: 'Muon xem phong de o' }),
    validWithMembers: (roomId: string) => ({
      roomId,
      note: 'O chung voi ban',
      memberInfo: [{
        fullName: 'Le Van C', phone: '0909111222',
        identityNumber: '123456789013', email: 'levanc@test.com',
        isRoomLeader: false,
      }],
      parkingInfo: [{ type: 'Xe may', plate: '59A1-12345', quantity: 1 }],
    }),
    missingRoomId: {},
  },

  // ==================== CONTRACTS ====================
  contracts: {
    update: {
      startDate: '2026-06-01', endDate: '2027-06-01',
      monthlyRent: '3200000', deposit: '6400000',
      terms: 'Khong duoc nuoi thu cung',
    },
  },

  // ==================== VIEWING APPOINTMENTS ====================
  viewingAppointments: {
    valid: (roomId: string) => ({
      roomId,
      scheduledAt: new Date(Date.now() + 7 * 86400000).toISOString(),
    }),
    pastDate: (roomId: string) => ({
      roomId,
      scheduledAt: new Date(Date.now() - 86400000).toISOString(),
    }),
    missingRoomId: { scheduledAt: new Date(Date.now() + 86400000).toISOString() },
  },

  // ==================== BILLING ====================
  billing: {
    meterReading: (roomId: string) => ({
      roomId, month: '2026-05',
      oldElectric: 100, newElectric: 150,
      oldWater: 50, newWater: 70,
    }),
    meterReadingInvalidMonth: (roomId: string) => ({
      roomId, month: '2026/05',
      oldElectric: 100, newElectric: 150, oldWater: 50, newWater: 70,
    }),
    // BVA - new < old
    meterReadingReverse: (roomId: string) => ({
      roomId, month: '2026-05',
      oldElectric: 200, newElectric: 100, oldWater: 50, newWater: 70,
    }),
    // BVA - Zero values
    meterReadingZero: (roomId: string) => ({
      roomId, month: '2026-05',
      oldElectric: 0, newElectric: 0, oldWater: 0, newWater: 0,
    }),
    // BVA - Negative values
    meterReadingNegative: (roomId: string) => ({
      roomId, month: '2026-05',
      oldElectric: -1, newElectric: 10, oldWater: 0, newWater: 5,
    }),
    createInvoice: { month: '2026-05', dueDate: '2026-06-05' },
    updateInvoice: {
      dueDate: '2026-06-10',
      items: [
        { type: 'rent', description: 'Tien phong T05', quantity: 1, unitPrice: 3000000, amount: 3000000 },
        { type: 'electric', description: 'Tien dien T05', quantity: 50, unitPrice: 3500, amount: 175000 },
      ],
    },
    finalizeInvoice: { dueDate: '2026-06-05' },
  },

  // ==================== PAYMENTS ====================
  payments: {
    deposit: (contractId: string) => ({ contractId }),
    invoice: (invoiceId: string) => ({ invoiceId }),
    devConfirm: (contractId: string) => ({ contractId }),
    devConfirmInvoice: (invoiceId: string) => ({ invoiceId }),
  },

  // ==================== MAINTENANCE REQUESTS ====================
  maintenanceRequests: {
    valid: { title: 'Den bi hong', description: 'Den phong toi bi hong, khong bat duoc', priority: 'high', location: 'Phong 101' },
    validWithImages: { title: 'May nuoc nong hong', description: 'Khong co nuoc nong', priority: 'medium', imageUrls: ['https://storage.example.com/maintenance/img.jpg'] },
    missingTitle: { description: 'Test' },
    // BVA - complaintDescription boundary
    complaint: { complaintDescription: 'Da sua nhung khong het, van bi hong', complaintImageUrls: ['https://storage.example.com/complaint.jpg'] },
    complaintMin: { complaintDescription: 'abc' },
    complaintTooShort: { complaintDescription: 'ab' },
    updateStatus: { status: 'processing' },
    invalidStatus: { status: 'invalid_status' },
    schedule: {
      technicianName: 'Nguyen Van Sua', technicianPhone: '0909888777',
      scheduledAt: new Date(Date.now() + 3 * 86400000).toISOString(),
      landlordNote: 'Da lien he voi tho',
    },
  },

  // ==================== UPLOAD ====================
  upload: {
    validBucket: 'room-images',
    invalidBucket: 'invalid-bucket',
  },
};
```

---

## 5. Helper Utilities

### 5.1 Auth Helper (`test/utils/auth-helper.ts`)

```typescript
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { testData } from '../fixtures/test-data';

export class AuthHelper {
  static async registerTenant(app: INestApplication) {
    const data = { ...testData.auth.validTenant, email: `tenant-${Date.now()}@test.com` };
    await request(app.getHttpServer()).post('/api/auth/register/user').send(data).expect(201);
    return data;
  }

  static async registerLandlord(app: INestApplication) {
    const data = { ...testData.auth.validLandlord, email: `landlord-${Date.now()}@test.com` };
    await request(app.getHttpServer()).post('/api/auth/register/landlord').send(data).expect(201);
    return data;
  }

  static async login(app: INestApplication, email: string, password: string) {
    const res = await request(app.getHttpServer())
      .post('/api/auth/login').send({ email, password }).expect(201);
    return res.body.data.token;
  }

  static async getTenantToken(app: INestApplication) {
    const user = await this.registerTenant(app);
    return this.login(app, user.email, user.password);
  }

  static async getLandlordToken(app: INestApplication) {
    const user = await this.registerLandlord(app);
    return this.login(app, user.email, user.password);
  }
}
```

### 5.2 DB Helper (`test/utils/db-helper.ts`)

```typescript
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { testData } from '../fixtures/test-data';

export class DbHelper {
  static async seedProperty(app: INestApplication, landlordToken: string): Promise<{ id: string }> {
    const res = await request(app.getHttpServer())
      .post('/api/properties')
      .set('Authorization', `Bearer ${landlordToken}`)
      .send(testData.properties.valid).expect(201);
    return res.body.data;
  }

  static async seedRoom(app: INestApplication, propertyId: string, landlordToken: string): Promise<{ id: string }> {
    const res = await request(app.getHttpServer())
      .post(`/api/properties/${propertyId}/rooms`)
      .set('Authorization', `Bearer ${landlordToken}`)
      .send(testData.rooms.valid).expect(201);
    return res.body.data;
  }

  static async seedRentalRequest(app: INestApplication, roomId: string, tenantToken: string): Promise<{ id: string }> {
    const res = await request(app.getHttpServer())
      .post('/api/rental-requests')
      .set('Authorization', `Bearer ${tenantToken}`)
      .send({ roomId }).expect(201);
    return res.body.data;
  }

  static async seedMaintenanceRequest(app: INestApplication, tenantToken: string): Promise<{ id: string }> {
    const res = await request(app.getHttpServer())
      .post('/api/maintenance-requests')
      .set('Authorization', `Bearer ${tenantToken}`)
      .send(testData.maintenanceRequests.valid).expect(201);
    return res.body.data;
  }

  static async seedViewingAppointment(app: INestApplication, roomId: string, tenantToken: string): Promise<{ id: string }> {
    const res = await request(app.getHttpServer())
      .post('/api/viewing-appointments')
      .set('Authorization', `Bearer ${tenantToken}`)
      .send(testData.viewingAppointments.valid(roomId)).expect(201);
    return res.body.data;
  }
}
```

### 5.3 Constants (`test/fixtures/constants.ts`)

```typescript
export const ENDPOINTS = {
  AUTH: {
    REGISTER_USER: '/api/auth/register/user',
    REGISTER_LANDLORD: '/api/auth/register/landlord',
    LOGIN: '/api/auth/login',
    FORGOT_PASSWORD: '/api/auth/forgot-password',
    RESET_PASSWORD: '/api/auth/reset-password',
    CONFIRM_OTP: '/api/auth/confirm-otp',
  },
  USERS: { FIND_BY_ID: (id: string) => `/api/users/${id}` },
  PROFILE: { BASE: '/api/profile' },
  PROPERTIES: { BASE: '/api/properties', BY_ID: (id: string) => `/api/properties/${id}` },
  ROOMS: {
    BY_PROPERTY: (propertyId: string) => `/api/properties/${propertyId}/rooms`,
    BY_ID: (id: string) => `/api/rooms/${id}`,
  },
  BROWSE: { ROOMS: '/api/browse/rooms', ROOM_DETAIL: (id: string) => `/api/browse/rooms/${id}` },
  RENTAL_REQUESTS: {
    BASE: '/api/rental-requests', MINE: '/api/rental-requests/mine',
    BY_ID: (id: string) => `/api/rental-requests/${id}`,
  },
  CONTRACTS: {
    MINE: '/api/contracts/mine', BY_ID: (id: string) => `/api/contracts/${id}`,
    SIGN: (id: string) => `/api/contracts/${id}/sign`,
    CANCEL: (id: string) => `/api/contracts/${id}/cancel`,
    MEMBERS: (id: string) => `/api/contracts/${id}/members`,
    REMOVE_MEMBER: (contractId: string, memberId: string) =>
      `/api/contracts/${contractId}/members/${memberId}`,
  },
  LANDLORD: {
    RENTAL_REQUESTS: '/api/landlord/rental-requests',
    REJECT_REQUEST: (id: string) => `/api/landlord/rental-requests/${id}/reject`,
    CONTRACTS: '/api/landlord/contracts',
    CONTRACT_BY_ID: (id: string) => `/api/landlord/contracts/${id}`,
    SEND_CONTRACT: (id: string) => `/api/landlord/contracts/${id}/send`,
    FINISH_CONTRACT: (id: string) => `/api/landlord/contracts/${id}/finish`,
    CONTRACT_BY_RENTAL_REQUEST: (rentalRequestId: string) =>
      `/api/landlord/rental-requests/${rentalRequestId}/contract`,
  },
  VIEWING_APPOINTMENTS: {
    BASE: '/api/viewing-appointments', MINE: '/api/viewing-appointments/mine',
    BY_ID: (id: string) => `/api/viewing-appointments/${id}`,
  },
  LANDLORD_VIEWING: {
    BASE: '/api/landlord/viewing-appointments',
    APPROVE: (id: string) => `/api/landlord/viewing-appointments/${id}/approve`,
    REJECT: (id: string) => `/api/landlord/viewing-appointments/${id}/reject`,
  },
  BILLING: {
    METER_READINGS: '/api/billing/meter-readings',
    IMPORT_METER_READINGS: '/api/billing/meter-readings/import',
    INVOICES_PREVIEW: '/api/billing/invoices/preview',
    INVOICES: '/api/billing/invoices',
    INVOICE_BY_ID: (id: string) => `/api/billing/invoices/${id}`,
    FINALIZE_INVOICE: (id: string) => `/api/billing/invoices/${id}/finalize`,
    INVOICES_LANDLORD: '/api/billing/invoices/landlord',
    INVOICES_TENANT: '/api/billing/invoices/tenant',
  },
  PAYMENTS: {
    VNPAY_DEPOSIT: '/api/payments/vnpay/create-deposit',
    PAYOS_INVOICE: '/api/payments/payos/create-invoice',
    DEV_CONFIRM: '/api/payments/dev/confirm-payment',
    DEV_CONFIRM_INVOICE: '/api/payments/dev/confirm-invoice-payment',
    PAYOS_WEBHOOK: '/api/payments/payos/webhook',
    VNPAY_IPN: '/api/payments/vnpay/ipn',
    VNPAY_RETURN: '/api/payments/vnpay/return',
  },
  MAINTENANCE_REQUESTS: {
    BASE: '/api/maintenance-requests', MINE: '/api/maintenance-requests/mine',
    BY_ID: (id: string) => `/api/maintenance-requests/${id}`,
    COMPLETE: (id: string) => `/api/maintenance-requests/${id}/complete`,
    COMPLAINT: (id: string) => `/api/maintenance-requests/${id}/complaint`,
  },
  LANDLORD_MAINTENANCE: {
    BASE: '/api/landlord/maintenance-requests',
    UPDATE_STATUS: (id: string) => `/api/landlord/maintenance-requests/${id}/status`,
    SCHEDULE: (id: string) => `/api/landlord/maintenance-requests/${id}/schedule`,
  },
  UPLOAD: { IMAGE: '/api/upload/image' },
} as const;

export const ROLES = { TENANT: 'tenant', LANDLORD: 'landlord' } as const;

export const HTTP_STATUS = {
  OK: 200, CREATED: 201, NO_CONTENT: 204,
  BAD_REQUEST: 400, UNAUTHORIZED: 401, FORBIDDEN: 403,
  NOT_FOUND: 404, CONFLICT: 409, INTERNAL_ERROR: 500,
} as const;
```

---

## 6. Test Cases Chi Tiết Theo Module

### 6.1 Auth Module (`/api/auth`) — 42 test cases

#### 6.1.1 Register — EP & BVA Tests

| ID | Kỹ thuật | Test Case | Input | Expected Status | Expected Data |
|----|:---------:|-----------|-------|:---------------:|---------------|
| TC-AUTH-EP-01 | EP | Register tenant thành công (lớp hợp lệ) | `testData.auth.validTenant` | **201** | `data.role = "tenant"` |
| TC-AUTH-EP-02 | EP | Register landlord thành công (lớp hợp lệ) | `testData.auth.validLandlord` | **201** | `data.role = "landlord"` |
| TC-AUTH-EP-03 | EP | Email không hợp lệ | `{...valid, email: "invalid"}` | **400** | Validation error |
| TC-AUTH-EP-04 | EP | Email rỗng | `{...valid, email: ""}` | **400** | Validation error |
| TC-AUTH-EP-05 | EP | Thiếu password | `{...valid, password: undefined}` | **400** | Validation error |
| TC-AUTH-EP-06 | EP | Password thiếu ký tự đặc biệt | `{...valid, password: "Aa111111", confirm_password: "Aa111111"}` | **400** | `Mật khẩu phải có chữ hoa, chữ thường, số và ký tự đặc biệt` |
| TC-AUTH-EP-07 | EP | Password confirm không khớp | `{...valid, confirm_password: "Bb222222@"}` | **400** | Validation error |
| TC-AUTH-EP-08 | EP | Không đồng ý điều khoản | `{...valid, accepted_terms: false}` | **400** | Validation error |
| TC-AUTH-EP-09 | EP | Phone chứa chữ | `{...valid, phone: "abc123"}` | **400** | `Số điện thoại chỉ được chứa chữ số` |
| TC-AUTH-EP-10 | EP | Thiếu fullName | `{...valid, fullName: ""}` | **400** | Validation error |
| TC-AUTH-BVA-01 | BVA | Password 7 ký tự (biên dưới -1) | `{...valid, password: "A1@bcde", confirm_password: "A1@bcde"}` | **400** | Validation error |
| TC-AUTH-BVA-02 | BVA | Password 8 ký tự (biên dưới) | `{...valid, password: "A1@bcdef", confirm_password: "A1@bcdef"}` | **201** | Thành công |
| TC-AUTH-BVA-03 | BVA | Password 72 ký tự (biên trên) | `{...valid, password: testData.auth.passwordMax, confirm_password: testData.auth.passwordMax}` | **201** | Thành công |
| TC-AUTH-BVA-04 | BVA | Password 73 ký tự (biên trên +1) | `{...valid, password: testData.auth.passwordTooLong, confirm_password: testData.auth.passwordTooLong}` | **400** | Validation error |
| TC-AUTH-BVA-05 | BVA | Phone 9 số (biên dưới -1) | `{...valid, phone: "012345678"}` | **400** | Validation error |
| TC-AUTH-BVA-06 | BVA | Phone 10 số (biên dưới) | `{...valid, phone: "0123456789"}` | **201** | Thành công |
| TC-AUTH-BVA-07 | BVA | Phone 15 số (biên trên) | `{...valid, phone: "012345678901234"}` | **201** | Thành công |
| TC-AUTH-BVA-08 | BVA | Phone 16 số (biên trên +1) | `{...valid, phone: "0123456789012345"}` | **400** | Validation error |
| TC-AUTH-BVA-09 | BVA | fullName 1 ký tự (biên dưới -1) | `{...valid, fullName: "A"}` | **400** | Validation error |
| TC-AUTH-BVA-10 | BVA | fullName 100 ký tự (biên trên) | `{...valid, fullName: testData.auth.nameMax}` | **201** | Thành công |
| TC-AUTH-BVA-11 | BVA | fullName 101 ký tự (biên trên +1) | `{...valid, fullName: testData.auth.nameTooLong}` | **400** | Validation error |
| TC-AUTH-BVA-12 | BVA | identity_number 11 số (biên dưới -1) | `{...validLandlord, identity_number: "1".repeat(11)}` | **400** | Validation error |
| TC-AUTH-BVA-13 | BVA | identity_number 12 số (biên) | `{...validLandlord}` | **201** | Thành công |
| TC-AUTH-BVA-14 | BVA | identity_number 13 số (biên trên +1) | `{...validLandlord, identity_number: "1".repeat(13)}` | **400** | Validation error |

#### 6.1.2 Login — EP Tests

| ID | Kỹ thuật | Test Case | Input | Expected Status |
|----|:---------:|-----------|-------|:---------------:|
| TC-AUTH-EP-11 | EP | Login tenant thành công | `{ email, password }` từ TC-AUTH-EP-01 | **201** |
| TC-AUTH-EP-12 | EP | Login landlord thành công | `{ email, password }` từ TC-AUTH-EP-02 | **201** |
| TC-AUTH-EP-13 | EP | Login sai email | `{ email: "wrong@test.com", password: "Test@1234" }` | **401** |
| TC-AUTH-EP-14 | EP | Login sai password | `{ email, password: "WrongPass1@" }` | **401** |
| TC-AUTH-EP-15 | EP | Login email rỗng | `{ email: "", password: "Test@1234" }` | **400** |

#### 6.1.3 Forgot/Reset Password — EP & BVA Tests

| ID | Kỹ thuật | Test Case | Input | Expected Status |
|----|:---------:|-----------|-------|:---------------:|
| TC-AUTH-EP-16 | EP | Forgot password thành công | `{ email }` | **201** |
| TC-AUTH-EP-17 | EP | Forgot password email không tồn tại | `{ email: "notfound@test.com" }` | **201** |
| TC-AUTH-EP-18 | EP | Forgot password thiếu email | `{}` | **400** |
| TC-AUTH-EP-19 | EP | Confirm OTP thành công | `{ email, otp: "123456" }` | **201** |
| TC-AUTH-EP-20 | EP | Confirm OTP sai OTP | `{ email, otp: "000000" }` | **400** |
| TC-AUTH-EP-21 | EP | Confirm OTP sai độ dài | `{ email, otp: "12345" }` | **400** |
| TC-AUTH-EP-22 | EP | Reset password thành công | `{ email, otp, newPassword: "NewPass1@", confirmPassword: "NewPass1@" }` | **201** |
| TC-AUTH-EP-23 | EP | Reset password OTP sai | `{ email, otp: "000000", newPassword: "NewPass1@", confirmPassword: "NewPass1@" }` | **400** |
| TC-AUTH-EP-24 | EP | Reset password newPassword yếu | `{ email, otp, newPassword: "weak", confirmPassword: "weak" }` | **400** |
| TC-AUTH-EP-25 | EP | Reset password confirm không khớp | `{ email, otp, newPassword: "NewPass1@", confirmPassword: "Diff1@ent" }` | **400** |

#### 6.1.4 Access Control — Decision Table Tests

| ID | Kỹ thuật | Test Case | Input | Expected Status |
|----|:---------:|-----------|-------|:---------------:|
| TC-AUTH-DT-01 | DT | Token valid + đúng role (landlord→properties) | landlord token + POST /api/properties | **201** |
| TC-AUTH-DT-02 | DT | Token valid + sai role (tenant→properties) | tenant token + POST /api/properties | **403** |
| TC-AUTH-DT-03 | DT | Token valid + sai role (landlord→rental-requests) | landlord token + POST /api/rental-requests | **403** |
| TC-AUTH-DT-04 | DT | Không token | POST /api/properties | **401** |
| TC-AUTH-DT-05 | DT | Token rỗng | Auth: "Bearer " + POST /api/properties | **401** |
| TC-AUTH-DT-06 | DT | Token giả mạo | Auth: "Bearer fake-token" + GET /api/profile | **401** |
| TC-AUTH-DT-07 | DT | Endpoint public (GET /api/users/:id) không token | GET /api/users/:id | **200** |
| TC-AUTH-DT-08 | DT | Login password cũ sau reset | POST /api/auth/login với password cũ | **401** |
| TC-AUTH-DT-09 | DT | Login password mới sau reset | POST /api/auth/login với password mới | **201** |

### 6.2 Profile Module (`/api/profile`) — 6 test cases

| ID | Kỹ thuật | Test Case | Method | Expected Status |
|----|:---------:|-----------|--------|:---------------:|
| TC-PROF-01 | EP | Get profile thành công | GET | **200** |
| TC-PROF-02 | DT | Get profile không token | GET | **401** |
| TC-PROF-03 | EP | Update profile thành công | PATCH | **200** |
| TC-PROF-04 | EP | Update profile dữ liệu trống | PATCH | **200** |
| TC-PROF-05 | DT | Update profile không token | PATCH | **401** |
| TC-PROF-06 | EP | Get profile sau update phản ánh đúng | GET | **200** |

### 6.3 Properties Module (`/api/properties`) — 15 test cases

| ID | Kỹ thuật | Test Case | Method | Expected Status |
|----|:---------:|-----------|--------|:---------------:|
| TC-PROP-01 | EP | Create property thành công | POST | **201** |
| TC-PROP-02 | EP | Create thiếu name | POST | **400** |
| TC-PROP-03 | EP | Create amenityCodes không hợp lệ | POST | **400** |
| TC-PROP-04 | DT | Create với tenant token (sai role) | POST | **403** |
| TC-PROP-05 | DT | Create không token | POST | **401** |
| TC-PROP-06 | EP | Get all properties của landlord | GET | **200** |
| TC-PROP-07 | EP | Get property by ID thành công | GET | **200** |
| TC-PROP-08 | EP | Get property by ID không tồn tại | GET | **404** |
| TC-PROP-09 | DT | Get property của landlord khác | GET | **404** |
| TC-PROP-10 | EP | Update property thành công | PATCH | **200** |
| TC-PROP-11 | EP | Update property không tồn tại | PATCH | **404** |
| TC-PROP-12 | DT | Update property của landlord khác | PATCH | **404** |
| TC-PROP-13 | EP | Delete property thành công | DELETE | **200** |
| TC-PROP-14 | EP | Delete property không tồn tại | DELETE | **404** |
| TC-PROP-15 | DT | Delete property của landlord khác | DELETE | **404** |

### 6.4 Rooms Module — 17 test cases

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected Status |
|----|:---------:|-----------|--------|----------|:---------------:|
| TC-ROOM-01 | EP | Create room thành công (đầy đủ) | POST | /api/properties/:propId/rooms | **201** |
| TC-ROOM-02 | EP | Create room với property không tồn tại | POST | /api/properties/:uuid/rooms | **404** |
| TC-ROOM-03 | EP | Create room thiếu title | POST | /api/properties/:propId/rooms | **400** |
| TC-ROOM-04 | BVA | Create room monthly_rent âm (biên dưới) | POST | /api/properties/:propId/rooms | **400** |
| TC-ROOM-05 | BVA | Create room monthly_rent = 0 (biên) | POST | /api/properties/:propId/rooms | **400** |
| TC-ROOM-06 | DT | Create room với tenant token | POST | /api/properties/:propId/rooms | **403** |
| TC-ROOM-07 | EP | Get rooms by property | GET | /api/properties/:propId/rooms | **200** |
| TC-ROOM-08 | EP | Get room by ID thành công | GET | /api/rooms/:id | **200** |
| TC-ROOM-09 | EP | Get room by ID không tồn tại | GET | /api/rooms/:id | **404** |
| TC-ROOM-10 | EP | Update room thành công | PATCH | /api/rooms/:id | **200** |
| TC-ROOM-11 | EP | Update room status thành "OCCUPIED" | PATCH | /api/rooms/:id | **200** |
| TC-ROOM-12 | EP | Update room status thành "MAINTENANCE" | PATCH | /api/rooms/:id | **200** |
| TC-ROOM-13 | EP | Update room với status không hợp lệ | PATCH | /api/rooms/:id | **400** |
| TC-ROOM-14 | EP | Delete room thành công | DELETE | /api/rooms/:id | **200** |
| TC-ROOM-15 | EP | Delete room không tồn tại | DELETE | /api/rooms/:id | **404** |
| TC-ROOM-16 | BVA | Create room area_sqm = 0 (biên) | POST | /api/properties/:propId/rooms | **400** |
| TC-ROOM-17 | BVA | Create room area_sqm = 0.5 (lớp hợp lệ) | POST | /api/properties/:propId/rooms | **201** |

### 6.5 Browse Rooms Module (`/api/browse`) — 8 test cases

| ID | Kỹ thuật | Test Case | Query | Expected Status |
|----|:---------:|-----------|-------|:---------------:|
| TC-BROWSE-01 | EP | Get available rooms không filter | - | **200** |
| TC-BROWSE-02 | EP | Get với minRent | `minRent=2000000` | **200** |
| TC-BROWSE-03 | EP | Get với maxRent | `maxRent=5000000` | **200** |
| TC-BROWSE-04 | BVA | Get với cả 2 filters (biên) | `minRent=2000000&maxRent=5000000` | **200** |
| TC-BROWSE-05 | EP | Get room detail thành công | - | **200** |
| TC-BROWSE-06 | EP | Get room detail không tồn tại | uuid v4 | **404** |
| TC-BROWSE-07 | DT | Gọi browse không token | - | **401** |
| TC-BROWSE-08 | EP | Browse vẫn thấy room OCCUPIED | - | **200** |

### 6.6 Rental Requests — 18 test cases

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|--------|----------|:--------:|
| TC-RR-01 | EP | Create rental request thành công | POST | /api/rental-requests | **201** |
| TC-RR-02 | EP | Create với memberInfo + parkingInfo | POST | /api/rental-requests | **201** |
| TC-RR-03 | EP | Create với room không tồn tại | POST | /api/rental-requests | **404** |
| TC-RR-04 | EP | Create thiếu roomId | POST | /api/rental-requests | **400** |
| TC-RR-05 | DT | Create với landlord token | POST | /api/rental-requests | **403** |
| TC-RR-06 | EP | Get my rental requests | GET | /api/rental-requests/mine | **200** |
| TC-RR-07 | EP | Get rental request by ID | GET | /api/rental-requests/:id | **200** |
| TC-RR-08 | DT | Get rental request của tenant khác | GET | /api/rental-requests/:id | **403/404** |
| TC-RR-09 | DT | Cancel rental request (pending→cancelled) | DELETE | /api/rental-requests/:id | **204** |
| TC-RR-10 | DT | Cancel rental request đã cancelled | DELETE | /api/rental-requests/:id | **400** |
| TC-RR-11 | DT | Cancel rental request của tenant khác | DELETE | /api/rental-requests/:id | **403/404** |
| TC-LRR-01 | EP | Get incoming requests (landlord) | GET | /api/landlord/rental-requests | **200** |
| TC-LRR-02 | DT | Get incoming requests với tenant token | GET | /api/landlord/rental-requests | **403** |
| TC-LRR-03 | DT | Reject rental request (pending→rejected) | PATCH | /api/landlord/rental-requests/:id/reject | **200** |
| TC-LRR-04 | DT | Reject rental request đã rejected | PATCH | /api/landlord/rental-requests/:id/reject | **400** |
| TC-LRR-05 | DT | Tenant gọi reject endpoint | PATCH | /api/landlord/rental-requests/:id/reject | **403** |

### 6.7 Contracts — 14 test cases

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|--------|----------|:--------:|
| TC-CON-01 | EP | Get my contracts (tenant) | GET | /api/contracts/mine | **200** |
| TC-CON-02 | EP | Get contract detail | GET | /api/contracts/:id | **200** |
| TC-CON-03 | DT | Get contract detail của user khác | GET | /api/contracts/:id | **403/404** |
| TC-CON-04 | DT | Sign contract (sent→signed) | POST | /api/contracts/:id/sign | **200** |
| TC-CON-05 | DT | Sign contract đã signed | POST | /api/contracts/:id/sign | **400** |
| TC-CON-06 | DT | Cancel contract thành công | POST | /api/contracts/:id/cancel | **200** |
| TC-CON-07 | EP | Get contract members | GET | /api/contracts/:id/members | **200** |
| TC-CON-08 | EP | Remove contract member | DELETE | /api/contracts/:contractId/members/:memberId | **204** |
| TC-LCON-01 | EP | Get landlord contracts | GET | /api/landlord/contracts | **200** |
| TC-LCON-02 | EP | Update contract thành công | PATCH | /api/landlord/contracts/:id | **200** |
| TC-LCON-03 | DT | Send contract (draft→sent) | POST | /api/landlord/contracts/:id/send | **200** |
| TC-LCON-04 | DT | Send contract đã sent | POST | /api/landlord/contracts/:id/send | **400** |
| TC-LCON-05 | DT | Finish contract (signed→finished) | POST | /api/landlord/contracts/:id/finish | **200** |
| TC-LCON-06 | EP | Get contract by rental request | GET | /api/landlord/rental-requests/:rentalRequestId/contract | **200** |

### 6.8 Viewing Appointments — 12 test cases

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|--------|----------|:--------:|
| TC-VA-01 | EP | Create appointment thành công | POST | /api/viewing-appointments | **201** |
| TC-VA-02 | EP | Create với room không tồn tại | POST | /api/viewing-appointments | **404** |
| TC-VA-03 | EP | Create với scheduledAt trong quá khứ | POST | /api/viewing-appointments | **400** |
| TC-VA-04 | DT | Create với landlord token | POST | /api/viewing-appointments | **403** |
| TC-VA-05 | EP | Get my appointments | GET | /api/viewing-appointments/mine | **200** |
| TC-VA-06 | DT | Cancel appointment (pending→cancelled) | DELETE | /api/viewing-appointments/:id | **204** |
| TC-VA-07 | DT | Cancel appointment của tenant khác | DELETE | /api/viewing-appointments/:id | **403/404** |
| TC-VA-08 | EP | Get landlord appointments | GET | /api/landlord/viewing-appointments | **200** |
| TC-VA-09 | DT | Approve appointment (pending→approved) | POST | /api/landlord/viewing-appointments/:id/approve | **200** |
| TC-VA-10 | DT | Approve appointment đã approved | POST | /api/landlord/viewing-appointments/:id/approve | **400** |
| TC-VA-11 | DT | Reject appointment (pending→rejected) | POST | /api/landlord/viewing-appointments/:id/reject | **200** |
| TC-VA-12 | DT | Reject với tenant token | POST | /api/landlord/viewing-appointments/:id/reject | **403** |

### 6.9 Billing — 19 test cases

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|--------|----------|:--------:|
| TC-BILL-01 | EP | Upsert meter reading thành công | POST | /api/billing/meter-readings | **200** |
| TC-BILL-02 | DT | Upsert meter reading với tenant token | POST | /api/billing/meter-readings | **403** |
| TC-BILL-03 | EP | Upsert month sai format (YYYY/MM) | POST | /api/billing/meter-readings | **400** |
| TC-BILL-04 | BVA | Upsert newElectric < oldElectric | POST | /api/billing/meter-readings | **400** |
| TC-BILL-05 | BVA | Upsert với giá trị = 0 (biên dưới) | POST | /api/billing/meter-readings | **200** |
| TC-BILL-06 | BVA | Upsert với giá trị âm (biên dưới -1) | POST | /api/billing/meter-readings | **400** |
| TC-BILL-07 | EP | Import meter readings từ file | POST | /api/billing/meter-readings/import | **200** |
| TC-BILL-08 | EP | Import không gửi file | POST | /api/billing/meter-readings/import | **400** |
| TC-BILL-09 | EP | Preview invoices | POST | /api/billing/invoices/preview | **200** |
| TC-BILL-10 | EP | Create invoices | POST | /api/billing/invoices | **201** |
| TC-BILL-11 | DT | Finalize invoice (draft→finalized) | POST | /api/billing/invoices/:id/finalize | **200** |
| TC-BILL-12 | DT | Finalize invoice đã finalized | POST | /api/billing/invoices/:id/finalize | **400** |
| TC-BILL-13 | EP | Update invoice với items | PATCH | /api/billing/invoices/:id | **200** |
| TC-BILL-14 | EP | Get landlord invoices | GET | /api/billing/invoices/landlord | **200** |
| TC-BILL-15 | EP | Get landlord invoices filter by month | GET | /api/billing/invoices/landlord?month=2026-05 | **200** |
| TC-BILL-16 | EP | Get tenant invoices | GET | /api/billing/invoices/tenant | **200** |
| TC-BILL-17 | EP | Get invoice detail | GET | /api/billing/invoices/:id | **200** |
| TC-BILL-18 | EP | Get invoice detail không tồn tại | GET | /api/billing/invoices/:uuid | **404** |
| TC-BILL-19 | DT | Tenant call finalize invoice | POST | /api/billing/invoices/:id/finalize | **403** |

### 6.10 Payments — 10 test cases

| ID | Kỹ thuật | Test Case | Method | Expected |
|----|:---------:|-----------|--------|:--------:|
| TC-PAY-01 | EP | Create deposit payment (tenant) | POST | **201** |
| TC-PAY-02 | DT | Create deposit với landlord token | POST | **403** |
| TC-PAY-03 | EP | Create deposit contract không tồn tại | POST | **404** |
| TC-PAY-04 | EP | Create invoice payment | POST | **201** |
| TC-PAY-05 | EP | Dev confirm payment | POST | **200** |
| TC-PAY-06 | EP | Dev confirm invoice payment | POST | **200** |
| TC-PAY-07 | EP | PayOS webhook hợp lệ | POST | **200** |
| TC-PAY-08 | EP | VNPay IPN checksum sai | GET | **200** + RspCode: "97" |
| TC-PAY-09 | EP | VNPay return signature đúng | GET | **200** |
| TC-PAY-10 | EP | VNPay return signature sai | GET | **200** + success: false |

### 6.11 Maintenance Requests (Tenant) — 12 test cases

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|--------|----------|:--------:|
| TC-MR-01 | EP | Create maintenance request thành công | POST | /api/maintenance-requests | **201** |
| TC-MR-02 | EP | Create maintenance request với images | POST | /api/maintenance-requests | **201** |
| TC-MR-03 | DT | Create với landlord token | POST | /api/maintenance-requests | **403** |
| TC-MR-04 | EP | Create thiếu title | POST | /api/maintenance-requests | **400** |
| TC-MR-05 | EP | Get my maintenance requests | GET | /api/maintenance-requests/mine | **200** |
| TC-MR-06 | EP | Get detail thành công | GET | /api/maintenance-requests/:id | **200** |
| TC-MR-07 | DT | Get detail của tenant khác | GET | /api/maintenance-requests/:id | **403/404** |
| TC-MR-08 | DT | Complete maintenance request | PATCH | /api/maintenance-requests/:id/complete | **200** |
| TC-MR-09 | EP | Submit complaint thành công | PATCH | /api/maintenance-requests/:id/complaint | **200** |
| TC-MR-10 | BVA | Submit complaint thiếu description (biên dưới) | PATCH | /api/maintenance-requests/:id/complaint | **400** |
| TC-MR-11 | BVA | Submit complaint đúng 3 ký tự (biên dưới) | PATCH | /api/maintenance-requests/:id/complaint | **200** |
| TC-MR-12 | EP | Get all (landlord) | GET | /api/landlord/maintenance-requests | **200** |
| TC-MR-13 | EP | Update status (pending→processing) | PATCH | /api/landlord/maintenance-requests/:id/status | **200** |
| TC-MR-14 | EP | Update status không hợp lệ | PATCH | /api/landlord/maintenance-requests/:id/status | **400** |
| TC-MR-15 | DT | Update status với tenant token | PATCH | /api/landlord/maintenance-requests/:id/status | **403** |
| TC-MR-16 | EP | Schedule maintenance | PATCH | /api/landlord/maintenance-requests/:id/schedule | **200** |

### 6.12 Upload — 4 test cases

| ID | Kỹ thuật | Test Case | Expected |
|----|:---------:|-----------|:--------:|
| TC-UPL-01 | EP | Upload image thành công | **201** + url |
| TC-UPL-02 | EP | Upload không gửi file | **400** |
| TC-UPL-03 | DT | Upload không token | **401** |
| TC-UPL-04 | EP | Upload với bucket không hợp lệ | **200** (default) |

---

## 7. Setup & Teardown Strategy

### 7.1 Global Setup (`test/fixtures/setup.ts`)

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { AppModule } from '../../src/app.module';
import { HttpResponseInterceptor } from '../../src/shared/common/interceptors/HttpResponse.interceptor';
import { HttpExceptionFilter } from '../../src/shared/common/filter/HttpException.filter';

let app: INestApplication;

beforeAll(async () => {
  const moduleFixture: TestingModule = await Test.createTestingModule({
    imports: [AppModule],
  }).compile();

  app = moduleFixture.createNestApplication();
  app.setGlobalPrefix('api');
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true }));
  app.useGlobalInterceptors(new HttpResponseInterceptor());
  app.useGlobalFilters(new HttpExceptionFilter());
  await app.init();
});

afterAll(async () => {
  await app.close();
});

export { app };
```

### 7.2 Chiến lược dọn dẹp dữ liệu

- **Mỗi file test:** Tự tạo dữ liệu trong `beforeEach`, xóa trong `afterEach`
- **Unique constraints:** Dùng `Date.now()` trong email để tránh trùng
- **Cascade delete:** Khi xóa property → rooms tự động xóa

### 7.3 Môi trường Test

- **Database:** PostgreSQL test instance (Docker: `docker-compose.test.yml`)
- **Supabase Auth:** Mock hoặc test project riêng
- **Redis:** Mock hoặc test instance
- **File upload:** Mock Supabase Storage

---

## 8. Response Validation Pattern

### 8.1 Response thành công

```typescript
const response = await request(app.getHttpServer())
  .post('/api/auth/login').send({ email, password });

expect(response.status).toBe(201);
expect(response.body.statusCode).toBe(201);
expect(response.body.message).toBe('Success');
expect(response.body.data).toHaveProperty('token');
expect(response.body.data.user.roles).toContain('tenant');
```

### 8.2 Validation error

```typescript
const response = await request(app.getHttpServer())
  .post('/api/auth/register/user').send({ email: 'invalid' });

expect(response.status).toBe(400);
expect(response.body.statusCode).toBe(400);
expect(response.body.error).toBe('BadRequestException');
```

### 8.3 Authorization error

```typescript
// Không token
const res1 = await request(app.getHttpServer()).post('/api/properties').send({});
expect(res1.status).toBe(401);

// Sai role
const res2 = await request(app.getHttpServer())
  .post('/api/properties').set('Authorization', `Bearer ${tenantToken}`);
expect(res2.status).toBe(403);
expect(res2.body.message).toBe('Bạn không có quyền truy cập.');
```

---

## 9. Jest Configuration

### Cập nhật `test/jest-e2e.json`

```json
{
  "moduleFileExtensions": ["js", "json", "ts"],
  "rootDir": ".",
  "testEnvironment": "node",
  "testRegex": ".e2e-spec.ts$",
  "transform": { "^.+\\.(t|j)s$": "ts-jest" },
  "testTimeout": 30000,
  "maxWorkers": 1
}
```

---

## 10. Tổng kết số lượng test cases

| Module | File | EP | BVA | DT | Tổng |
|--------|------|:--:|:---:|:--:|:----:|
| Auth | `auth.e2e-spec.ts` | 20 | 14 | 9 | **43** |
| Profile | `profile.e2e-spec.ts` | 4 | 0 | 2 | **6** |
| Properties | `properties.e2e-spec.ts` | 9 | 0 | 6 | **15** |
| Rooms | `rooms.e2e-spec.ts` | 11 | 6 | 1 | **18** |
| Browse Rooms | `browse-rooms.e2e-spec.ts` | 6 | 1 | 1 | **8** |
| Rental Requests | `rental-requests.e2e-spec.ts` | 8 | 0 | 10 | **18** |
| Contracts | `contracts.e2e-spec.ts` | 7 | 0 | 7 | **14** |
| Viewing Appointments | `viewing-appointments.e2e-spec.ts` | 4 | 0 | 8 | **12** |
| Billing | `billing.e2e-spec.ts` | 14 | 4 | 2 | **20** |
| Payments | `payments.e2e-spec.ts` | 10 | 0 | 0 | **10** |
| Maintenance Requests | `maintenance-requests.e2e-spec.ts` | 11 | 4 | 3 | **18** |
| Upload | `upload.e2e-spec.ts` | 3 | 0 | 1 | **4** |
| **Tổng cộng** | **13 files** | **107** | **29** | **50** | **~186** |

---

## 11. Phân loại mức độ ưu tiên

| Mức độ | Mô tả | Số lượng |
|--------|-------|:--------:|
| **P0 - Critical** | Auth, Access Control (DT), Role-based tests | ~50 tests |
| **P1 - High** | Core business: Properties, Rooms, Rental Requests, Contracts | ~65 tests |
| **P2 - Medium** | Billing, Payments, Maintenance, BVA boundary tests | ~50 tests |
| **P3 - Low** | Viewing Appointments, Upload, Browse, Profile | ~21 tests |

---

## 12. Rủi ro & Giảm thiểu

| Rủi ro | Tác động | Giảm thiểu |
|--------|----------|------------|
| Supabase Auth rate limit | Chậm test, fail ngẫu nhiên | Dùng mock auth, delay giữa request |
| Database state không sạch | Test sai do dữ liệu rác | Xóa dữ liệu trong `afterEach`, transaction rollback |
| PayOS/VNPay thật không khả dụng | Payment test fail | Mock external service calls |
| File upload cần storage | Upload test fail | Mock Supabase Storage |
| OTP gửi email thật | Forgot password test không auto | Mock email service, OTP fixed trong test env |
