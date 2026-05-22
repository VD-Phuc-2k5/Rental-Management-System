import 'package:flutter/material.dart';
import '../../core/widgets/common_appbar.dart';

import 'components/member_profile_header.dart';
import 'components/primary_call_button.dart';
import 'components/member_info_card.dart';
import 'components/id_documents_section.dart';
import 'components/danger_bottom_button.dart';
import '../../core/constants.dart';
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
            const MemberProfileHeader(
              name: 'Nguyễn Văn Tuấn',
              role: 'Trưởng phòng',
              joinMonth: 5,
              joinYear: 2023,
            ),
            const SizedBox(height: 16),
            const PrimaryCallButton(),
            const SizedBox(height: 16),

            MemberInfoCard.contact(
              phoneNumber: '0901 234 567',
              email: 'tuan.nguyen@nhatroplus.com',
            ),
            const SizedBox(height: 14),

            MemberInfoCard.identity(
              idNumber: '123456789012',
              dateOfBirth: '01/01/1990',
              address: '123 Đường ABC, Quận XYZ, TP. HCM',
            ),
            const SizedBox(height: 18),

            const IdDocumentsSection(),
          ],
        ),
      ),
      bottomNavigationBar: const DangerBottomButton(
        text: 'Xóa thành viên',
      ),
    );
  }
}