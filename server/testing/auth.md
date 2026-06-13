# Auth Module — Test Plan

**Endpoints:** `/api/auth/*`

---

## 1. Phân lớp tương đương (Equivalence Partitioning)

### 1.1 Register — Email

> Payload gốc hợp lệ cho register: `{email: "tenant123@gmail.com", fullName: "Nguyen Van A", phone: "0912345678", password: "Test@1234", confirm_password: "Test@1234", accepted_terms: true}`

| ID | Mô tả | Giá trị đại diện | Kết quả |
|----|-------|-----------------|:-------:|
| TC01 | Email đúng format | `{...validTenant, email: "tenant123@gmail.com"}` | Hợp lệ |
| TC02 | Email sai format (thiếu @) | `{...validTenant, email: "tenantgmail.com"}` | Không hợp lệ |
| TC03 | Email rỗng | `{...validTenant, email: ""}` | Không hợp lệ |

### 1.2 Register — Password

| ID | Mô tả | Giá trị đại diện | Kết quả |
|----|-------|-----------------|:-------:|
| TC04 | Thiếu ký tự đặc biệt | `{...validTenant, password: "Aa111111", confirm_password: "Aa111111"}` | Không hợp lệ |
| TC05 | Thiếu chữ hoa | `{...validTenant, password: "test@1111", confirm_password: "test@1111"}` | Không hợp lệ |
| TC06 | Thiếu chữ thường | `{...validTenant, password: "TEST@1111", confirm_password: "TEST@1111"}` | Không hợp lệ |
| TC07 | Thiếu số | `{...validTenant, password: "Test@Test", confirm_password: "Test@Test"}` | Không hợp lệ |
| TC08 | Không gửi password | `{...validTenant, password: undefined, confirm_password: undefined}` | Không hợp lệ |

### 1.3 Register — Phone

| ID | Mô tả | Giá trị đại diện | Kết quả |
|----|-------|-----------------|:-------:|
| TC09 | Có chứa chữ | `{...validTenant, phone: "abc123"}` | Không hợp lệ |
| TC10 | Không gửi phone | `{...validTenant, phone: undefined}` | Hợp lệ (optional) |

### 1.4 Register — fullName

| ID | Mô tả | Giá trị đại diện | Kết quả |
|----|-------|-----------------|:-------:|
| TC11 | Rỗng | `{...validTenant, fullName: ""}` | Không hợp lệ |

### 1.5 Register — accepted_terms

| ID | Mô tả | Giá trị đại diện | Kết quả |
|----|-------|-----------------|:-------:|
| TC12 | `false` | `{...validTenant, accepted_terms: false}` | Không hợp lệ |

### 1.6 Register — identity_number

| ID | Mô tả | Giá trị đại diện | Kết quả |
|----|-------|-----------------|:-------:|
| TC13 | Không gửi identity_number | `{...validTenant, identity_number: undefined}` | Hợp lệ (optional) |

### 1.7 Register — Business Logic (service layer)

| ID | Mô tả | Giá trị đại diện | Kết quả |
|----|-------|-----------------|:-------:|
| TC14 | Phone không được gửi → bỏ qua check | `phone: undefined` | Service bỏ qua check phone |
| TC15 | Identity không được gửi → bỏ qua check | `identity_number: undefined` | Service bỏ qua check identity |
| TC16 | BadRequestException từ create → re-throw | userRepository throws BadRequestException | **400** |

### 1.8 Login

> Payload hợp lệ: `{email: "tenant123@gmail.com", password: "Test@1234"}`

| ID | Mô tả | Giá trị đại diện | Kết quả |
|----|-------|-----------------|:-------:|
| TC17 | Email + password đúng | `{email: "tenant123@gmail.com", password: "Test@1234"}` | Thành công |
| TC18 | Email sai | `{email: "wrong@gmail.com", password: "Test@1234"}` | Thất bại |
| TC19 | Password sai | `{email: "tenant123@gmail.com", password: "wrongpass"}` | Thất bại |
| TC20 | Email rỗng | `{email: "", password: "Test@1234"}` | Không hợp lệ |

### 1.9 Forgot Password

> Payload: `{email: "..."}`

| ID | Mô tả | Giá trị đại diện | Kết quả |
|----|-------|-----------------|:-------:|
| TC21 | Email tồn tại | `{email: "tenant123@gmail.com"}` | **201** (gửi OTP) |
| TC22 | Email không tồn tại | `{email: "nonexistent@gmail.com"}` | **201** (bảo mật) |

---

## 2. Phân tích giá trị biên (Boundary Value Analysis)

### 2.1 Password length (`@MinLength(8) @MaxLength(72)`)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| TC23 | `A1@bcde` | 7 | biên(min) - 1 | **400** |
| TC24 | `A1@bcdef` | 8 | biên(min) | **201** |
| TC25 | `A1@bcdefg` | 9 | biên(min) + 1 | **201** |
| TC26 | `A1@` + `a`*68 | 71 | biên(max) - 1 | **201** |
| TC27 | `A1@` + `a`*69 | 72 | biên(max) | **201** |
| TC28 | `A1@` + `a`*70 | 73 | biên(max) + 1 | **400** |

