import 'package:app/screens/qr-payment-screen/components/body.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class QrPaymentScreen extends StatelessWidget {
  const QrPaymentScreen({super.key, required this.price, required this.roomId});
  final double appbarBorderWidth = 1.0;
  final int price;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue950),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(right: 56.0),
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
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        margin: EdgeInsets.only(top: 10.0),
        child: Body(price: price, roomId: roomId),
      ),
    );
  }
}
