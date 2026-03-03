import 'package:flutter/material.dart';
import 'package:app/core/widgets/common_appbar.dart';

import 'package:app/screens/bank-transfer-guide-screen/components/info_notice_banner.dart';
import 'package:app/screens/bank-transfer-guide-screen/components/bank_transfer_card.dart';
import 'package:app/core/constants.dart';
class BankTransferGuideScreen extends StatelessWidget {
  const BankTransferGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: const CommonAppBar(title: 'Chuyển khoản ngân hàng'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 6),
            InfoNoticeBanner(),
            SizedBox(height: 14),
            Text(
              'Thông tin tài khoản',
              style: TextStyle(
                color: AppColors.blue950,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            BankTransferCard(),
          ],
        ),
      ),
    );
  }
}