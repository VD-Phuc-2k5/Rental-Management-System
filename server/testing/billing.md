# Billing Module — Test Plan

**Endpoints:** `/api/billing/*`

---

## 1. Phân lớp tương đương (Equivalence Partitioning)

### Meter Readings

| Lớp | Trường | Mô tả | Giá trị đại diện | Kết quả |
|-----|--------|-------|-----------------|:-------:|
| EP-01 | month | Định dạng YYYY-MM | `"2026-05"` | Hợp lệ |
| EP-02 | month | Sai định dạng | `"2026/05"` | Không hợp lệ |
| EP-03 | oldElectric | >= 0 | `100` | Hợp lệ |
| EP-04 | oldElectric | < 0 | `-1` | Không hợp lệ |
| EP-05 | newElectric | >= oldElectric | `150` | Hợp lệ |
| EP-06 | newElectric | < oldElectric | `50` (khi old=100) | Không hợp lệ |
| EP-07 | oldWater | >= 0 | `50` | Hợp lệ |
| EP-08 | newWater | >= oldWater | `70` | Hợp lệ |
| EP-09 | newWater | < oldWater | `30` (khi old=50) | Không hợp lệ |

### Invoice

| Lớp | Trường | Mô tả | Giá trị đại diện | Kết quả |
|-----|--------|-------|-----------------|:-------:|
| EP-10 | month | Định dạng YYYY-MM | `"2026-05"` | Hợp lệ |
| EP-11 | dueDate | ISO Date | `"2026-06-05"` | Hợp lệ |
| EP-12 | status | draft | `draft` | Có thể finalize |
| EP-13 | status | finalized | `finalized` | Không thể finalize lại |
| EP-14 | status | paid | `paid` | Chỉ đọc |
| EP-15 | status | void | `void` | Chỉ đọc |

## 2. Phân tích giá trị biên (Boundary Value Analysis)

### oldElectric / newElectric (`@Min(0)`)

| ID | Giá trị | Loại biên | Kết quả |
|:--:|:-------:|:---------:|:-------:|
| BVA-01 | oldElectric = -1 | Biên dưới - 1 | **400** |
| BVA-02 | oldElectric = 0 | Biên (min) | **200** |
| BVA-03 | oldElectric = 1 | Biên trên + 1 | **200** |

### newElectric vs oldElectric (logic new >= old)

| ID | oldElectric | newElectric | Loại biên | Kết quả |
|:--:|:-----------:|:-----------:|:---------:|:-------:|
| BVA-04 | 100 | 99 | new < old (biên dưới -1) | **400** |
| BVA-05 | 100 | 100 | new = old (biên) | **200** |
| BVA-06 | 100 | 101 | new > old (biên trên +1) | **200** |

## 3. Bảng quyết định (Decision Table) — Invoice Status

| Điều kiện | R1 | R2 | R3 | R4 | R5 |
|-----------|:--:|:--:|:--:|:--:|:--:|
| Trạng thái invoice | draft | draft | finalized | paid | void |
| Người thực hiện | landlord | landlord khác | landlord | tenant | landlord |
| Hành động | finalize | finalize | finalize | - | finalize |
| **Kết quả** | **200** | **403/404** | **400** | - | **400** |

---

## 4. Test Cases

### Meter Readings

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|:------:|:--------:|:--------:|
| BILL-01 | EP | Upsert meter reading thành công | POST | /api/billing/meter-readings | **200** |
| BILL-02 | DT | Upsert với tenant token | POST | /api/billing/meter-readings | **403** |
| BILL-03 | EP | Upsert month sai format (YYYY/MM) | POST | /api/billing/meter-readings | **400** |
| BILL-04 | BVA | Upsert newElectric < oldElectric | POST | /api/billing/meter-readings | **400** |
| BILL-05 | BVA | Upsert với oldElectric = 0 (biên) | POST | /api/billing/meter-readings | **200** |
| BILL-06 | BVA | Upsert với oldElectric = -1 (biên dưới) | POST | /api/billing/meter-readings | **400** |
| BILL-07 | BVA | Upsert newElectric = oldElectric (biên) | POST | /api/billing/meter-readings | **200** |
| BILL-08 | EP | Import meter readings từ file | POST | /api/billing/meter-readings/import | **200** |
| BILL-09 | EP | Import không gửi file | POST | /api/billing/meter-readings/import | **400** |

### Invoices

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|:------:|:--------:|:--------:|
| BILL-10 | EP | Preview invoices | POST | /api/billing/invoices/preview | **200** |
| BILL-11 | EP | Create invoices | POST | /api/billing/invoices | **201** |
| BILL-12 | DT | Finalize invoice (draft → finalized) | POST | /api/billing/invoices/:id/finalize | **200** |
| BILL-13 | DT | Finalize invoice đã finalized | POST | /api/billing/invoices/:id/finalize | **400** |
| BILL-14 | DT | Tenant call finalize | POST | /api/billing/invoices/:id/finalize | **403** |
| BILL-15 | EP | Update invoice với items | PATCH | /api/billing/invoices/:id | **200** |
| BILL-16 | EP | Get landlord invoices | GET | /api/billing/invoices/landlord | **200** |
| BILL-17 | EP | Get landlord invoices filter by month | GET | /api/billing/invoices/landlord?month=2026-05 | **200** |
| BILL-18 | EP | Get tenant invoices | GET | /api/billing/invoices/tenant | **200** |
| BILL-19 | EP | Get invoice detail | GET | /api/billing/invoices/:id | **200** |
| BILL-20 | EP | Get invoice detail không tồn tại | GET | /api/billing/invoices/:uuid | **404** |

---

## 5. Test Data

```typescript
export const billingTestData = {
  meterReading: (roomId: string) => ({
    roomId,
    month: '2026-05',
    oldElectric: 100,
    newElectric: 150,
    oldWater: 50,
    newWater: 70,
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
  // BVA - equal
  meterReadingEqual: (roomId: string) => ({
    roomId, month: '2026-05',
    oldElectric: 100, newElectric: 100, oldWater: 50, newWater: 50,
  }),
  // BVA - zero
  meterReadingZero: (roomId: string) => ({
    roomId, month: '2026-05',
    oldElectric: 0, newElectric: 0, oldWater: 0, newWater: 0,
  }),
  // BVA - negative
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
};
```
