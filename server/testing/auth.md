# Auth Module — Test Plan

**Endpoints:** `/api/auth/*`, `/api/users/:id`, `/api/profile`, `/api/test-roles/*`

**Test implementation:** `test/auth/postman/auth.postman_collection.json`

---

## 1. Register — `/api/auth/register/user` & `/api/auth/register/landlord`

### 1.1 EP — Email

> Payload gốc: `{email, fullName: "Nguyen Van A", phone: "0912345678", password: "Test@1234", confirm_password: "Test@1234", accepted_terms: true}`

| ID | Postman | Mô tả | Input | Expected |
|:--:|:-------:|-------|-------|:--------:|
| TC01 | ✓ | Email đúng format | `{...valid, email: "tenant@test.com"}` | **201** |
| TC02 | ✓ | Email sai format (thiếu @) | `{...valid, email: "invalid"}` | **400** |
| TC03 | ✓ | Email rỗng | `{...valid, email: ""}` | **400** |

### 1.2 EP — Password

| ID | Postman | Mô tả | Input | Expected |
|:--:|:-------:|-------|-------|:--------:|
| TC04 | — | Password hợp lệ (hoa, thường, số, đb, 8-72) | `{...valid, password: "Test@1234"}` | **201** |
| TC05 | ✓ | Thiếu ký tự đặc biệt | `{...valid, password: "Aa111111"}` | **400** |
| TC06 | ✓ | Thiếu chữ hoa | `{...valid, password: "test@1111"}` | **400** |
| TC07 | ✓ | Thiếu chữ thường | `{...valid, password: "TEST@1111"}` | **400** |
| TC08 | ✓ | Thiếu số | `{...valid, password: "Test@Test"}` | **400** |
| TC09 | — | Không gửi password | `{...valid, password: undefined}` | **400** |

### 1.3 EP — Phone

| ID | Postman | Mô tả | Input | Expected |
|:--:|:-------:|-------|-------|:--------:|
| TC10 | — | Phone hợp lệ (10-15 số) | `{...valid, phone: "0912345678"}` | **201** |
| TC11 | ✓ | Phone chứa chữ | `{...valid, phone: "abc123"}` | **400** |
| TC12 | ✓ | Không gửi phone (optional) | `{...valid, phone: undefined}` | **201** |

### 1.4 EP — fullName

| ID | Postman | Mô tả | Input | Expected |
|:--:|:-------:|-------|-------|:--------:|
| TC13 | — | fullName hợp lệ (2-100 ký tự) | `{...valid, fullName: "Nguyen Van A"}` | **201** |
| TC14 | ✓ | fullName rỗng | `{...valid, fullName: ""}` | **400** |

### 1.5 EP — accepted_terms

| ID | Postman | Mô tả | Input | Expected |
|:--:|:-------:|-------|-------|:--------:|
| TC15 | — | accepted_terms = true | `{...valid, accepted_terms: true}` | **201** |
| TC16 | ✓ | accepted_terms = false | `{...valid, accepted_terms: false}` | **400** |

### 1.6 EP — identity_number

| ID | Postman | Mô tả | Input | Expected |
|:--:|:-------:|-------|-------|:--------:|
| TC17 | — | identity_number hợp lệ (12 số) | `{...landlord, identity_number: "123456789012"}` | **201** |
| TC18 | ✓ | Không gửi identity_number (optional) | `{...landlord, identity_number: undefined}` | **201** |

### 1.7 BVA — Length boundaries

#### 1.7.1 Password (`@MinLength(8)` `@MaxLength(72)`)

| ID | Postman | Giá trị | Độ dài | Loại biên | Expected |
|:--:|:-------:|:-------:|:------:|:---------:|:--------:|
| TC19 | — | `A1@bcde` | 7 | min-1 | **400** |
| TC20 | — | `A1@bcdef` | 8 | min | **201** |
| TC21 | — | `A1@bcdefg` | 9 | min+1 | **201** |
| TC22 | — | `A1@` + `a`*68 | 71 | max-1 | **201** |
| TC23 | — | `A1@` + `a`*69 | 72 | max | **201** |
| TC24 | — | `A1@` + `a`*70 | 73 | max+1 | **400** |

