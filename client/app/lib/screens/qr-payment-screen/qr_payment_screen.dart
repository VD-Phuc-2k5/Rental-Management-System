import 'components/body.dart';
import '../payment-success-screen/payment_success_screen.dart';
import '../../core/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import '../../core/constants.dart';

class QrPaymentScreen extends StatelessWidget {
  const QrPaymentScreen({
    super.key,
    this.invoiceId,
    this.contractId,
    required this.price,
    required this.roomName,
    this.qrCodeBase64,
    this.payerName,
  });

  final double appbarBorderWidth = 1.0;
  final String? invoiceId;
  /// Contract ID để poll trạng thái ký (deposit payment)
  final String? contractId;
  final int price;
  final String roomName;
  /// PayOS QR payload — truyền xuống Body → PaymentQr render QrImageView
  final String? qrCodeBase64;
  /// Tên người thanh toán (nếu có)
  final String? payerName;

  @override
  Widget build(BuildContext context) {
    bool navigated = false;

    void onSuccess() {
      if (navigated) return;
      navigated = true;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PaymentSuccessScreen(price: price)),
      );
    }

    return Scaffold(
      appBar: const CommonAppBar(title: "Thanh toán"),
      body: Container(
        color: AppColors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        margin: const EdgeInsets.only(top: 10),
        child: Body(
          invoiceId: invoiceId,
          contractId: contractId,
          price: price,
          roomName: roomName,
          onSuccess: onSuccess,
          qrCodeBase64: qrCodeBase64,
          payerName: payerName,
        ),
      ),
    );
  }
}
