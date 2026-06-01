import "../../core/widgets/common_appbar.dart";
import "../qr-payment-screen/qr_payment_screen.dart";
import "api_invoice_payment.dart";
import "components/body.dart";
import "components/payment_models.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../features/auth/presentation/blocs/authentication/authentication_bloc.dart";

class TenantInvoicePaymentScreen extends StatelessWidget {
  const TenantInvoicePaymentScreen({
    super.key,
    required this.appbarTitle,
    this.paymentData,
    this.payerName,
  });
  final String appbarTitle;
  final PaymentData? paymentData;
  final String? payerName;

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

  Future<void> _handlePaymentSubmit(BuildContext context) async {
    final data = _data;
    final token = context.read<AuthenticationBloc>().state.user?.token ?? '';
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để thanh toán.')),
      );
      return;
    }

    String? qrCodeBase64;
    try {
      // Gọi API tạo giao dịch PayOS, lấy qrCodeUrl (QR payload)
      final result = await createInvoicePaymentUrl(
        token: token,
        invoiceId: data.invoiceId,
      );
      qrCodeBase64 = result.qrCodeUrl;
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      // Fallback sang VietQR (bank transfer) nếu PayOS create link lỗi
      qrCodeBase64 = null;
    }
    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QrPaymentScreen(
          invoiceId: data.invoiceId,
          price: data.totalAmount,
          roomName: data.roomName,
          qrCodeBase64: qrCodeBase64,
          payerName: payerName,
        ),
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