#### 1.7.2 Phone (`@Length(10, 15)`)

| ID | Postman | Giá trị | Độ dài | Loại biên | Expected |
|:--:|:-------:|:-------:|:------:|:---------:|:--------:|
| TC25 | — | `012345678` | 9 | min-1 | **400** |
| TC26 | — | `0123456789` | 10 | min | **201** |
| TC27 | — | `01234567890` | 11 | min+1 | **201** |
| TC28 | — | `012345678901234` | 15 | max | **201** |
| TC29 | — | `0123456789012345` | 16 | max+1 | **400** |

#### 1.7.3 fullName (`@MinLength(2)` `@MaxLength(100)`)

| ID | Postman | Giá trị | Độ dài | Loại biên | Expected |
|:--:|:-------:|:-------:|:------:|:---------:|:--------:|
| TC30 | — | `"A"` | 1 | min-1 | **400** |
| TC31 | — | `"An"` | 2 | min | **201** |
| TC32 | — | `"A"*99` | 99 | max-1 | **201** |
| TC33 | — | `"A"*100` | 100 | max | **201** |
| TC34 | — | `"A"*101` | 101 | max+1 | **400** |

#### 1.7.4 identity_number (`@Length(12, 12)`)

| ID | Postman | Giá trị | Độ dài | Loại biên | Expected |
|:--:|:-------:|:-------:|:------:|:---------:|:--------:|
| TC35 | — | `"1"*11` | 11 | exact-1 | **400** |
| TC36 | — | `"1"*12` | 12 | exact | **201** |
| TC37 | — | `"1"*13` | 13 | exact+1 | **400** |

### 1.8 EP — Additional DTO Validations

| ID | Postman | Mô tả | Input | Expected |
|:--:|:-------:|-------|-------|:--------:|
| TC38 | — | confirm_password != password | `{...valid, confirm_password: "Diff@1234"}` | **400** |
| TC39 | — | fullName chỉ khoảng trắng (`@Matches(/\S/)`) | `{...valid, fullName: "   "}` | **400** |
| TC40 | — | avatarUrl không hợp lệ (`@IsUrl`) | `{...valid, avatarUrl: "not-a-url"}` | **400** |
| TC41 | — | Gửi field lạ (`forbidNonWhitelisted`) | `{...valid, extraField: "x"}` | **400** |

### 1.9 EP — Service Layer Business Logic

| ID | Postman | Mô tả | Kịch bản | Expected |
|:--:|:-------:|-------|----------|:--------:|
| TC42 | — | Phone undefined → bỏ qua check unique | `phone: undefined` | Service không check |
| TC43 | — | Identity undefined → bỏ qua check unique | `identity_number: undefined` | Service không check |
| TC44 | — | BadRequestException re-throw | Mock userRepository.create throws | **400** |
| TC45 | — | Email đã tồn tại → ConflictException | Register với email đã dùng | **409** |
| TC46 | — | Phone đã tồn tại → ConflictException | Register với phone đã dùng | **409** |
| TC47 | — | identity_number đã tồn tại → ConflictException | Register với identity_number đã dùng | **409** |

---

## 2. Login — `/api/auth/login`

### 2.1 EP

| ID | Postman | Mô tả | Input | Expected |
|:--:|:-------:|-------|-------|:--------:|
| TC48 | ✓ | Email + password đúng | `{email, password: "Test@1234"}` | **201** |
| TC49 | ✓ | Email sai | `{email: "wrong@test.com", password: "Test@1234"}` | **401** |
| TC50 | ✓ | Password sai | `{email, password: "WrongPass@1"}` | **401** |
| TC51 | ✓ | Email rỗng | `{email: "", password: "Test@1234"}` | **400** |
| TC52 | — | Password rỗng | `{email, password: ""}` | **400** |

---

## 3. Password Reset Flow

### 3.1 Forgot Password — `/api/auth/forgot-password`