### 2.2 Phone length (10 chữ số)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| TC29 | `012345678` | 9 | biên(min) - 1 | **400** |
| TC30 | `0123456789` | 10 | biên | **201** |
| TC31 | `01234567890` | 11 | biên(max) + 1 | **400** |

### 2.3 fullName length (`@MinLength(2) @MaxLength(100)`)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| TC32 | `"A"` | 1 | biên(min) - 1 | **400** |
| TC33 | `"An"` | 2 | biên(min) | **201** |
| TC34 | `"A"*99` | 99 | biên(max) - 1 | **201** |
| TC35 | `"A"*100` | 100 | biên(max) | **201** |
| TC36 | `"A"*101` | 101 | biên(max) + 1 | **400** |

### 2.4 identity_number length (`@Length(12, 12)`)

| ID | Giá trị | Độ dài | Loại biên | Kết quả |
|:--:|:-------:|:------:|:---------:|:-------:|
| TC37 | `"1"*11` | 11 | biên(min) - 1 | **400** |
| TC38 | `"1"*12` | 12 | biên | **201** |
| TC39 | `"1"*13` | 13 | biên(max) + 1 | **400** |

### 2.5 OTP length (`@Length(6, 6)`)

| ID | Test Case | Input | Expected Status |
|:--:|----------|-------|:---------------:|
| TC40 | OTP 5 chars (biên(min) - 1) | `{ email, otp: "12345" }` | **400** |
| TC41 | OTP 6 chars (biên) | `{ email, otp: "123456" }` with valid Redis | **201** |
| TC42 | OTP 7 chars (biên(max) + 1) | `{ email, otp: "1234567" }` | **400** |

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

**Test Cases:**

| ID | Test Case | Token | Endpoint | Expected Status |
|:--:|----------|:-----:|:--------:|:---------------:|
| TC43 | Public endpoint không cần auth | — | GET /api/users/:id | **200** |
| TC44 | Protected endpoint không token | — | GET /api/profile | **401** |
| TC45 | Empty Bearer token | `"Bearer "` | GET /api/profile | **401** |
| TC46 | Fake Bearer token | `"Bearer fake"` | GET /api/profile | **401** |
| TC47 | RolesGuard cho phép đúng role | valid token | GET /api/test-roles/tenant | **200** |
| TC48 | RolesGuard từ chối sai role | valid token | GET /api/test-roles/admin | **403** |

### 3.2 Reset Password Flow — forgot-password

| Điều kiện | Rule 1 | Rule 2 | Rule 3 | Rule 4 |
|-----------|:------:|:------:|:------:|:------:|
| Email tồn tại? | Y | N | Y | Y |
| OTP Redis set thành công? | Y | Y | N | Y |
| AuthOperationError? | N | N | N | Y |
| **Kết quả** | **201** (gửi email) | **201** (không gửi email) | **500** | **400** |

**Test Cases:**

| ID | Test Case | Steps / Payload | Expected Status |
|:--:|----------|----------------|:---------------:|
| TC49 | Forgot password - Email tồn tại | `POST /api/auth/forgot-password` với `{email: "tenant123@gmail.com"}` → OTP được set trong Redis | **201** |
| TC50 | Forgot password - Email không tồn tại | `POST /api/auth/forgot-password` với `{email: "nonexistent@gmail.com"}` → không gửi email (bảo mật) | **201** |

### 3.3 Reset Password Flow — Verify OTP

| Điều kiện | Rule 1 | Rule 2 | Rule 3 |
|-----------|:------:|:------:|:------:|
| OTP trong Redis? | Y | N | Y |
| OTP đúng? | Y | - | N |
| **Kết quả** | **201** (đánh dấu verified) | **400** | **400** |

**Test Cases:**

| ID | Test Case | Steps / Payload | Expected Status |
|:--:|----------|----------------|:---------------:|
| TC51 | Confirm OTP - OTP hợp lệ | `POST /api/auth/confirm-otp` với `{email, otp: "123456"}` (OTP đúng trong Redis) | **201** |

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

**Test Cases — Password Reset Lifecycle:**

| ID | Test Case | Steps | Expected Status |
|:--:|----------|-------|:---------------:|
| TC52 | Old password fails after reset | reset-password → login with cũ | **401** |
| TC53 | New password succeeds after reset | login với mới | **201** |
| TC54 | OTP bypass khi isVerified=true | reset-password với OTP sai + isVerified=true | **201** |
| TC55 | Reset password - Hợp lệ | `POST /api/auth/reset-password` với `{email, otp: "123456", newPassword: "NewPass@123", confirmPassword: "NewPass@123"}` (OTP đúng) | **201** |
| TC56 | Reset password - OTP sai | `POST /api/auth/reset-password` với `{email, otp: "000000", newPassword: "NewPass@123", confirmPassword: "NewPass@123"}` (OTP sai, chưa verify) | **400** |

---

## 4. Test Data

```typescript
export const authTestData = {
  validTenant: {
    email: `tenant-${Date.now()}@gmail.com`,
    fullName: 'Nguyen Van A',
    phone: '0912345678',
    password: 'Test@1234',
    confirm_password: 'Test@1234',
    accepted_terms: true,
  },
  validLandlord: {
    email: `landlord-${Date.now()}@gmail.com`,
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
