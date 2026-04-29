import 'package:app/screens/tenant-invoice-detail-screen/components/invoice_detail_models.dart';

/// Example data for testing different invoice states
class InvoiceDetailExamples {
  /// Example of a paid invoice (success state)
  static const InvoiceDetailData paidInvoice = InvoiceDetailData(
    status: InvoiceStatus.paid,
    generalInfo: InvoiceGeneralInfoData(
      roomName: 'Phòng 302 - Nhà Trọ Xanh',
      landlordName: 'Nguyễn văn A',
      billingMonth: '10/2023',
    ),
    lineItems: [
      InvoiceLineItemData(
        name: 'Tiền phòng',
        description: 'Cố định hàng tháng',
        amount: 3500000,
      ),
      InvoiceLineItemData(
        name: 'Tiền điện',
        description: '230 số (1240 - 1470) x 3.500đ',
        amount: 805000,
      ),
      InvoiceLineItemData(
        name: 'Tiền nước',
        description: '5m³ x 20.000đ',
        amount: 100000,
      ),
      InvoiceLineItemData(
        name: 'Phí dịch vụ',
        description: 'Internet, vệ sinh',
        amount: 150000,
      ),
    ],
    totalAmount: 4555000,
    paymentInfo: InvoicePaymentInfoData(
      paymentMethod: 'Chuyển khoản ngân hàng',
      createdDate: '28/10/2023',
      transactionId: 'INV-202310-302',
    ),
  );

  /// Example of a pending invoice (waiting for payment)
  static const InvoiceDetailData pendingInvoice = InvoiceDetailData(
    status: InvoiceStatus.pending,
    generalInfo: InvoiceGeneralInfoData(
      roomName: 'Phòng 202 - Nhà Trọ Xanh',
      landlordName: 'Trần Thị B',
      billingMonth: '11/2023',
    ),
    lineItems: [
      InvoiceLineItemData(
        name: 'Tiền phòng',
        description: 'Cố định hàng tháng',
        amount: 3000000,
      ),
      InvoiceLineItemData(
        name: 'Tiền điện',
        description: '180 số x 3.500đ',
        amount: 630000,
      ),
      InvoiceLineItemData(
        name: 'Tiền nước',
        description: '4m³ x 20.000đ',
        amount: 80000,
      ),
      InvoiceLineItemData(
        name: 'Phí dịch vụ',
        description: 'Internet, vệ sinh',
        amount: 150000,
      ),
    ],
    totalAmount: 3860000,
    paymentInfo: null, // No payment info for pending invoices
  );
}
