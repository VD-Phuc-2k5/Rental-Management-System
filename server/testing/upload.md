# Upload Module — Test Plan

**Endpoints:** `/api/upload/image`

---

## 1. Phân lớp tương đương (Equivalence Partitioning)

| Lớp | Trường | Mô tả | Giá trị đại diện | Kết quả |
|-----|--------|-------|-----------------|:-------:|
| EP-01 | file | File ảnh hợp lệ | `Buffer` với mimetype `image/jpeg` | Hợp lệ |
| EP-02 | file | Không gửi file | `undefined` | Không hợp lệ |
| EP-03 | bucket | Bucket hợp lệ | `room-images` | Hợp lệ |
| EP-04 | bucket | Bucket không hợp lệ | `invalid-bucket` | Hợp lệ (dùng default) |

## 2. Bảng quyết định (Decision Table)

| Điều kiện | Rule 1 | Rule 2 | Rule 3 | Rule 4 |
|-----------|:------:|:------:|:------:|:------:|
| Token hợp lệ? | Y | Y | N | Y |
| Có file? | Y | N | Y | Y |
| Bucket hợp lệ? | Y | - | Y | N |
| **Kết quả** | **200** (có url) | **400** | **401** | **200** (default bucket) |

---

## 3. Test Cases

| ID | Kỹ thuật | Test Case | File | Token | Bucket | Expected Status | Expected Data |
|----|:---------:|-----------|:----:|:----:|:------:|:---------------:|---------------|
| UPL-01 | EP | Upload image thành công | Buffer ảnh | Y | `room-images` | **200** | `url` |
| UPL-02 | EP | Upload không gửi file | - | Y | `room-images` | **400** | `"No file provided"` |
| UPL-03 | DT | Upload không token | Buffer ảnh | N | `room-images` | **401** | Unauthorized |
| UPL-04 | EP | Upload với bucket không hợp lệ | Buffer ảnh | Y | `invalid-bucket` | **200** | Dùng default bucket |

---

## 4. Test Data

```typescript
export const uploadTestData = {
  validBucket: 'room-images',
  invalidBucket: 'invalid-bucket',
};
```
