import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';

import 'components/complaint_issue_info_card.dart';
import 'components/complaint_reason_field.dart';
import 'components/complaint_images_section.dart';
import 'components/complaint_note_banner.dart';
import 'components/complaint_bottom_bar.dart';

class SendComplaintScreen extends StatelessWidget {
  const SendComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: const CommonAppBar(title: 'Gửi khiếu nại'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ComplaintIssueInfoCard(),
            SizedBox(height: 16),

            ComplaintReasonField(),
            SizedBox(height: 18),

            ComplaintImagesSection(),
            SizedBox(height: 14),

            ComplaintNoteBanner(),
          ],
        ),
      ),
      bottomNavigationBar: const ComplaintBottomBar(),
    );
  }
}