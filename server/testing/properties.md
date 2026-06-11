# Properties Module — Test Plan

**Endpoints:** `/api/properties`

---

## 1. Phân lớp tương đương (Equivalence Partitioning)

### Create / Update Property

| Lớp | Trường | Mô tả | Giá trị đại diện | Kết quả |
|-----|--------|-------|-----------------|:-------:|
| EP-01 | name | Chuỗi không rỗng | `Nha tro Hoa Phuong` | Hợp lệ |
| EP-02 | name | Rỗng | `""` | Không hợp lệ |
| EP-03 | address | Chuỗi không rỗng | `12 Nguyen Trai` | Hợp lệ |
| EP-04 | address | Rỗng | `""` | Không hợp lệ |
| EP-05 | ward | Chuỗi không rỗng | `Phuong 5` | Hợp lệ |
| EP-06 | district | Chuỗi không rỗng | `Quan 3` | Hợp lệ |
| EP-07 | city | Chuỗi không rỗng | `TP Ho Chi Minh` | Hợp lệ |
| EP-08 | description | Chuỗi không rỗng | `Khu tro an ninh` | Hợp lệ |
| EP-09 | amenityCodes | Mảng enum hợp lệ | `["WIFI", "AIR_CONDITIONER"]` | Hợp lệ |
| EP-10 | amenityCodes | Mảng chứa giá trị không hợp lệ | `["INVALID_AMENITY"]` | Không hợp lệ |
| EP-11 | amenityCodes | Mảng rỗng | `[]` | Không hợp lệ (bắt bởi DTO) |
| EP-12 | Entity.isValidAmenity | Amenity tồn tại trong danh sách | `WIFI` in `[WIFI, AC]` | Hợp lệ |
| EP-13 | Entity.isValidAmenity | Amenity không tồn tại trong danh sách | `BED` in `[WIFI]` | Không hợp lệ |
| EP-14 | Entity.isValidAmenity | Danh sách amenity rỗng | `WIFI` in `[]` | Không hợp lệ |

## 2. Phân tích giá trị biên (Boundary Value Analysis)

### Create / Update Property

| ID | Trường | Điều kiện biên | Giá trị đại diện | Kết quả |
|----|--------|---------------|-----------------|:-------:|
| BVA-01 | name | 1 ký tự (min-length) | `"A"` | Hợp lệ |
| BVA-02 | address | 1 ký tự (min-length) | `"1"` | Hợp lệ |
| BVA-03 | ward | 1 ký tự (min-length) | `"P"` | Hợp lệ |
| BVA-04 | district | 1 ký tự (min-length) | `"Q"` | Hợp lệ |
| BVA-05 | city | 1 ký tự (min-length) | `"H"` | Hợp lệ |
| BVA-06 | description | 1 ký tự (min-length) | `"K"` | Hợp lệ |
| BVA-07 | amenityCodes | 1 phần tử (min-length) | `["WIFI"]` | Hợp lệ |
| BVA-08 | amenityCodes | 0 phần tử (rỗng) | `[]` | Không hợp lệ |

## 3. Bảng quyết định (Decision Table) — Property CRUD Access

| Điều kiện | Rule 1 | Rule 2 | Rule 3 | Rule 4 | Rule 5 | Rule 6 |
|-----------|:------:|:------:|:------:|:------:|:------:|:------:|
| Token hợp lệ? | Y | Y | N | Y | Y | Y |
| Role = landlord? | Y | N | - | Y | Y | Y |
| Là chủ property? | Y | - | - | N | N/A | Y |
| Property tồn tại? | Y | - | - | N | Y | Y |
| Hành động | POST | POST | POST | GET | GET/:id | DELETE |
| **Kết quả** | **201** | **403** | **401** | **200** | **404** | **200** |

---

## 4. Test Cases

### EP — Equivalence Partitioning

