import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';

import 'package:app/screens/tenant-maintenance-detail-screen/components/maintenance_notice_banner.dart';
import 'package:app/screens/tenant-maintenance-detail-screen/components/worker_info_card.dart';
import 'package:app/screens/tenant-maintenance-detail-screen/components/processing_timeline_card.dart';
import 'package:app/screens/tenant-maintenance-detail-screen/components/issue_detail_card.dart';
import 'package:app/screens/tenant-maintenance-detail-screen/components/maintenance_detail_bottom_bar.dart';

class TenantMaintenanceDetailScreen extends StatelessWidget {
  const TenantMaintenanceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: const CommonAppBar(title: 'Chi tiết sự cố'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            MaintenanceNoticeBanner(),
            SizedBox(height: 14),

            WorkerInfoCard(),
            SizedBox(height: 14),

            ProcessingTimelineCard(),
            SizedBox(height: 14),

            IssueDetailCard(),
          ],
        ),
      ),
      bottomNavigationBar: const MaintenanceDetailBottomBar(),
    );
  }
}