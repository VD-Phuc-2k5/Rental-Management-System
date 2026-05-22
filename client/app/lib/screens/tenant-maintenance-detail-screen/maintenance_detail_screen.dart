import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';

import 'components/maintenance_notice_banner.dart';
import 'components/worker_info_card.dart';
import 'components/processing_timeline_card.dart';
import 'components/issue_detail_card.dart';
import 'components/maintenance_detail_bottom_bar.dart';

class TenantMaintenanceDetailScreen extends StatelessWidget {
  const TenantMaintenanceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(title: 'Chi tiết sự cố'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MaintenanceNoticeBanner(),
            SizedBox(height: 14),

            WorkerInfoCard(
              workerName: 'Nguyễn Văn A',
              scheduledTime: '14:00, 20/10/2023',
            ),
            SizedBox(height: 14),

            ProcessingTimelineCard(),
            SizedBox(height: 14),

            IssueDetailCard(
              issueImage1: 'assets/images/maintenance_1.jpg',
              issueImage2: 'assets/images/room_sign_contract.png',
            )
          ],
        ),
      ),
      bottomNavigationBar: MaintenanceDetailBottomBar(),
    );
  }
}