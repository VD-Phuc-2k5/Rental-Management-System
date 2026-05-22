import 'package:flutter/material.dart';
import '../../core/widgets/common_appbar.dart';

import 'components/verifying_indicator.dart';
import 'components/transaction_summary_card.dart';
import 'components/disabled_bottom_button.dart';
import '../../core/constants.dart';
class ConfirmAndSignScreen extends StatelessWidget {
  const ConfirmAndSignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(title: 'Xác nhận và ký hợp đồng'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 18, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
      bottomNavigationBar: DisabledBottomButton(text: 'Ký hợp đồng'),
    );
  }
}