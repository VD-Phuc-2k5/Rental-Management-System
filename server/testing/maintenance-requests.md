# Maintenance Requests Module — Test Plan

**Endpoints:**
- Tenant: `/api/maintenance-requests`
- Landlord: `/api/landlord/maintenance-requests`

---

## 1. Phân lớp tương đương (Equivalence Partitioning)

### Create

| Lớp | Trường | Mô tả | Giá trị đại diện | Kết quả |
|-----|--------|-------|-----------------|:-------:|
| EP-01 | title | Chuỗi không rỗng | `"Den hu"` | Hợp lệ |
| EP-02 | title | Rỗng | `""` | Không hợp lệ |
| EP-03 | priority | `low` | `low` | Hợp lệ |
| EP-04 | priority | `medium` | `medium` | Hợp lệ |
| EP-05 | priority | `high` | `high` | Hợp lệ |
| EP-06 | priority | Không hợp lệ | `urgent` | Không hợp lệ |
| EP-07 | description | Có description | `"Den phong toi bi hong"` | Hợp lệ |
| EP-08 | description | Không có | `undefined` | Hợp lệ |
| EP-09 | imageUrls | Có ảnh | `["https://..."]` | Hợp lệ |
| EP-10 | imageUrls | Không có ảnh | `undefined` | Hợp lệ |

### Status

| Lớp | Trạng thái | Có thể chuyển đến |
|-----|-----------|------------------|
| EP-11 | pending | processing (landlord), completed (tenant), rejected (landlord) |
| EP-12 | processing | completed (tenant) |
| EP-13 | completed | complaint (tenant) |
| EP-14 | rejected | (terminal) |
| EP-15 | complaint | (terminal) |

### Complaint

| Lớp | Trường | Mô tả | Giá trị đại diện | Kết quả |
|-----|--------|-------|-----------------|:-------:|
| EP-16 | complaintDescription | >= 3 ký tự | `"Da sua nhung van hong"` | Hợp lệ |
| EP-17 | complaintDescription | < 3 ký tự | `"ab"` | Không hợp lệ |

## 2. Phân tích giá trị biên (Boundary Value Analysis)

### complaintDescription (`@MinLength(3)`)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| BVA-01 | `""` | 0 | Biên dưới - 3 | **400** |
| BVA-02 | `"a"` | 1 | Biên dưới - 2 | **400** |
| BVA-03 | `"ab"` | 2 | Biên dưới - 1 | **400** |
| BVA-04 | `"abc"` | 3 | Biên dưới (min) | **200** |
| BVA-05 | `"abcd"` | 4 | Biên dưới + 1 | **200** |

## 3. Bảng quyết định (Decision Table) — Maintenance Status

| Điều kiện | R1 | R2 | R3 | R4 | R5 | R6 | R7 |
|-----------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| Trạng thái | pending | pending | pending | processing | completed | completed | pending |
| Người thực hiện | landlord | landlord | tenant | tenant | tenant | tenant | tenant khác |
| Hành động | update→processing | update→completed | complete | complete | complete | complaint | complete |
| **Kết quả** | **200** | **400** | **200** | **200** | **400** | **200** | **403/404** |

---

## 4. Test Cases

### Tenant

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|:------:|:--------:|:--------:|
| MR-01 | EP | Create maintenance request thành công | POST | /api/maintenance-requests | **201** |
| MR-02 | EP | Create với images | POST | /api/maintenance-requests | **201** |
| MR-03 | DT | Create với landlord token | POST | /api/maintenance-requests | **403** |
| MR-04 | EP | Create thiếu title | POST | /api/maintenance-requests | **400** |
| MR-05 | EP | Create với priority không hợp lệ | POST | /api/maintenance-requests | **400** |
| MR-06 | EP | Get my maintenance requests | GET | /api/maintenance-requests/mine | **200** |
| MR-07 | EP | Get detail thành công | GET | /api/maintenance-requests/:id | **200** |
| MR-08 | DT | Get detail của tenant khác | GET | /api/maintenance-requests/:id | **403/404** |
| MR-09 | DT | Complete (processing → completed) | PATCH | /api/maintenance-requests/:id/complete | **200** |
| MR-10 | DT | Complete khi đã completed | PATCH | /api/maintenance-requests/:id/complete | **400** |
| MR-11 | EP | Submit complaint thành công | PATCH | /api/maintenance-requests/:id/complaint | **200** |
| MR-12 | BVA | Submit complaint 2 ký tự (biên dưới -1) | PATCH | /api/maintenance-requests/:id/complaint | **400** |
| MR-13 | BVA | Submit complaint 3 ký tự (min) | PATCH | /api/maintenance-requests/:id/complaint | **200** |

### Landlord

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|:------:|:--------:|:--------:|
| MR-14 | EP | Get all requests | GET | /api/landlord/maintenance-requests | **200** |
| MR-15 | DT | Get with tenant token | GET | /api/landlord/maintenance-requests | **403** |
| MR-16 | DT | Update status (pending → processing) | PATCH | /api/landlord/maintenance-requests/:id/status | **200** |
| MR-17 | EP | Update status không hợp lệ | PATCH | /api/landlord/maintenance-requests/:id/status | **400** |
| MR-18 | DT | Update status với tenant token | PATCH | /api/landlord/maintenance-requests/:id/status | **403** |
| MR-19 | EP | Schedule maintenance | PATCH | /api/landlord/maintenance-requests/:id/schedule | **200** |

---

## 5. Test Data

```typescript
export const maintenanceTestData = {
  valid: {
    title: 'Den bi hong',
    description: 'Den phong toi bi hong, khong bat duoc',
    priority: 'high',
    location: 'Phong 101',
  },
  validWithImages: {
    title: 'May nuoc nong hong',
    description: 'Khong co nuoc nong',
    priority: 'medium',
    imageUrls: ['https://storage.example.com/maintenance/img.jpg'],
  },
  missingTitle: { description: 'Test' },
  invalidPriority: { title: 'Test', priority: 'urgent' },
  // BVA for complaintDescription
  complaint: { complaintDescription: 'Da sua nhung khong het, van bi hong' },
  complaintMin: { complaintDescription: 'abc' },
  complaintTooShort: { complaintDescription: 'ab' },
  updateStatus: { status: 'processing' },
  invalidStatus: { status: 'invalid_status' },
  schedule: {
    technicianName: 'Nguyen Van Sua',
    technicianPhone: '0909888777',
    scheduledAt: new Date(Date.now() + 3 * 86400000).toISOString(),
    landlordNote: 'Da lien he voi tho',
  },
};
```
