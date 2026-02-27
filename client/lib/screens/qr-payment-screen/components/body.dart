import 'package:app/screens/qr-payment-screen/components/download_button.dart';
import 'package:app/screens/qr-payment-screen/components/payment_countdown.dart';
import 'package:app/screens/qr-payment-screen/components/payment_heading.dart';
import 'package:app/screens/qr-payment-screen/components/payment_qr.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.price,
    required this.roomId,
    required this.onSuccess,
  });
  final int price;
  final String roomId;
  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24.0,
      children: [
        PaymentHeading(price: price, roomId: roomId),
        const PaymentQr(),
        PaymentCountdown(
          expiresAt: DateTime.now().add(const Duration(minutes: 15)),
          onSuccess: onSuccess,
        ),
        const DownloadButton(),
      ],
    );
  }
}
