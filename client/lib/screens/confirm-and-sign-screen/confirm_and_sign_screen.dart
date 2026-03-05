import 'package:flutter/material.dart';
import 'package:app/core/widgets/common_appbar.dart';

import 'package:app/screens/confirm-and-sign-screen/components/verifying_indicator.dart';
import 'package:app/screens/confirm-and-sign-screen/components/transaction_summary_card.dart';
import 'package:app/screens/confirm-and-sign-screen/components/disabled_bottom_button.dart';
import 'package:app/core/constants.dart';
class ConfirmAndSignScreen extends StatelessWidget {
  const ConfirmAndSignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: const CommonAppBar(title: 'Xác nhận và ký hợp đồng'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(height: 10),
            VerifyingIndicator(),
            SizedBox(height: 16),
            TransactionSummaryCard(
              bankName: 'Vietcombank (VCB)',
              amount: 5000000,
              transferContent: 'NTPLUS 301A 0912345678',
            ),
          ],
        ),
      ),
      bottomNavigationBar: const DisabledBottomButton(text: 'Ký hợp đồng'),
    );
  }
}