import 'package:flutter/material.dart';
import '../../core/widgets/common_appbar.dart';
import 'components/payment_summary_card.dart';
import 'components/payment_methods_section.dart';
import 'components/payment_bottom_bar.dart';

class DepositPaymentMethodScreen extends StatelessWidget {
  const DepositPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF3F5F7),
      appBar: CommonAppBar(title: 'Thanh toán tiền cọc',showBack:true),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaymentSummaryCard(),
            SizedBox(height: 18),
            PaymentMethodsSection(),
          ],
        ),
      ),
      bottomNavigationBar: PaymentBottomBar(),
    );
  }
}