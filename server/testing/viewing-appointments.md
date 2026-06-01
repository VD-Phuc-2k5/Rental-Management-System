# Viewing Appointments Module — Test Plan

**Endpoints:**
- Tenant: `/api/viewing-appointments`
- Landlord: `/api/landlord/viewing-appointments`

---

## 1. Phân lớp tương đương (Equivalence Partitioning)

| Lớp | Trường | Mô tả | Giá trị đại diện | Kết quả |
|-----|--------|-------|-----------------|:-------:|
| EP-01 | roomId | UUID hợp lệ | `uuid-v4` | Hợp lệ |
| EP-02 | roomId | Thiếu / rỗng | `""` | Không hợp lệ |
| EP-03 | scheduledAt | ISO8601 trong tương lai | `2026-06-15T10:00:00Z` | Hợp lệ |
| EP-04 | scheduledAt | ISO8601 trong quá khứ | `2020-01-01T10:00:00Z` | Không hợp lệ |
| EP-05 | scheduledAt | Sai format | `abc` | Không hợp lệ |
| EP-06 | note | Có note | `"Muon xem phong"` | Hợp lệ |
| EP-07 | note | Không có note | `undefined` | Hợp lệ |

## 2. Bảng quyết định (Decision Table)

### 2.1 Viewing Appointment Lifecycle

| Điều kiện | R1 | R2 | R3 | R4 | R5 | R6 | R7 |
|-----------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Trạng thái | pending | pending | pending | approved | approved | rejected | cancelled |
| Người thực hiện | landlord | landlord | landlord | landlord | tenant | landlord | tenant |
| Hành động | approve | reject | tenant khác | approve | cancel | reject | cancel |
| **Kết quả** | **200** | **200** | **403** | **400** | **204** | **400** | **400** |

---

## 3. Test Cases

### Tenant

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|:------:|:--------:|:--------:|
| VA-01 | EP | Create appointment thành công | POST | /api/viewing-appointments | **201** |
| VA-02 | EP | Create với room không tồn tại | POST | /api/viewing-appointments | **404** |
| VA-03 | EP | Create với scheduledAt trong quá khứ | POST | /api/viewing-appointments | **400** |
| VA-04 | EP | Create với scheduledAt sai format | POST | /api/viewing-appointments | **400** |
| VA-05 | DT | Create với landlord token | POST | /api/viewing-appointments | **403** |
| VA-06 | EP | Get my appointments | GET | /api/viewing-appointments/mine | **200** |
| VA-07 | DT | Cancel appointment thành công | DELETE | /api/viewing-appointments/:id | **204** |
| VA-08 | DT | Cancel appointment của tenant khác | DELETE | /api/viewing-appointments/:id | **403/404** |

### Landlord

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|:------:|:--------:|:--------:|
| VA-09 | EP | Get landlord appointments | GET | /api/landlord/viewing-appointments | **200** |
| VA-10 | DT | Approve (pending → approved) | POST | /api/landlord/viewing-appointments/:id/approve | **200** |
| VA-11 | DT | Approve đã approved | POST | /api/landlord/viewing-appointments/:id/approve | **400** |
| VA-12 | DT | Reject (pending → rejected) | POST | /api/landlord/viewing-appointments/:id/reject | **200** |
| VA-13 | DT | Reject với tenant token | POST | /api/landlord/viewing-appointments/:id/reject | **403** |

---

## 4. Test Data

```typescript
export const viewingAppointmentTestData = {
  valid: (roomId: string) => ({
    roomId,
    scheduledAt: new Date(Date.now() + 7 * 86400000).toISOString(),
  }),
  pastDate: (roomId: string) => ({
    roomId,
    scheduledAt: new Date(Date.now() - 86400000).toISOString(),
  }),
  invalidFormat: (roomId: string) => ({
    roomId,
    scheduledAt: 'invalid-date',
  }),
  missingRoomId: {
    scheduledAt: new Date(Date.now() + 86400000).toISOString(),
  },
};
```
