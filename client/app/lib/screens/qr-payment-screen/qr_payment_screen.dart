import 'components/body.dart';
import '../payment-success-screen/payment_success_screen.dart';
import '../../core/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import '../../core/constants.dart';

class QrPaymentScreen extends StatelessWidget {
  const QrPaymentScreen({
    super.key,
    required this.price,
    required this.roomName,
  });

  final double appbarBorderWidth = 1.0;
  final int price;
  final String roomName;

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
        child: Body(price: price, roomName: roomName, onSuccess: onSuccess),
      ),
    );
  }
}