| ID | Postman | Mô tả | Input | Expected | Ghi chú |
|:--:|:-------:|-------|-------|:--------:|---------|
| TC53 | ✓ | Email tồn tại | `{email: "tenant@test.com"}` | **201** | OTP được lưu vào Redis, email gửi |
| TC54 | ✓ | Email không tồn tại | `{email: "nonexistent@test.com"}` | **201** | Bảo mật: không lộ email tồn tại |
| TC55 | — | Redis set thất bại | Mock Redis lỗi | **500** | Internal Server Error |
| TC56 | — | AuthOperationError | Mock AuthOperationError | **400** | Bad Request |

### 3.2 Verify OTP — `/api/auth/confirm-otp`

#### 3.2.1 BVA — OTP length (`@Length(6, 6)`)

| ID | Postman | Giá trị | Độ dài | Loại biên | Expected |
|:--:|:-------:|:-------:|:------:|:---------:|:--------:|
| TC57 | ✓ | `12345` | 5 | exact-1 | **400** |
| TC58 | — | `123456` | 6 | exact | **201** |
| TC59 | ✓ | `1234567` | 7 | exact+1 | **400** |

#### 3.2.2 EP — OTP validations

| ID | Postman | Mô tả | Input | Expected |
|:--:|:-------:|-------|-------|:--------:|
| TC60 | ✓ | OTP đúng trong Redis | `{email, otp: "123456"}` (đúng Redis) | **201** |
| TC61 | — | OTP không có trong Redis (hết hạn/chưa gửi) | `{email, otp: "123456"}` (không có key) | **400** |
| TC62 | — | OTP sai so với Redis | `{email, otp: "000000"}` (Redis có "123456") | **400** |
| TC63 | — | OTP chứa ký tự không phải số (`@Matches(/^[0-9]+$/)`) | `{email, otp: "abc123"}` | **400** |
| TC64 | — | OTP hết hạn (quá 60s TTL) | Chờ >60s rồi confirm | **400** |

### 3.3 Reset Password — `/api/auth/reset-password`

| ID | Postman | Mô tả | Input | Expected |
|:--:|:-------:|-------|-------|:--------:|
| TC65 | ✓ | Hợp lệ (OTP đúng + verified) | `{email, otp: "123456", newPassword: "NewPass@123", confirmPassword: "NewPass@123"}` | **201** |
| TC66 | — | Password != confirmPassword | `{...valid, newPassword: "NewPass@123", confirmPassword: "Diff@123"}` | **400** |
| TC67 | ✓ | OTP sai (chưa verified) | `{...valid, otp: "000000"}` (OTP sai, isVerified=false) | **400** |
| TC68 | — | User không tồn tại | Email user đã bị xóa | **400** |
| TC69 | ✓ | OTP bypass (isVerified=true, OTP sai) | isVerified=true, OTP sai vẫn qua | **201** |
| TC70 | — | newPassword thiếu ký tự đặc biệt (complexity) | `{...valid, newPassword: "Aa111111"}` | **400** |

### 3.4 Password Lifecycle — Post-Reset Verification

| ID | Postman | Mô tả | Steps | Expected |
|:--:|:-------:|-------|-------|:--------:|
| TC71 | ✓ | Login với password cũ thất bại | reset → login password cũ | **401** |
| TC72 | ✓ | Login với password mới thành công | reset → login password mới | **201** |

---

## 4. Access Control — AuthGuard & RolesGuard

### 4.1 AuthGuard (token validation)

| ID | Postman | Mô tả | Token | Endpoint | Expected |
|:--:|:-------:|-------|:-----:|:--------:|:--------:|
| TC73 | ✓ | Public endpoint không cần auth | — | GET /api/users/:id | **200** |
| TC74 | ✓ | Protected endpoint không token | — | GET /api/profile | **401** |
| TC75 | ✓ | Empty Bearer token | `"Bearer "` | GET /api/profile | **401** |
| TC76 | ✓ | Fake Bearer token | `"Bearer fake"` | GET /api/profile | **401** |

### 4.2 RolesGuard (role-based access)

| ID | Postman | Mô tả | Role trong token | Endpoint | Expected |
|:--:|:-------:|-------|:----------------:|:--------:|:--------:|
| TC77 | — | Đúng role (tenant → tenant endpoint) | tenant | GET /api/test-roles/tenant | **200** |
| TC78 | — | Sai role (tenant → admin endpoint) | tenant | GET /api/test-roles/admin | **403** |

