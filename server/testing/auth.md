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

### 1.6 Register — identity_number

| Lớp | Mô tả | Giá trị đại diện | Kết quả |
|-----|-------|-----------------|:-------:|
| EP-17 | 12 số | `"123456789012"` | Hợp lệ |
| EP-18 | Không gửi identity_number | `undefined` | Hợp lệ (optional) |

### 1.7 Register — Business Logic (service layer)

| Lớp | Mô tả | Giá trị đại diện | Kết quả |
|-----|-------|-----------------|:-------:|
| EP-19 | Phone không được gửi → bỏ qua check | `phone: undefined` | Service bỏ qua check phone |
| EP-20 | Identity không được gửi → bỏ qua check | `identity_number: undefined` | Service bỏ qua check identity |
| EP-21 | BadRequestException từ create → re-throw | userRepository throws BadRequestException | **400** |

### 1.8 Login

| Lớp | Mô tả | Giá trị đại diện | Kết quả |
|-----|-------|-----------------|:-------:|
| EP-22 | Email + password đúng | `{ tenant đã đăng ký }` | Thành công |
| EP-23 | Email sai | `wrong@test.com` | Thất bại |
| EP-24 | Password sai | password sai | Thất bại |
| EP-25 | Email rỗng | `{ email: "" }` | Không hợp lệ |

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

**e2e Test Cases:**

| ID | Test Case | Input | Expected Status |
|:--:|----------|-------|:---------------:|
| AUTH-012 | Password 7 chars (min-1) | `{...valid, password: "A1@bcde"}` | **400** |
| AUTH-013 | Password 8 chars (min) | `{...valid, password: "A1@bcdef"}` | **201** |
| AUTH-053 | Password 9 chars (min+1) | `{...valid, password: "A1@bcdefg"}` | **201** |
| AUTH-054 | Password 71 chars (max-1) | `{...valid, password: "A1@"+"a"*68}` | **201** |
| AUTH-014 | Password 72 chars (max) | `{...valid, password: "A1@"+"a"*69}` | **201** |
| AUTH-015 | Password 73 chars (max+1) | `{...valid, password: "A1@"+"a"*70}` | **400** |

### 2.2 Phone length (`@Length(10, 15)`)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| BVA-07 | `012345678` | 9 | Biên dưới - 1 | **400** |
| BVA-08 | `0123456789` | 10 | Biên dưới (min) | **201** |
| BVA-09 | `01234567890` | 11 | Biên dưới + 1 | **201** |
| BVA-10 | `012345678901234` | 15 | Biên trên (max) | **201** |
| BVA-11 | `0123456789012345` | 16 | Biên trên + 1 | **400** |

**e2e Test Cases:**

| ID | Test Case | Input | Expected Status |
|:--:|----------|-------|:---------------:|
| AUTH-016 | Phone 9 chars (min-1) | `{...valid, phone: "012345678"}` | **400** |
| AUTH-017 | Phone 10 chars (min) | `{...valid, phone: "0123456789"}` | **201** |
| AUTH-055 | Phone 11 chars (min+1) | `{...valid, phone: "01234567890"}` | **201** |
| AUTH-018 | Phone 15 chars (max) | `{...valid, phone: "012345678901234"}` | **201** |
| AUTH-019 | Phone 16 chars (max+1) | `{...valid, phone: "0123456789012345"}` | **400** |

### 2.3 fullName length (`@MinLength(2) @MaxLength(100)`)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| BVA-12 | `""` | 0 | Biên dưới - 2 | **400** |
| BVA-13 | `"A"` | 1 | Biên dưới - 1 | **400** |
| BVA-14 | `"An"` | 2 | Biên dưới (min) | **201** |
| BVA-15 | `"A"*99` | 99 | Biên trên - 1 | **201** |
| BVA-16 | `"A"*100` | 100 | Biên trên (max) | **201** |
| BVA-17 | `"A"*101` | 101 | Biên trên + 1 | **400** |

**e2e Test Cases:**

| ID | Test Case | Input | Expected Status |
|:--:|----------|-------|:---------------:|
| AUTH-020 | fullName 1 char (min-1) | `{...valid, fullName: "A"}` | **400** |
| AUTH-056 | fullName 2 chars (min) | `{...valid, fullName: "An"}` | **201** |
| AUTH-057 | fullName 99 chars (max-1) | `{...valid, fullName: "A"*99}` | **201** |
| AUTH-021 | fullName 100 chars (max) | `{...valid, fullName: "A"*100}` | **201** |
| AUTH-022 | fullName 101 chars (max+1) | `{...valid, fullName: "A"*101}` | **400** |

