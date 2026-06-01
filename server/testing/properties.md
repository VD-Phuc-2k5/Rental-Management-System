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
| EP-11 | amenityCodes | Mảng rỗng | `[]` | Không hợp lệ |

## 2. Bảng quyết định (Decision Table) — Property CRUD Access

| Điều kiện | Rule 1 | Rule 2 | Rule 3 | Rule 4 | Rule 5 | Rule 6 |
|-----------|:------:|:------:|:------:|:------:|:------:|:------:|
| Token hợp lệ? | Y | Y | N | Y | Y | Y |
| Role = landlord? | Y | N | - | Y | Y | Y |
| Là chủ property? | Y | - | - | N | N/A | Y |
| Property tồn tại? | Y | - | - | N | Y | Y |
| Hành động | POST | POST | POST | GET | GET/:id | DELETE |
| **Kết quả** | **201** | **403** | **401** | **200** | **404** | **200** |

---

## 3. Test Cases

| ID | Kỹ thuật | Test Case | Method | Token | Body / Param | Expected Status |
|----|:---------:|-----------|:------:|:----:|-------------|:---------------:|
| PROP-01 | EP | Create property thành công | POST | landlord | `{ name, address, ward, district, city, description, amenityCodes: ["WIFI"] }` | **201** |
| PROP-02 | EP | Create thiếu name | POST | landlord | `{ address, ward, district, city, description, amenityCodes: ["WIFI"] }` | **400** |
| PROP-03 | EP | Create amenityCodes không hợp lệ | POST | landlord | `{ ...valid, amenityCodes: ["INVALID"] }` | **400** |
| PROP-04 | DT | Create với tenant token | POST | tenant | `{ ...valid }` | **403** |
| PROP-05 | DT | Create không token | POST | - | `{ ...valid }` | **401** |
| PROP-06 | EP | Get all properties | GET | landlord | - | **200** |
| PROP-07 | EP | Get property by ID | GET | landlord | `:id` (tồn tại) | **200** |
| PROP-08 | EP | Get property không tồn tại | GET | landlord | `:id` (uuid) | **404** |
| PROP-09 | DT | Get property của landlord khác | GET | landlord B | `:id` (của A) | **404** |
| PROP-10 | EP | Update property thành công | PATCH | landlord | `:id` + `{ name, description }` | **200** |
| PROP-11 | EP | Update property không tồn tại | PATCH | landlord | `:uuid` | **404** |
| PROP-12 | DT | Update property của landlord khác | PATCH | landlord B | `:id` (của A) | **404** |
| PROP-13 | EP | Delete property thành công | DELETE | landlord | `:id` (tồn tại) | **200** |
| PROP-14 | EP | Delete property không tồn tại | DELETE | landlord | `:uuid` | **404** |
| PROP-15 | DT | Delete property của landlord khác | DELETE | landlord B | `:id` (của A) | **404** |

---

## 4. Test Data

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
