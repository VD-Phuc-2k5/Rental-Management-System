# Billing/Invoice - Tien do va ke hoach

Ngay cap nhat: 2026-05-26

## Da lam (chi tiet flow)
### 1) Fix flow thanh toan dat coc (VNPay)
- Refactor VNPay service: normalize query, sign hash, kiem tra success, va apply payment thanh cong.
- Return callback (/vnpay/return) goi finalize de phong truong hop IPN khong ve.
- IPN validation sua thieu hashQuery log.
- UI dat coc: nut thanh toan mo bottom sheet, lay hop dong da gui; bo man hinh chon phuong thuc cu.

### 2) Backend tinh hoa don phong (billing core)
- Them schema: meter_readings, invoices, invoice_items + enums.
- Them migration cho billing core.
- Billing module: controller + service + DTO validation.
- Implement logic:
  - Import chi so (XLSX/JSON) va upsert theo thang.
  - Preview hoa don theo thang, tra ve danh sach phong + chi phi chi tiet.
  - Tao hoa don (draft/real), update, finalize.
  - Lay hoa don cho landlord/tenant, xem chi tiet.

### 3) API billing da co
- POST /billing/meter-readings (upsert)
- POST /billing/meter-readings/import (multipart file)
- POST /billing/invoices/preview
- POST /billing/invoices
- POST /billing/invoices/:id/finalize
- PATCH /billing/invoices/:id
- GET /billing/invoices/landlord
- GET /billing/invoices/tenant
- GET /billing/invoices/:id

### 4) Client: import chi so
- Them file_picker.
- Add Electric/Water screen goi import API, hien so dong nhap thanh cong.
- Data/Domain/DI: Billing import entity + model + datasource + repo + usecase.

### 5) Client: preview va tao hoa don
- Domain: BillingInvoicePreviewEntity, CreateInvoicesResultEntity + usecases.
- Data: models + datasource + repo cho preview/create.
- UI Add Electric/Water:
  - Bo mock, goi preview API, map ve InvoicePreview.
  - Navigate PreviewInvoiceScreen voi month + danh sach preview.
  - Chon thang dong, badge hien theo thang dang chon.
- UI Preview Invoice:
  - Truyen month xuong body.
  - Nut Send goi create invoices API theo roomIds duoc chon.
  - Loc hoa don theo ten nha/so phong (UI filter).
  - Edit hoa don ngay tren preview, luu ve backend (draft -> update -> finalize).

## Dang lam / dang cap nhat
- (Trong dan cua) Hoan thien edit invoice phia backend + client.

## Can lam tiep (uu tien de xuat)
### A) Hoan thien flow tao hoa don
- Cho phep chon month dong (datepicker / month picker).
- Them propertyId, dueDate, isDraft vao request create (UI + usecase params).
- Hien thong bao loi ro rang, empty state neu preview rong.

### B) Man hinh danh sach / chi tiet hoa don
- Landlord invoice list (GET /billing/invoices/landlord) va detail.
- Tenant invoice list (GET /billing/invoices/tenant) va detail.
- Tao UI thanh toan tien phong (nếu co), lien ket den VNPay.

### C) Chinh sua hoa don
- Flow edit invoice: mo form, PATCH /billing/invoices/:id, re-preview tong tien.
- Quy dinh luong tinh lai khi sua chi so/phi.

### D) Tich hop thong ke va tinh nang khac
- Export hoa don (PDF/Excel) neu can.
- Thong bao cho tenant khi tao hoa don.

### E) Kiem thu va on dinh
- Test API billing (preview/create/update/finalize).
- Test UI flow: import -> preview -> create.
- Validate error handling khi token het han, file sai dinh dang, month sai format.
