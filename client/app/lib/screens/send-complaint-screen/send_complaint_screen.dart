import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';

import 'components/complaint_issue_info_card.dart';
import 'components/complaint_reason_field.dart';
import 'components/complaint_images_section.dart';
import 'components/complaint_note_banner.dart';
import 'components/complaint_bottom_bar.dart';

class SendComplaintScreen extends StatelessWidget {
  const SendComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(title: 'Gửi khiếu nại'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ComplaintIssueInfoCard(
              issueTitle: 'Hỏng vòi nước',
              roomName: 'Phòng 302 - Nhà A1',
              statusLabel: 'READ-ONLY',
            ),
            SizedBox(height: 16),

            ComplaintReasonField(),
            SizedBox(height: 18),

            ComplaintImagesSection(),
            SizedBox(height: 14),

            ComplaintNoteBanner(),
          ],
        ),
      ),
      bottomNavigationBar: ComplaintBottomBar(),
    );
  }
}