| ID | Kỹ thuật | Test Case | Method | Token | Body / Param | Expected Status |
|----|:---------:|-----------|:------:|:----:|-------------|:---------------:|
| PROP-01 | EP | Create property thành công | POST | landlord | `{ name, address, ward, district, city, description, amenityCodes: ["WIFI"] }` | **201** |
| PROP-02 | EP | Create thiếu name | POST | landlord | `{ address, ward, district, city, description, amenityCodes: ["WIFI"] }` | **400** |
| PROP-03 | EP | Create amenityCodes không hợp lệ | POST | landlord | `{ ...valid, amenityCodes: ["INVALID"] }` | **400** |
| PROP-04 | EP | Get all properties | GET | landlord | - | **200** |
| PROP-05 | EP | Get property by ID | GET | landlord | `:id` (tồn tại) | **200** |
| PROP-06 | EP | Get property không tồn tại | GET | landlord | `:id` (uuid) | **404** |
| PROP-07 | EP | Update property thành công | PATCH | landlord | `:id` + `{ name, description }` | **200** |
| PROP-08 | EP | Update property không tồn tại | PATCH | landlord | `:uuid` | **404** |
| PROP-09 | EP | Delete property thành công | DELETE | landlord | `:id` (tồn tại) | **200** |
| PROP-10 | EP | Delete property không tồn tại | DELETE | landlord | `:uuid` | **404** |
| PROP-11 | EP | Entity — isValidAmenity trả về true khi amenity tồn tại | - | - | `WIFI` in `[WIFI, AC]` | **true** |
| PROP-12 | EP | Entity — isValidAmenity trả về false khi amenity không tồn tại | - | - | `BED` in `[WIFI]` | **false** |
| PROP-13 | EP | Entity — isValidAmenity trả về false khi danh sách rỗng | - | - | `WIFI` in `[]` | **false** |
| PROP-14 | EP | Create — amenityCodes chứa nhiều giá trị không hợp lệ | POST | landlord | `{ ...valid, amenityCodes: ["FAKE1", "FAKE2"] }` | **400** |
| PROP-15 | EP | Update — amenityCodes không hợp lệ | PATCH | landlord | `:id` + `{ amenityCodes: ["INVALID"] }` | **400** |
| PROP-16 | EP | Update — amenityCodes hợp lệ | PATCH | landlord | `:id` + `{ amenityCodes: ["WIFI", "BED"] }` | **200** |
| PROP-17 | EP | Update với partial fields | PATCH | landlord | `:id` + `{ name }` | **200** |
| PROP-18 | EP | Repository — tạo property thành công | - | - | Input đầy đủ | **Thành công** |
| PROP-19 | EP | Repository — foreign key violation (landlord không tồn tại) | - | - | landlorerId không hợp lệ | **Lỗi** |
| PROP-20 | EP | Repository — findAll trả về mảng rỗng | - | - | landlord không có property | **[]** |
| PROP-21 | EP | Repository — findById trả về null | - | - | id không tồn tại | **null** |
| PROP-22 | EP | Controller — InternalServerError khi service throw unknown error | POST | landlord | `{ ...valid }` | **500** |
| PROP-23 | EP | Controller — InternalServerError khi getById throw unknown error | GET | landlord | `:id` | **500** |
| PROP-24 | EP | Controller — InternalServerError khi update throw unknown error | PATCH | landlord | `:id` | **500** |
| PROP-25 | EP | Controller — InternalServerError khi delete throw unknown error | DELETE | landlord | `:id` | **500** |
| PROP-26 | EP | Domain errors — default messages | - | - | - | **OK** |
| PROP-27 | EP | Domain errors — custom messages | - | - | - | **OK** |

### BVA — Boundary Value Analysis

| ID | Kỹ thuật | Test Case | Method | Token | Body / Param | Expected Status |
|----|:--------:|-----------|:------:|:----:|-------------|:---------------:|
| PROP-28 | BVA | Create với name 1 ký tự | POST | landlord | `{ ...valid, name: "A" }` | **201** |
| PROP-29 | BVA | Create với address 1 ký tự | POST | landlord | `{ ...valid, address: "1" }` | **201** |
| PROP-30 | BVA | Create với ward 1 ký tự | POST | landlord | `{ ...valid, ward: "P" }` | **201** |
| PROP-31 | BVA | Create với district 1 ký tự | POST | landlord | `{ ...valid, district: "Q" }` | **201** |
| PROP-32 | BVA | Create với city 1 ký tự | POST | landlord | `{ ...valid, city: "H" }` | **201** |
| PROP-33 | BVA | Create với description 1 ký tự | POST | landlord | `{ ...valid, description: "K" }` | **201** |
| PROP-34 | BVA | Create với amenityCodes rỗng | POST | landlord | `{ ...valid, amenityCodes: [] }` | **400** |

### DT — Decision Table

| ID | Kỹ thuật | Test Case | Method | Token | Body / Param | Expected Status |
|----|:---------:|-----------|:------:|:----:|-------------|:---------------:|
| PROP-35 | DT | Create với tenant token | POST | tenant | `{ ...valid }` | **403** |
| PROP-36 | DT | Create không token | POST | - | `{ ...valid }` | **401** |
| PROP-37 | DT | Get property của landlord khác | GET | landlord B | `:id` (của A) | **404** |
| PROP-38 | DT | Update property của landlord khác | PATCH | landlord B | `:id` (của A) | **404** |
| PROP-39 | DT | Delete property của landlord khác | DELETE | landlord B | `:id` (của A) | **404** |

---

## 5. Test Data

```typescript
export const propertiesTestData = {
  valid: {
    name: 'Nha tro Hoa Phuong',
    address: '12 Nguyen Trai',
    ward: 'Phuong 5',
    district: 'Quan 3',
    city: 'TP Ho Chi Minh',
    description: 'Khu tro an ninh, gan truong hoc.',
    amenityCodes: ['WIFI', 'AIR_CONDITIONER'],
  },
  missingName: {
    address: '12 Nguyen Trai',
    ward: 'Phuong 5',
    district: 'Quan 3',
    city: 'TP Ho Chi Minh',
    description: 'test',
    amenityCodes: ['WIFI'],
  },
  invalidAmenity: {
    name: 'Test',
    address: '12 Nguyen Trai',
    ward: 'Phuong 5',
    district: 'Quan 3',
    city: 'TP Ho Chi Minh',
    description: 'test',
    amenityCodes: ['INVALID_AMENITY'],
  },
  update: {
    name: 'Nha tro Hoa Phuong Updated',
    description: 'Da duoc nang cap',
  },
};
```
