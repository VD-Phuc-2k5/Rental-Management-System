# Auth Module — Test Plan

**Endpoints:** `/api/auth/*`

---

## 1. Phân lớp tương đương (Equivalence Partitioning)

### 1.1 Register — Email

| Lớp | Mô tả | Giá trị đại diện | Kết quả |
|-----|-------|-----------------|:-------:|
| EP-01 | Email đúng format | `tenant@test.com` | Hợp lệ |
| EP-02 | Email sai format (thiếu @) | `invalid` | Không hợp lệ |
| EP-03 | Email rỗng | `""` | Không hợp lệ |

### 1.2 Register — Password

| Lớp | Mô tả | Giá trị đại diện | Kết quả |
|-----|-------|-----------------|:-------:|
| EP-04 | Đủ hoa/thường/số/đặc biệt, 8-72 ký tự | `Test@1234` | Hợp lệ |
| EP-05 | Thiếu ký tự đặc biệt | `Aa111111` | Không hợp lệ |
| EP-06 | Thiếu chữ hoa | `test@1111` | Không hợp lệ |
| EP-07 | Thiếu chữ thường | `TEST@1111` | Không hợp lệ |
| EP-08 | Thiếu số | `Test@Test` | Không hợp lệ |
| EP-09 | Không gửi password | `undefined` | Không hợp lệ |

### 1.3 Register — Phone

| Lớp | Mô tả | Giá trị đại diện | Kết quả |
|-----|-------|-----------------|:-------:|
| EP-10 | 10-15 chữ số | `0912345678` | Hợp lệ |
| EP-11 | Có chứa chữ | `abc123` | Không hợp lệ |
| EP-12 | Không gửi phone | `undefined` | Hợp lệ (optional) |

### 1.4 Register — fullName

| Lớp | Mô tả | Giá trị đại diện | Kết quả |
|-----|-------|-----------------|:-------:|
| EP-13 | 2-100 ký tự, không khoảng trắng đầu | `Nguyen Van A` | Hợp lệ |
| EP-14 | Rỗng | `""` | Không hợp lệ |

### 1.5 Register — accepted_terms

| Lớp | Mô tả | Giá trị đại diện | Kết quả |
|-----|-------|-----------------|:-------:|
| EP-15 | `true` | `true` | Hợp lệ |
| EP-16 | `false` | `false` | Không hợp lệ |

### 1.6 Login

| Lớp | Mô tả | Giá trị đại diện | Kết quả |
|-----|-------|-----------------|:-------:|
| EP-17 | Email + password đúng | `{ tenant đã đăng ký }` | Thành công |
| EP-18 | Email sai | `wrong@test.com` | Thất bại |
| EP-19 | Password sai | password sai | Thất bại |
| EP-20 | Email rỗng | `{ email: "" }` | Không hợp lệ |

---

## 2. Phân tích giá trị biên (Boundary Value Analysis)

### 2.1 Password length (`@MinLength(8) @MaxLength(72)`)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| BVA-01 | `A1@bcde` | 7 | Biên dưới - 1 | **400** |
| BVA-02 | `A1@bcdef` | 8 | Biên dưới (min) | **201** |
| BVA-03 | `A1@bcdefg` | 9 | Biên dưới + 1 | **201** |
| BVA-04 | `A1@` + `a`*68 | 71 | Biên trên - 1 | **201** |
| BVA-05 | `A1@` + `a`*69 | 72 | Biên trên (max) | **201** |
| BVA-06 | `A1@` + `a`*70 | 73 | Biên trên + 1 | **400** |

### 2.2 Phone length (`@Length(10, 15)`)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| BVA-07 | `012345678` | 9 | Biên dưới - 1 | **400** |
| BVA-08 | `0123456789` | 10 | Biên dưới (min) | **201** |
| BVA-09 | `01234567890` | 11 | Biên dưới + 1 | **201** |
| BVA-10 | `012345678901234` | 15 | Biên trên (max) | **201** |
| BVA-11 | `0123456789012345` | 16 | Biên trên + 1 | **400** |

### 2.3 fullName length (`@MinLength(2) @MaxLength(100)`)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| BVA-12 | `""` | 0 | Biên dưới - 2 | **400** |
| BVA-13 | `"A"` | 1 | Biên dưới - 1 | **400** |
| BVA-14 | `"An"` | 2 | Biên dưới (min) | **201** |
| BVA-15 | `"A"*99` | 99 | Biên trên - 1 | **201** |
| BVA-16 | `"A"*100` | 100 | Biên trên (max) | **201** |
| BVA-17 | `"A"*101` | 101 | Biên trên + 1 | **400** |

