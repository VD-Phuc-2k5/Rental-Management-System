import 'package:app/screens/payment-success-screen/components/body.dart';
import 'package:app/core/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final int price;
  final appbarBorderWidth = 1.0;
  const PaymentSuccessScreen({super.key, required this.price});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Thanh toán"),
      body: Body(price: price),
    );
  }
}
