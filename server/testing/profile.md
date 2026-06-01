# Profile Module — Test Plan

**Endpoints:** `/api/profile`

---

## 1. Phân lớp tương đương (Equivalence Partitioning)

| Lớp | Trường | Mô tả | Giá trị đại diện | Kết quả |
|-----|--------|-------|-----------------|:-------:|
| EP-01 | fullName | Hợp lệ, 2-100 ký tự | `Nguyen Van B` | Hợp lệ |
| EP-02 | phone | Hợp lệ, 10-15 số | `0909123456` | Hợp lệ |
| EP-03 | avatarUrl | URL hợp lệ | `https://example.com/avatar.png` | Hợp lệ |
| EP-04 | dateOfBirth | Chuỗi ngày tháng | `1995-06-15` | Hợp lệ |
| EP-05 | Tất cả | Body rỗng (không thay đổi) | `{}` | Hợp lệ |

## 2. Bảng quyết định (Decision Table) — Access Control

| Điều kiện | Rule 1 | Rule 2 | Rule 3 |
|-----------|:------:|:------:|:------:|
| Có token hợp lệ? | Y | N | Y |
| Method | GET | GET | PATCH |
| **Kết quả** | **200** | **401** | **200** |

| Điều kiện | Rule 4 | Rule 5 |
|-----------|:------:|:------:|
| Có token hợp lệ? | N | Y |
| Method | PATCH | PATCH |
| Body | - | `{}` |
| **Kết quả** | **401** | **200** |

---

## 3. Test Cases

| ID | Kỹ thuật | Test Case | Method | Token | Body | Expected Status | Expected Data |
|----|:---------:|-----------|:------:|:----:|:----:|:---------------:|---------------|
| PROF-01 | EP | Get profile thành công | GET | Y | - | **200** | `data.id`, `data.fullName`, `data.phone` |
| PROF-02 | DT | Get profile không có token | GET | N | - | **401** | Unauthorized |
| PROF-03 | EP | Update profile thành công | PATCH | Y | `{ fullName: "Nguyen Van B", phone: "0909123456", avatarUrl: "https://example.com/avatar-new.png", dateOfBirth: "1995-06-15" }` | **200** | `data.fullName = "Nguyen Van B"` |
| PROF-04 | EP | Update profile dữ liệu trống | PATCH | Y | `{}` | **200** | Không thay đổi |
| PROF-05 | DT | Update profile không có token | PATCH | N | `{ fullName: "Test" }` | **401** | Unauthorized |
| PROF-06 | EP | Get profile sau update phản ánh đúng | GET | Y | - | **200** | Dữ liệu khớp với PROF-03 |

---

## 4. Test Data

```typescript
export const profileTestData = {
  update: {
    fullName: 'Nguyen Van B',
    phone: '0909123456',
    avatarUrl: 'https://example.com/avatar-new.png',
    dateOfBirth: '1995-06-15',
  },
};
```
