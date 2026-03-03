import 'package:flutter/material.dart';

import 'package:app/screens/tenant-sign-contract-screen/components/important_notice.dart';
import 'package:app/screens/tenant-sign-contract-screen/components/tenant_contract_summary.dart';
import 'package:app/screens/tenant-sign-contract-screen/components/agree_terms_row.dart';
import 'package:app/screens/tenant-sign-contract-screen/components/deposit_payment.dart';
import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';

class TenantSignContractScreen extends StatelessWidget {
  const TenantSignContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: const CommonAppBar(title: "Ký hợp đồng", showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ImportantNoticeCard(),
            SizedBox(height: 16),

            Center(
              child: Text(
                'HỢP ĐỒNG THUÊ NHÀ',
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