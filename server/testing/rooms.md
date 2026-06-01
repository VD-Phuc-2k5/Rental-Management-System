# Rooms Module — Test Plan

**Endpoints:**
- CRUD: `/api/properties/:propertyId/rooms`, `/api/rooms/:id`
- Browse: `/api/browse/rooms`

---

## 1. Phân lớp tương đương (Equivalence Partitioning)

### Create Room

| Lớp | Trường | Mô tả | Giá trị đại diện | Kết quả |
|-----|--------|-------|-----------------|:-------:|
| EP-01 | title | Chuỗi không rỗng | `Phong 101` | Hợp lệ |
| EP-02 | title | Rỗng | `""` | Không hợp lệ |
| EP-03 | area_sqm | > 0 | `25` | Hợp lệ |
| EP-04 | area_sqm | = 0 | `0` | Không hợp lệ |
| EP-05 | monthly_rent | > 0 | `3000000` | Hợp lệ |
| EP-06 | monthly_rent | < 0 | `-1000000` | Không hợp lệ |
| EP-07 | deposit_amount | > 0 | `6000000` | Hợp lệ |
| EP-08 | status | `AVAILABLE` | `AVAILABLE` | Hợp lệ |
| EP-09 | status | `OCCUPIED` | `OCCUPIED` | Hợp lệ |
| EP-10 | status | `MAINTENANCE` | `MAINTENANCE` | Hợp lệ |
| EP-11 | status | Không hợp lệ | `INVALID_STATUS` | Không hợp lệ |

### Browse Rooms

| Lớp | Mô tả | Giá trị | Kết quả |
|-----|-------|---------|:-------:|
| EP-12 | Không filter | `{}` | Trả về tất cả |
| EP-13 | Filter minRent | `{ minRent: 2000000 }` | Lọc >= 2tr |
| EP-14 | Filter maxRent | `{ maxRent: 5000000 }` | Lọc <= 5tr |
| EP-15 | Filter cả 2 | `{ minRent: 2000000, maxRent: 5000000 }` | Lọc trong khoảng |

## 2. Phân tích giá trị biên (Boundary Value Analysis)

### monthly_rent (`@Min(0)`)

| ID | Giá trị | Loại biên | Kết quả |
|:--:|:-------:|:---------:|:-------:|
| BVA-01 | `-2000000` | Biên dưới - 2 | **400** |
| BVA-02 | `-1000000` | Biên dưới - 1 | **400** |
| BVA-03 | `0` | Biên (chính xác) | **400** |
| BVA-04 | `1` | Biên trên + 1 | **201** |
| BVA-05 | `1000000` | Lớp hợp lệ | **201** |

### area_sqm (`@Min(0)`)

| ID | Giá trị | Loại biên | Kết quả |
|:--:|:-------:|:---------:|:-------:|
| BVA-06 | `-1` | Biên dưới - 1 | **400** |
| BVA-07 | `0` | Biên (chính xác) | **400** |
| BVA-08 | `1` | Biên trên + 1 | **201** |

## 3. Bảng quyết định (Decision Table) — Browse Room Detail

| Điều kiện | Rule 1 | Rule 2 | Rule 3 |
|-----------|:------:|:------:|:------:|
| Room tồn tại? | Y | N | Y |
| Token hợp lệ? | Y | Y | N |
| **Kết quả** | **200** | **404** | **401** |

---

## 4. Test Cases

### Room CRUD

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected Status |
|----|:---------:|-----------|:------:|:--------:|:---------------:|
| ROOM-01 | EP | Create room thành công (đầy đủ) | POST | /api/properties/:propId/rooms | **201** |
| ROOM-02 | EP | Create room với property không tồn tại | POST | /api/properties/:uuid/rooms | **404** |
| ROOM-03 | EP | Create room thiếu title | POST | /api/properties/:propId/rooms | **400** |
| ROOM-04 | BVA | Create room monthly_rent = -1tr (biên dưới) | POST | /api/properties/:propId/rooms | **400** |
| ROOM-05 | BVA | Create room monthly_rent = 0 (biên) | POST | /api/properties/:propId/rooms | **400** |
| ROOM-06 | BVA | Create room monthly_rent = 1 (biên trên) | POST | /api/properties/:propId/rooms | **201** |
| ROOM-07 | BVA | Create room area_sqm = 0 (biên) | POST | /api/properties/:propId/rooms | **400** |
| ROOM-08 | DT | Create room với tenant token | POST | /api/properties/:propId/rooms | **403** |
| ROOM-09 | EP | Get rooms by property | GET | /api/properties/:propId/rooms | **200** |
| ROOM-10 | EP | Get room by ID thành công | GET | /api/rooms/:id | **200** |
| ROOM-11 | EP | Get room by ID không tồn tại | GET | /api/rooms/:id | **404** |
| ROOM-12 | EP | Update room title | PATCH | /api/rooms/:id | **200** |
| ROOM-13 | EP | Update room status = OCCUPIED | PATCH | /api/rooms/:id | **200** |
| ROOM-14 | EP | Update room status = MAINTENANCE | PATCH | /api/rooms/:id | **200** |
| ROOM-15 | EP | Update room status không hợp lệ | PATCH | /api/rooms/:id | **400** |
| ROOM-16 | EP | Delete room thành công | DELETE | /api/rooms/:id | **200** |
| ROOM-17 | EP | Delete room không tồn tại | DELETE | /api/rooms/:id | **404** |

### Browse Rooms

| ID | Kỹ thuật | Test Case | Query | Expected Status |
|----|:---------:|-----------|:-----:|:---------------:|
| ROOM-18 | EP | Get available rooms không filter | - | **200** |
| ROOM-19 | EP | Get với minRent | `minRent=2000000` | **200** |
| ROOM-20 | EP | Get với maxRent | `maxRent=5000000` | **200** |
| ROOM-21 | BVA | Get với cả 2 filters | `minRent=2000000&maxRent=5000000` | **200** |
| ROOM-22 | EP | Get room detail thành công | - | **200** |
| ROOM-23 | EP | Get room detail không tồn tại | uuid | **404** |
| ROOM-24 | DT | Browse không token | - | **401** |

---

## 5. Test Data

```typescript
export const roomsTestData = {
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
  // BVA
  negativeRent: { title: 'Room', area_sqm: 20, monthly_rent: -1000000, deposit_amount: 2000000, electricity_rate_per_kwh: 3500, water_rate_per_m3: 15000 },
  zeroRent: { title: 'Room', area_sqm: 20, monthly_rent: 0, deposit_amount: 2000000, electricity_rate_per_kwh: 3500, water_rate_per_m3: 15000 },
  zeroArea: { title: 'Room', area_sqm: 0, monthly_rent: 1000000, deposit_amount: 2000000, electricity_rate_per_kwh: 3500, water_rate_per_m3: 15000 },
  update: { title: 'Phong 101 Updated', status: 'MAINTENANCE', monthly_rent: 3200000 },
  invalidStatus: { status: 'INVALID_STATUS' },
};
```
