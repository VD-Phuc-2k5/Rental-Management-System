# Rental Requests & Contracts Module — Test Plan

**Endpoints:**
- Rental Requests: `/api/rental-requests`, `/api/landlord/rental-requests`
- Contracts: `/api/contracts`, `/api/landlord/contracts`

---

## 1. Phân lớp tương đương (Equivalence Partitioning)

### Create Rental Request

| Lớp | Trường | Mô tả | Giá trị đại diện | Kết quả |
|-----|--------|-------|-----------------|:-------:|
| EP-01 | roomId | UUID hợp lệ | `uuid-v4` | Hợp lệ |
| EP-02 | roomId | Thiếu / rỗng | `""` | Không hợp lệ |
| EP-03 | note | Có note | `"Muon xem phong"` | Hợp lệ |
| EP-04 | note | Không có note | `undefined` | Hợp lệ |
| EP-05 | memberInfo | Có member | `[{ fullName, isRoomLeader }]` | Hợp lệ |
| EP-06 | memberInfo | Không có member | `undefined` | Hợp lệ |
| EP-07 | parkingInfo | Có xe | `[{ type, plate, quantity }]` | Hợp lệ |
| EP-08 | parkingInfo | Không có xe | `undefined` | Hợp lệ |

### Contract Status Transitions (State Machine)

| Trạng thái | Có thể send? | Có thể sign? | Có thể cancel? | Có thể finish? |
|------------|:------------:|:------------:|:--------------:|:--------------:|
| draft | Y (landlord) | N | N | N |
| sent | N | Y (tenant) | Y (tenant) | N |
| signed | N | N | N | Y (landlord) |
| cancelled | N | N | N | N |
| finished | N | N | N | N |

---

## 2. Bảng quyết định (Decision Table)

### 2.1 Rental Request Lifecycle

| Điều kiện | R1 | R2 | R3 | R4 | R5 | R6 |
|-----------|:--:|:--:|:--:|:--:|:--:|:--:|
| Trạng thái | pending | pending | pending | accepted | rejected | cancelled |
| Người thực hiện | tenant | landlord | tenant khác | tenant | tenant | tenant |
| Hành động | cancel | reject | cancel | cancel | cancel | cancel |
| **Kết quả** | **204** | **200** | **403/404** | **400** | **400** | **400** |

### 2.2 Contract Lifecycle

| Điều kiện | R1 | R2 | R3 | R4 | R5 | R6 | R7 | R8 |
|-----------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Trạng thái | draft | draft | sent | sent | signed | signed | cancelled | finished |
| Người thực hiện | landlord | tenant | tenant | tenant | tenant | landlord | tenant | landlord |
| Hành động | send | sign | sign | cancel | cancel | finish | cancel | finish |
| **Kết quả** | **200** | **400** | **200** | **200** | **200** | **200** | **400** | **400** |

---

## 3. Test Cases

### Rental Requests (Tenant)

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|:------:|:--------:|:--------:|
| RR-01 | EP | Create rental request thành công (chỉ roomId) | POST | /api/rental-requests | **201** |
| RR-02 | EP | Create rental request với memberInfo + parkingInfo | POST | /api/rental-requests | **201** |
| RR-03 | EP | Create với room không tồn tại | POST | /api/rental-requests | **404** |
| RR-04 | EP | Create thiếu roomId | POST | /api/rental-requests | **400** |
| RR-05 | DT | Create với landlord token | POST | /api/rental-requests | **403** |
| RR-06 | EP | Get my rental requests | GET | /api/rental-requests/mine | **200** |
| RR-07 | EP | Get rental request by ID | GET | /api/rental-requests/:id | **200** |
| RR-08 | DT | Get rental request của tenant khác | GET | /api/rental-requests/:id | **403/404** |
| RR-09 | DT | Cancel rental request (pending → cancelled) | DELETE | /api/rental-requests/:id | **204** |
| RR-10 | DT | Cancel rental request đã cancelled | DELETE | /api/rental-requests/:id | **400** |
| RR-11 | DT | Cancel rental request của tenant khác | DELETE | /api/rental-requests/:id | **403/404** |

### Landlord Rental Requests

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|:------:|:--------:|:--------:|
| RR-12 | EP | Get incoming requests | GET | /api/landlord/rental-requests | **200** |
| RR-13 | DT | Get incoming requests với tenant token | GET | /api/landlord/rental-requests | **403** |
| RR-14 | DT | Reject rental request (pending → rejected) | PATCH | /api/landlord/rental-requests/:id/reject | **200** |
| RR-15 | DT | Tenant gọi reject | PATCH | /api/landlord/rental-requests/:id/reject | **403** |
| RR-16 | EP | Get contract by rental request | GET | /api/landlord/rental-requests/:rrId/contract | **200** |
| RR-17 | EP | Get contract by rental request không tồn tại | GET | /api/landlord/rental-requests/:uuid/contract | **404** |

### Contracts (Tenant)

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|:------:|:--------:|:--------:|
| CON-01 | EP | Get my contracts | GET | /api/contracts/mine | **200** |
| CON-02 | EP | Get contract detail | GET | /api/contracts/:id | **200** |
| CON-03 | DT | Get contract detail của user khác | GET | /api/contracts/:id | **403/404** |
| CON-04 | DT | Sign contract (sent → signed) | POST | /api/contracts/:id/sign | **200** |
| CON-05 | DT | Sign contract đã signed | POST | /api/contracts/:id/sign | **400** |
| CON-06 | DT | Sign contract ở trạng thái draft | POST | /api/contracts/:id/sign | **400** |
| CON-07 | DT | Cancel contract (sent → cancelled) | POST | /api/contracts/:id/cancel | **200** |
| CON-08 | EP | Get contract members | GET | /api/contracts/:id/members | **200** |
| CON-09 | EP | Remove contract member | DELETE | /api/contracts/:cId/members/:mId | **204** |

### Contracts (Landlord)

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|:------:|:--------:|:--------:|
| CON-10 | EP | Get landlord contracts | GET | /api/landlord/contracts | **200** |
| CON-11 | EP | Update contract | PATCH | /api/landlord/contracts/:id | **200** |
| CON-12 | DT | Send contract (draft → sent) | POST | /api/landlord/contracts/:id/send | **200** |
| CON-13 | DT | Send contract đã sent | POST | /api/landlord/contracts/:id/send | **400** |
| CON-14 | DT | Finish contract (signed → finished) | POST | /api/landlord/contracts/:id/finish | **200** |
| CON-15 | DT | Finish contract ở trạng thái draft | POST | /api/landlord/contracts/:id/finish | **400** |

---

## 4. Test Data

```typescript
export const rentalRequestTestData = {
  valid: (roomId: string) => ({
    roomId,
    note: 'Muon xem phong de o',
  }),
  validWithMembers: (roomId: string) => ({
    roomId,
    note: 'O chung voi ban',
    memberInfo: [{
      fullName: 'Le Van C',
      phone: '0909111222',
      identityNumber: '123456789013',
      email: 'levanc@test.com',
      isRoomLeader: false,
    }],
    parkingInfo: [{ type: 'Xe may', plate: '59A1-12345', quantity: 1 }],
  }),
  missingRoomId: {},
};

export const contractTestData = {
  update: {
    startDate: '2026-06-01',
    endDate: '2027-06-01',
    monthlyRent: '3200000',
    deposit: '6400000',
    terms: 'Khong duoc nuoi thu cung',
  },
};
```
