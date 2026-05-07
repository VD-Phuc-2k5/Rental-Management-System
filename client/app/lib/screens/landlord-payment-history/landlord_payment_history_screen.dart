import 'package:app/core/widgets/landlord_navigation_bottom.dart';
import 'package:app/screens/landlord-payment-history/components/body.dart';
import 'package:app/screens/landlord-payment-history/components/landlord_payment_history_app_bar.dart';
import 'package:flutter/material.dart';


class LandlordPaymentHistoryScreen extends StatelessWidget {
  const LandlordPaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LandlordPaymentHistoryAppBar(),
      body: LandlordPaymentHistoryBody(),
      bottomNavigationBar: const LandlordNavigationBottom(currentIndex: 3),
    );
  }
}