### 2.4 identity_number length (`@Length(12, 12)`)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| BVA-18 | `"1"*11` | 11 | Biên dưới - 1 | **400** |
| BVA-19 | `"1"*12` | 12 | Biên (chính xác) | **201** |
| BVA-20 | `"1"*13` | 13 | Biên trên + 1 | **400** |

**e2e Test Cases:**

| ID | Test Case | Input | Expected Status |
|:--:|----------|-------|:---------------:|
| AUTH-023 | identity_number 11 chars (exact-1) | `{...validLandlord, identity_number: "1"*11}` | **400** |
| AUTH-024 | identity_number 12 chars (exact) | `{...validLandlord}` | **201** |
| AUTH-025 | identity_number 13 chars (exact+1) | `{...validLandlord, identity_number: "1"*13}` | **400** |

### 2.5 OTP length (`@Length(6, 6)`)

| ID | Test Case | Input | Expected Status |
|:--:|----------|-------|:---------------:|
| AUTH-036 | OTP 5 chars (min-1) | `{ email, otp: "12345" }` | **400** |
| AUTH-058 | OTP 6 chars (exact) | `{ email, otp: "123456" }` with valid Redis | **201** |
| AUTH-059 | OTP 7 chars (max+1) | `{ email, otp: "1234567" }` | **400** |

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

**e2e Test Cases:**

| ID | Test Case | Token | Endpoint | Expected Status |
|:--:|----------|:-----:|:--------:|:---------------:|
| AUTH-047 | Public endpoint không cần auth | — | GET /api/users/:id | **200** |
| AUTH-048 | Protected endpoint không token | — | GET /api/profile | **401** |
| AUTH-049 | Empty Bearer token | `"Bearer "` | GET /api/profile | **401** |
| AUTH-050 | Fake Bearer token | `"Bearer fake"` | GET /api/profile | **401** |
| AUTH-051 | RolesGuard cho phép đúng role | valid token | GET /api/test-roles/tenant | **200** |
| AUTH-052 | RolesGuard từ chối sai role | valid token | GET /api/test-roles/admin | **403** |

### 3.2 Reset Password Flow — forgot-password

| Điều kiện | Rule 1 | Rule 2 | Rule 3 | Rule 4 |
|-----------|:------:|:------:|:------:|:------:|
| Email tồn tại? | Y | N | Y | Y |
| OTP Redis set thành công? | Y | Y | N | Y |
| AuthOperationError? | N | N | N | Y |
| **Kết quả** | **201** (gửi email) | **201** (không gửi email) | **500** | **400** |

### 3.3 Reset Password Flow — Verify OTP

| Điều kiện | Rule 1 | Rule 2 | Rule 3 |
|-----------|:------:|:------:|:------:|
| OTP trong Redis? | Y | N | Y |
| OTP đúng? | Y | - | N |
| **Kết quả** | **201** (đánh dấu verified) | **400** | **400** |

### 3.4 Reset Password Flow — reset-password

| Điều kiện | Rule 1 | Rule 2 | Rule 3 | Rule 4 | Rule 5 |
|-----------|:------:|:------:|:------:|:------:|:------:|
| Password == confirmPassword? | Y | N | Y | Y | Y |
| OTP trong Redis? | Y | - | Y | Y | Y |
| OTP đúng? | Y | - | N | N | Y |
| isVerified = true? | - | - | N | Y | - |
| User tồn tại? | Y | - | - | Y | N |
| AuthOperationError? | N | - | - | N | - |
| **Kết quả** | **201** | **400** | **400** | **201** (⚠ bypass OTP) | **400** |

> ⚠ **Lưu ý bảo mật (Rule 4):** Nếu OTP đã được verify qua endpoint `/auth/confirm-otp`, thì ở bước reset-password, OTP có thể sai nhưng vẫn cho qua vì `isVerified=true`. Đây là behavior hiện tại: một trong hai điều kiện (OTP đúng OR đã verify) là đủ. Cần cân nhắc: nếu attacker có quyền truy cập vào Redis, họ có thể tự set `isVerified=true`.

**e2e Test Cases — Password Reset Lifecycle:**

| ID | Test Case | Steps | Expected Status |
|:--:|----------|-------|:---------------:|
| AUTH-041 | Old password fails after reset | reset-password → login with cũ | **401** |
| AUTH-042 | New password succeeds after reset | login với mới | **201** |
| AUTH-043 | OTP bypass khi isVerified=true | reset-password với OTP sai + isVerified=true | **201** |

---

## 4. Test Data

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
