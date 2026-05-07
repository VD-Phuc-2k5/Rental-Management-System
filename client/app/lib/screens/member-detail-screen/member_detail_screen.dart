import 'package:flutter/material.dart';
import 'package:app/core/widgets/common_appbar.dart';

import 'package:app/screens/member-detail-screen/components/member_profile_header.dart';
import 'package:app/screens/member-detail-screen/components/primary_call_button.dart';
import 'package:app/screens/member-detail-screen/components/member_info_card.dart';
import 'package:app/screens/member-detail-screen/components/id_documents_section.dart';
import 'package:app/screens/member-detail-screen/components/danger_bottom_button.dart';
import 'package:app/core/constants.dart';
class MemberDetailScreen extends StatelessWidget {
  const MemberDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(
        title: 'Thông tin thành viên',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          18,
          16,
          MediaQuery.of(context).viewPadding.bottom + kBottomNavigationBarHeight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            MemberProfileHeader(
              name: 'Nguyễn Văn Tuấn',
              role: 'Trưởng phòng',
              joinMonth: 5,
              joinYear: 2023,
            ),
            SizedBox(height: 16),
            PrimaryCallButton(),
            SizedBox(height: 16),

            MemberInfoCard.contact(
              phoneNumber: '0901 234 567',
              email: 'tuan.nguyen@nhatroplus.com',
            ),
            SizedBox(height: 14),

            MemberInfoCard.identity(
              idNumber: '123456789012',
              dateOfBirth: '01/01/1990',
              address: '123 Đường ABC, Quận XYZ, TP. HCM',
            ),
            SizedBox(height: 18),

            IdDocumentsSection(),
          ],
        ),
      ),
      bottomNavigationBar: const DangerBottomButton(
        text: 'Xóa thành viên',
      ),
    );
  }
}