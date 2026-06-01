import 'components/body.dart';
import '../../core/widgets/common_appbar.dart';
import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key, required this.price});
  final int price;
  final appbarBorderWidth = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Thanh toán", showBack: false),
      body: Body(price: price),
    );
  }
}
