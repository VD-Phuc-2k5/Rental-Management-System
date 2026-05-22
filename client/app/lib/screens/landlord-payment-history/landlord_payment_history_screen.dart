import '../../core/widgets/landlord_navigation_bottom.dart';
import 'components/body.dart';
import 'components/landlord_payment_history_app_bar.dart';
import 'package:flutter/material.dart';


class LandlordPaymentHistoryScreen extends StatelessWidget {
  const LandlordPaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: LandlordPaymentHistoryAppBar(),
      body: LandlordPaymentHistoryBody(),
      bottomNavigationBar: LandlordNavigationBottom(currentIndex: 3),
    );
  }
}