---

## 5. Test Data

```typescript
export const authTestData = {
  // --- Valid base payloads ---
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

  // --- BVA for password (@MinLength(8) @MaxLength(72)) ---
  passwordTooShort: 'A1@bcde',                     // 7 chars
  passwordMin: 'A1@bcdef',                         // 8 chars
  passwordMinPlus1: 'A1@bcdefg',                   // 9 chars
  passwordMaxMinus1: 'A1@' + 'a'.repeat(68),       // 71 chars
  passwordMax: 'A1@' + 'a'.repeat(69),             // 72 chars
  passwordTooLong: 'A1@' + 'a'.repeat(70),         // 73 chars

  // --- BVA for phone (@Length(10, 15)) ---
  phoneTooShort: '012345678',                      // 9 chars
  phoneMin: '0123456789',                          // 10 chars
  phoneMinPlus1: '01234567890',                    // 11 chars
  phoneMax: '012345678901234',                     // 15 chars
  phoneTooLong: '0123456789012345',                // 16 chars

  // --- BVA for fullName (@MinLength(2) @MaxLength(100)) ---
  nameTooShort: 'A',                               // 1 char
  nameMin: 'An',                                   // 2 chars
  nameMaxMinus1: 'A'.repeat(99),                   // 99 chars
  nameMax: 'A'.repeat(100),                        // 100 chars
  nameTooLong: 'A'.repeat(101),                    // 101 chars

  // --- BVA for identity_number (@Length(12, 12)) ---
  identityTooShort: '1'.repeat(11),
  identityValid: '1'.repeat(12),
  identityTooLong: '1'.repeat(13),

  // --- BVA for OTP (@Length(6, 6)) ---
  otpTooShort: '12345',
  otpValid: '123456',
  otpTooLong: '1234567',
  otpNonDigit: 'abc123',

  // --- Additional validation data ---
  validAvatarUrl: 'https://example.com/avatar.png',
  invalidAvatarUrl: 'not-a-url',
  whitespaceFullName: '   ',
  passwordNoSpecial: 'Aa111111',
  passwordNoUpper: 'test@1111',
  passwordNoLower: 'TEST@1111',
  passwordNoDigit: 'Test@Test',
  newPassword: 'NewPass@123',
};
```

---

## 6. Summary