### 2.4 identity_number length (`@Length(12, 12)`)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| BVA-18 | `"1"*11` | 11 | Biên dưới - 1 | **400** |
| BVA-19 | `"1"*12` | 12 | Biên (chính xác) | **201** |
| BVA-20 | `"1"*13` | 13 | Biên trên + 1 | **400** |

---

## 3. Bảng quyết định (Decision Table)

### 3.1 Access Control (AuthGuard + RolesGuard)

| Điều kiện | Rule 1 | Rule 2 | Rule 3 | Rule 4 | Rule 5 | Rule 6 |
|-----------|:------:|:------:|:------:|:------:|:------:|:------:|
| Có token? | Y | Y | Y | N | Y | Y |
| Token hợp lệ? | Y | Y | Y | - | N | Y |
| Role phù hợp? | Y | N | Y | - | - | N/A |
| Endpoint public? | N | N | N | Y/N | Y/N | Y |
| **Kết quả** | **200/201** | **403** | **401/403** | **401** | **401** | **200** |

### 3.2 Reset Password Flow

| Điều kiện | Rule 1 | Rule 2 | Rule 3 | Rule 4 |
|-----------|:------:|:------:|:------:|:------:|
| Email tồn tại? | Y | N | Y | Y |
| OTP đúng? | Y | - | N | - |
| New password hợp lệ? | Y | - | - | N |
| **Kết quả forgot-password** | **201** | **201** (bảo mật) | - | - |
| **Kết quả reset-password** | **201** | - | **400** | **400** |

---

## 4. Test Cases

### Register

| ID | Kỹ thuật | Test Case | Input | Expected Status | Expected Data |
|----|:---------:|-----------|-------|:---------------:|---------------|
| AUTH-001 | EP | Register tenant thành công | `{ email, fullName, phone, password, confirm_password, accepted_terms }` với email mới | **201** | `data.role = "tenant"` |
| AUTH-002 | EP | Register landlord thành công | `{...validLandlord}` | **201** | `data.role = "landlord"` |
| AUTH-003 | EP | Email đã tồn tại | email từ AUTH-001 | **400/409** | message lỗi |
| AUTH-004 | EP | Email sai format | `{...valid, email: "invalid"}` | **400** | Validation error |
| AUTH-005 | EP | Email rỗng | `{...valid, email: ""}` | **400** | Validation error |
| AUTH-006 | EP | Thiếu password | `{...valid, password: undefined}` | **400** | Validation error |
| AUTH-007 | EP | Password yếu (thiếu ký tự đặc biệt) | `{...valid, password: "Aa111111", confirm_password: "Aa111111"}` | **400** | `Mật khẩu phải có chữ hoa, chữ thường, số và ký tự đặc biệt` |
| AUTH-008 | EP | Password confirm không khớp | `{...valid, confirm_password: "Bb222222@"}` | **400** | Validation error |
| AUTH-009 | EP | Không đồng ý điều khoản | `{...valid, accepted_terms: false}` | **400** | Validation error |
| AUTH-010 | EP | Phone chứa chữ | `{...valid, phone: "abc123"}` | **400** | `Số điện thoại chỉ được chứa chữ số` |
| AUTH-011 | EP | fullName rỗng | `{...valid, fullName: ""}` | **400** | Validation error |
| AUTH-012 | BVA | Password 7 ký tự | `{...valid, password: "A1@bcde", confirm_password: "A1@bcde"}` | **400** | Validation error |
| AUTH-013 | BVA | Password 8 ký tự (min) | `{...valid, password: "A1@bcdef", confirm_password: "A1@bcdef"}` | **201** | Thành công |
| AUTH-014 | BVA | Password 72 ký tự (max) | `{...valid, password: "A1@"+"a"*69, confirm_password: "A1@"+"a"*69}` | **201** | Thành công |
| AUTH-015 | BVA | Password 73 ký tự | `{...valid, password: "A1@"+"a"*70, confirm_password: "A1@"+"a"*70}` | **400** | Validation error |
| AUTH-016 | BVA | Phone 9 số | `{...valid, phone: "012345678"}` | **400** | Validation error |
| AUTH-017 | BVA | Phone 10 số (min) | `{...valid, phone: "0123456789"}` | **201** | Thành công |
| AUTH-018 | BVA | Phone 15 số (max) | `{...valid, phone: "012345678901234"}` | **201** | Thành công |
| AUTH-019 | BVA | Phone 16 số | `{...valid, phone: "0123456789012345"}` | **400** | Validation error |
| AUTH-020 | BVA | fullName 1 ký tự | `{...valid, fullName: "A"}` | **400** | Validation error |
| AUTH-021 | BVA | fullName 100 ký tự (max) | `{...valid, fullName: "A"*100}` | **201** | Thành công |
| AUTH-022 | BVA | fullName 101 ký tự | `{...valid, fullName: "A"*101}` | **400** | Validation error |
| AUTH-023 | BVA | identity_number 11 số | `{...validLandlord, identity_number: "1"*11}` | **400** | Validation error |
| AUTH-024 | BVA | identity_number 12 số | `{...validLandlord}` | **201** | Thành công |
| AUTH-025 | BVA | identity_number 13 số | `{...validLandlord, identity_number: "1"*13}` | **400** | Validation error |

