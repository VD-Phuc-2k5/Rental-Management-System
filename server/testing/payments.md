# Payments Module — Test Plan

**Endpoints:** `/api/payments/*`

---

## 1. Phân lớp tương đương (Equivalence Partitioning)

| Lớp | Trường | Mô tả | Giá trị đại diện | Kết quả |
|-----|--------|-------|-----------------|:-------:|
| EP-01 | contractId | UUID hợp lệ (deposit) | `uuid-v4` | Hợp lệ |
| EP-02 | contractId | Không tồn tại | `uuid-v4` không có trong DB | Không hợp lệ |
| EP-03 | invoiceId | UUID hợp lệ (invoice) | `uuid-v4` | Hợp lệ |
| EP-04 | invoiceId | Không tồn tại | `uuid-v4` không có trong DB | Không hợp lệ |
| EP-05 | PayOS webhook | Body hợp lệ | `{ orderCode, status }` | Hợp lệ |
| EP-06 | VNPay IPN | Checksum hợp lệ | query với checksum đúng | Hợp lệ |
| EP-07 | VNPay IPN | Checksum sai | query với checksum sai | Không hợp lệ |
| EP-08 | VNPay return | Signature đúng | query với signature đúng | Thành công |
| EP-09 | VNPay return | Signature sai | query với signature sai | Thất bại |

## 2. Bảng quyết định (Decision Table) — Payment Access Control

| Điều kiện | R1 | R2 | R3 | R4 | R5 | R6 |
|-----------|:--:|:--:|:--:|:--:|:--:|:--:|
| Token hợp lệ? | Y | Y | N | Y | - | - |
| Role = tenant? | Y | N | - | Y | - | - |
| Đầu vào | contractId tồn tại | contractId tồn tại | - | invoiceId tồn tại | webhook body | IPN query |
| Endpoint | create-deposit | create-deposit | create-deposit | create-invoice | webhook | ipn |
| **Kết quả** | **201** | **403** | **401** | **201** | **200** | **200** |

---

## 3. Test Cases

| ID | Kỹ thuật | Test Case | Method | Endpoint | Expected |
|----|:---------:|-----------|:------:|:--------:|:--------:|
| PAY-01 | EP | Create deposit payment (tenant) | POST | /api/payments/vnpay/create-deposit | **201** |
| PAY-02 | DT | Create deposit với landlord token | POST | /api/payments/vnpay/create-deposit | **403** |
| PAY-03 | EP | Create deposit contract không tồn tại | POST | /api/payments/vnpay/create-deposit | **404** |
| PAY-04 | EP | Create invoice payment | POST | /api/payments/payos/create-invoice | **201** |
| PAY-05 | EP | Dev confirm payment | POST | /api/payments/dev/confirm-payment | **200** |
| PAY-06 | EP | Dev confirm invoice payment | POST | /api/payments/dev/confirm-invoice-payment | **200** |
| PAY-07 | EP | PayOS webhook hợp lệ | POST | /api/payments/payos/webhook | **200** |
| PAY-08 | EP | PayOS webhook với body rỗng | POST | /api/payments/payos/webhook | **200** (graceful) |
| PAY-09 | EP | VNPay IPN checksum sai | GET | /api/payments/vnpay/ipn | **200** + RspCode: "97" |
| PAY-10 | EP | VNPay return signature đúng | GET | /api/payments/vnpay/return | **200** + success: true |
| PAY-11 | EP | VNPay return signature sai | GET | /api/payments/vnpay/return | **200** + success: false |

---

## 4. Test Data

```typescript
export const paymentTestData = {
  deposit: (contractId: string) => ({ contractId }),
  invoice: (invoiceId: string) => ({ invoiceId }),
  devConfirm: (contractId: string) => ({ contractId }),
  devConfirmInvoice: (invoiceId: string) => ({ invoiceId }),
};
```
