import 'package:app/screens/qr-payment-screen/components/body.dart';
import 'package:app/screens/payment-success-screen/payment_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class QrPaymentScreen extends StatelessWidget {
  const QrPaymentScreen({super.key, required this.price, required this.roomId});

  final double appbarBorderWidth = 1.0;
  final int price;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    bool navigated = false;

    void onSuccess() {
      if (navigated) return;
      navigated = true;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PaymentSuccessScreen(price: price)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue950),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(right: 56),
          child: Center(
            child: Text(
              "Thanh toán",
              style: TextStyle(
                color: AppColors.blue950,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(appbarBorderWidth),
          child: Container(
            height: appbarBorderWidth,
            color: AppColors.slate100,
          ),
        ),
      ),
      body: Container(
        color: AppColors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        margin: const EdgeInsets.only(top: 10),
        child: Body(price: price, roomId: roomId, onSuccess: onSuccess),
      ),
    );
  }
}
