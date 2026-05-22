import 'package:flutter/material.dart';

import 'components/important_notice.dart';
import 'components/tenant_contract_summary.dart';
import 'components/agree_terms_row.dart';
import 'components/deposit_payment.dart';
import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';

class TenantSignContractScreen extends StatelessWidget {
  const TenantSignContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(title: "Ký hợp đồng", showBack: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImportantNoticeCard(),
            SizedBox(height: 16),

            Center(
              child: Text(
                'HỢP ĐỒNG THUÊ TRỌ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColors.slate900,
                ),
              ),
            ),
            SizedBox(height: 12),

            TenantContractSummaryCard(),
            SizedBox(height: 14),

            AgreeTermsRow(),
            SizedBox(height: 14),

            DepositPaymentCard(),
          ],
        ),
      ),
    );
  }
}