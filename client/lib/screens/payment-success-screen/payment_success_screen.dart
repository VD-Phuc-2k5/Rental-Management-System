import 'package:app/screens/payment-success-screen/components/body.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class PayentSuccessScreen extends StatelessWidget {
  final int price;
  final appbarBorderWidth = 1.0;
  const PayentSuccessScreen({super.key, required this.price});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
      body: Body(price: price),
    );
  }
}