| ID | TC Name | Postman Request | Technique |
|:--:|---------|:---------------:|:---------:|
| TC01 | Register - Email đúng format | ✓ EP-01 | EP |
| TC02 | Register - Email sai format | ✓ EP-02 | EP |
| TC03 | Register - Email rỗng | ✓ EP-03 | EP |
| TC04 | Register - Password hợp lệ | — | EP |
| TC05 | Register - Password thiếu ký tự đặc biệt | ✓ EP-05 | EP |
| TC06 | Register - Password thiếu chữ hoa | ✓ EP-06 | EP |
| TC07 | Register - Password thiếu chữ thường | ✓ EP-07 | EP |
| TC08 | Register - Password thiếu số | ✓ EP-08 | EP |
| TC09 | Register - Không gửi password | — | EP |
| TC10 | Register - Phone hợp lệ | — | EP |
| TC11 | Register - Phone chứa chữ | ✓ EP-11 | EP |
| TC12 | Register - Không gửi phone | ✓ EP-12 | EP |
| TC13 | Register - fullName hợp lệ | — | EP |
| TC14 | Register - fullName rỗng | ✓ EP-14 | EP |
| TC15 | Register - accepted_terms = true | — | EP |
| TC16 | Register - accepted_terms = false | ✓ EP-16 | EP |
| TC17 | Register - identity_number hợp lệ | — | EP |
| TC18 | Register - Không gửi identity_number | ✓ EP-18 | EP |
| TC19 | BVA - Password 7 chars (min-1) | — | BVA |
| TC20 | BVA - Password 8 chars (min) | — | BVA |
| TC21 | BVA - Password 9 chars (min+1) | — | BVA |
| TC22 | BVA - Password 71 chars (max-1) | — | BVA |
| TC23 | BVA - Password 72 chars (max) | — | BVA |
| TC24 | BVA - Password 73 chars (max+1) | — | BVA |
| TC25 | BVA - Phone 9 chars (min-1) | — | BVA |
| TC26 | BVA - Phone 10 chars (min) | — | BVA |
| TC27 | BVA - Phone 11 chars (min+1) | — | BVA |
| TC28 | BVA - Phone 15 chars (max) | — | BVA |
| TC29 | BVA - Phone 16 chars (max+1) | — | BVA |
| TC30 | BVA - fullName 1 char (min-1) | — | BVA |
| TC31 | BVA - fullName 2 chars (min) | — | BVA |
| TC32 | BVA - fullName 99 chars (max-1) | — | BVA |
| TC33 | BVA - fullName 100 chars (max) | — | BVA |
| TC34 | BVA - fullName 101 chars (max+1) | — | BVA |
| TC35 | BVA - identity 11 chars | — | BVA |
| TC36 | BVA - identity 12 chars | — | BVA |
| TC37 | BVA - identity 13 chars | — | BVA |
| TC38 | Register - confirm_password != password | — | EP |
| TC39 | Register - fullName whitespace-only | — | EP |
| TC40 | Register - avatarUrl invalid | — | EP |
| TC41 | Register - forbidNonWhitelisted | — | EP |
| TC42 | Service - Phone undefined skip | — | EP |
| TC43 | Service - Identity undefined skip | — | EP |
| TC44 | Service - BadRequestException re-throw | — | EP |
| TC45 | Service - Duplicate email | — | EP |
| TC46 | Service - Duplicate phone | — | EP |
| TC47 | Service - Duplicate identity_number | — | EP |
| TC48 | Login - Thành công | ✓ EP-22 | EP |
| TC49 | Login - Email sai | ✓ EP-23 | EP |
| TC50 | Login - Password sai | ✓ EP-24 | EP |
| TC51 | Login - Email rỗng | ✓ EP-25 | EP |
| TC52 | Login - Password rỗng | — | EP |
| TC53 | Forgot Password - Email tồn tại | ✓ | DT |
| TC54 | Forgot Password - Email không tồn tại | ✓ | DT |
| TC55 | Forgot Password - Redis failure | — | DT |
| TC56 | Forgot Password - AuthOperationError | — | DT |
| TC57 | BVA - OTP 5 chars | ✓ | BVA |
| TC58 | BVA - OTP 6 chars | — | BVA |
| TC59 | BVA - OTP 7 chars | ✓ | BVA |
| TC60 | Confirm OTP - Hợp lệ | ✓ | DT |
| TC61 | Confirm OTP - Không có trong Redis | — | DT |
| TC62 | Confirm OTP - OTP sai | — | DT |
| TC63 | Confirm OTP - OTP non-digit | — | EP |
| TC64 | Confirm OTP - OTP expired (60s) | — | EP |
| TC65 | Reset Password - Hợp lệ | ✓ | DT |
| TC66 | Reset Password - password != confirmPassword | — | DT |
| TC67 | Reset Password - OTP sai | ✓ | DT |
| TC68 | Reset Password - User không tồn tại | — | DT |
| TC69 | Reset Password - OTP bypass isVerified | ✓ | DT |
| TC70 | Reset Password - newPassword no special char | — | EP |
| TC71 | Post-Reset - Login password cũ | ✓ | DT |
| TC72 | Post-Reset - Login password mới | ✓ | DT |
| TC73 | Access - Public endpoint | ✓ | DT |
| TC74 | Access - Protected không token | ✓ | DT |
| TC75 | Access - Token rỗng | ✓ | DT |
| TC76 | Access - Token fake | ✓ | DT |
| TC77 | Access - RolesGuard đúng role | — | DT |
| TC78 | Access - RolesGuard sai role | — | DT |

### Technique Count

| Kỹ thuật | Số TC |
|----------|:-----:|
| EP — Phân lớp tương đương | 38 |
| BVA — Phân tích giá trị biên | 17 |
| DT — Bảng quyết định | 23 |
| **Tổng** | **78** |

> ✓ = đã implement trong Postman collection &nbsp;&nbsp; — = chưa implement, cần bổ sung
