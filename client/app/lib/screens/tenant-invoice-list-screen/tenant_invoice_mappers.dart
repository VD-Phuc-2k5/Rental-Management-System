import 'package:domain/billing.dart';
import 'package:intl/intl.dart';

import '../tenant-invoice-detail-screen/components/invoice_detail_models.dart';
import '../tenant-invoice-payment-screen/components/payment_models.dart';
import 'components/invoice_view_models.dart';

String formatBillingMonthDisplay(String yyyyMm) {
  final parts = yyyyMm.split('-');
  if (parts.length == 2) return '${parts[1]}/${parts[0]}';
  return yyyyMm;
}

String invoiceStatusLabel(String status) {
  return switch (status) {
    'paid' => 'Đã thanh toán',
    'finalized' => 'Chờ thanh toán',
    'draft' => 'Nháp',
    'void' => 'Đã hủy',
    _ => status,
  };
}

String invoiceItemTypeLabel(String type) {
  return switch (type) {
    'rent' => 'Tiền phòng',
    'electric' => 'Tiền điện',
    'water' => 'Tiền nước',
    'service' => 'Phí dịch vụ',
    'adjustment' => 'Điều chỉnh',
    _ => type,
  };
}

String formatDueDateDisplay(String? dueDate) {
  if (dueDate == null || dueDate.isEmpty) return '—';
  final parsed = DateTime.tryParse(dueDate);
  if (parsed == null) return dueDate;
  return DateFormat('dd/MM/yyyy').format(parsed);
}

String formatPaidAtDisplay(DateTime? paidAt) {
  if (paidAt == null) return '—';
  return DateFormat('dd/MM/yyyy • HH:mm').format(paidAt.toLocal());
}

String _shortRoomLabel(String roomId) {
  if (roomId.length <= 8) return 'Phòng $roomId';
  return 'Phòng ${roomId.substring(0, 8)}';
}

InvoiceHistoryItemData mapTenantInvoiceToHistoryItem(TenantInvoiceEntity inv) {
  final isPaid = inv.status == 'paid';
  final paidAt = isPaid
      ? formatPaidAtDisplay(inv.paidAt)
      : (inv.dueDate != null && inv.dueDate!.isNotEmpty
          ? 'Hạn: ${formatDueDateDisplay(inv.dueDate)}'
          : 'Tháng ${formatBillingMonthDisplay(inv.month)}');

  return InvoiceHistoryItemData(
    id: inv.id,
    billingMonth: formatBillingMonthDisplay(inv.month),
    paidAt: paidAt,
    amount: inv.total,
    statusLabel: invoiceStatusLabel(inv.status),
    isPaid: isPaid,
  );
}

InvoiceDetailData mapTenantInvoiceDetailToUi(TenantInvoiceDetailEntity inv) {
  final status = inv.status == 'paid'
      ? InvoiceStatus.paid
      : InvoiceStatus.pending;

  final lineItems = inv.items
      .map(
        (item) => InvoiceLineItemData(
          name: invoiceItemTypeLabel(item.type),
          description: item.description,
          amount: item.amount,
        ),
      )
      .toList();

  return InvoiceDetailData(
    id: inv.id,
    status: status,
    generalInfo: InvoiceGeneralInfoData(
      roomName: _shortRoomLabel(inv.roomId),
      landlordName: 'Chủ trọ',
      billingMonth: formatBillingMonthDisplay(inv.month),
    ),
    lineItems: lineItems,
    totalAmount: inv.total,
    paymentInfo: status == InvoiceStatus.paid
        ? InvoicePaymentInfoData(
            paymentMethod: 'PayOS',
            createdDate: formatPaidAtDisplay(inv.paidAt),
            transactionId: inv.id,
          )
        : null,
  );
}

PaymentData mapTenantInvoiceDetailToPayment(TenantInvoiceDetailEntity inv) {
  final lineItems = inv.items
      .map(
        (item) => PaymentLineItemData(
          name: invoiceItemTypeLabel(item.type),
          description: item.description,
          amount: item.amount,
        ),
      )
      .toList();

  return PaymentData(
    invoiceId: inv.id,
    roomName: '${_shortRoomLabel(inv.roomId)} — ${formatBillingMonthDisplay(inv.month)}',
    lineItems: lineItems,
    totalAmount: inv.total,
  );
}

PaymentData mapTenantInvoiceToPayment(TenantInvoiceEntity inv) {
  return PaymentData(
    invoiceId: inv.id,
    roomName: '${_shortRoomLabel(inv.roomId)} — ${formatBillingMonthDisplay(inv.month)}',
    lineItems: const [],
    totalAmount: inv.total,
  );
}