### Login

| ID | Kỹ thuật | Test Case | Input | Expected Status | Expected Data |
|----|:---------:|-----------|-------|:---------------:|---------------|
| AUTH-026 | EP | Login tenant thành công | `{ email, password }` từ AUTH-001 | **201** | `data.token`, `data.user.roles` chứa "tenant" |
| AUTH-027 | EP | Login landlord thành công | `{ email, password }` từ AUTH-002 | **201** | `data.token`, `data.user.roles` chứa "landlord" |
| AUTH-028 | EP | Login sai email | `{ email: "wrong@test.com", password: "Test@1234" }` | **401** | Unauthorized |
| AUTH-029 | EP | Login sai password | `{ email, password: "WrongPass1@" }` | **401** | Unauthorized |
| AUTH-030 | EP | Login email rỗng | `{ email: "", password: "Test@1234" }` | **400** | Validation error |

### Forgot / Reset Password

| ID | Kỹ thuật | Test Case | Input | Expected Status |
|----|:---------:|-----------|-------|:---------------:|
| AUTH-031 | EP | Forgot password thành công | `{ email }` | **201** |
| AUTH-032 | EP | Forgot password email không tồn tại | `{ email: "notfound@test.com" }` | **201** |
| AUTH-033 | EP | Forgot password thiếu email | `{}` | **400** |
| AUTH-034 | EP | Confirm OTP thành công | `{ email, otp: "123456" }` | **201** |
| AUTH-035 | EP | Confirm OTP sai | `{ email, otp: "000000" }` | **400** |
| AUTH-036 | EP | Confirm OTP sai độ dài | `{ email, otp: "12345" }` | **400** |
| AUTH-037 | EP | Reset password thành công | `{ email, otp, newPassword: "NewPass1@", confirmPassword: "NewPass1@" }` | **201** |
| AUTH-038 | EP | Reset password OTP sai | `{ email, otp: "000000", newPassword: "NewPass1@", confirmPassword: "NewPass1@" }` | **400** |
| AUTH-039 | EP | Reset password newPassword yếu | `{ email, otp, newPassword: "weak", confirmPassword: "weak" }` | **400** |
| AUTH-040 | EP | Reset password confirm không khớp | `{ email, otp, newPassword: "NewPass1@", confirmPassword: "Diff1@ent" }` | **400** |
| AUTH-041 | DT | Login password cũ sau reset | password cũ | **401** |
| AUTH-042 | DT | Login password mới sau reset | password mới | **201** |

### Access Control

| ID | Kỹ thuật | Test Case | Token | Endpoint | Expected Status |
|----|:---------:|-----------|:-----:|:--------:|:---------------:|
| AUTH-043 | DT | Endpoint public không cần auth | - | GET /api/users/:id | **200** |
| AUTH-044 | DT | Endpoint cần auth không token | - | POST /api/properties | **401** |
| AUTH-045 | DT | Token rỗng | `"Bearer "` | POST /api/properties | **401** |
| AUTH-046 | DT | Token giả mạo | `"Bearer fake"` | GET /api/profile | **401** |
| AUTH-047 | DT | Tenant gọi endpoint landlord | tenant | POST /api/properties | **403** |
| AUTH-048 | DT | Landlord gọi endpoint tenant | landlord | POST /api/rental-requests | **403** |

---

## 5. Test Data

```typescript
export const authTestData = {
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
  // BVA for password
  passwordTooShort: 'A1@bcde',         // 7 chars -> invalid
  passwordMin: 'A1@bcdef',             // 8 chars -> valid
  passwordMax: 'A1@' + 'a'.repeat(69), // 72 chars -> valid
  passwordTooLong: 'A1@' + 'a'.repeat(70), // 73 chars -> invalid
  // BVA for phone
  phoneTooShort: '012345678',           // 9 chars
  phoneMin: '0123456789',               // 10 chars
  phoneMax: '012345678901234',          // 15 chars
  phoneTooLong: '0123456789012345',     // 16 chars
  // BVA for fullName
  nameMin: 'An',                        // 2 chars
  nameMax: 'A'.repeat(100),             // 100 chars
  nameTooLong: 'A'.repeat(101),         // 101 chars
  // BVA for identity number
  identityTooShort: '1'.repeat(11),
  identityValid: '1'.repeat(12),
  identityTooLong: '1'.repeat(13),
};
```
