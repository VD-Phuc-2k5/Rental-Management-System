import 'package:app/screens/home-screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/screens/deposit-payment-method-screen/deposit_payment_method_screen.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(scaffoldBackgroundColor: AppColors.white),
      home: DepositPaymentMethodScreen(),
    );
  }
}