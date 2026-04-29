import "package:app/core/widgets/common_appbar.dart";
import "package:app/screens/qr-payment-screen/qr_payment_screen.dart";
import "package:app/screens/tenant-invoice-payment-screen/components/body.dart";
import "package:app/screens/tenant-invoice-payment-screen/components/payment_models.dart";
import "package:flutter/material.dart";

class TenantInvoicePaymentScreen extends StatelessWidget {
  final String appbarTitle;
  final PaymentData? paymentData;

  const TenantInvoicePaymentScreen({
    super.key,
    required this.appbarTitle,
    this.paymentData,
  });

  static const PaymentData _defaultPaymentData = PaymentData(
    invoiceId: 'INV-001',
    roomName: 'Phòng 101 - Nhà Trọ Sinh Viên',
    lineItems: [
      PaymentLineItemData(name: 'Tiền phòng', amount: 2000000),
      PaymentLineItemData(
        name: 'Điện',
        description: '125kWh x 4,000đ',
        amount: 500000,
      ),
      PaymentLineItemData(name: 'Nước', amount: 200000),
      PaymentLineItemData(name: 'Dịch vụ (Wifi, rác, vệ sinh)', amount: 272500),
    ],
    totalAmount: 2972500,
  );

  PaymentData get _data => paymentData ?? _defaultPaymentData;

  void _handlePaymentSubmit(BuildContext context) {
    final data = _data;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            QrPaymentScreen(price: data.totalAmount, roomName: data.roomName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: appbarTitle),
      body: Body(
        paymentData: _data,
        onPaymentSubmit: () => _handlePaymentSubmit(context),
      ),
    );
  }
}
