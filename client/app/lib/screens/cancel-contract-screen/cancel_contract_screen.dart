import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';
import 'package:flutter/material.dart';

import 'components/cancel_contract_bottom_bar.dart';
import 'components/cancel_form_section.dart';
import 'components/contract_room_summary.dart';
import 'components/process_timeline_section.dart';
import 'components/warning_box.dart';

class CancelContractScreen extends StatelessWidget {
  const CancelContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: CommonAppBar(title: "Hủy hợp đồng"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WarningBox(),
                  SizedBox(height: 20),

                  ContractRoomSummary(),
                  SizedBox(height: 20),

                  CancelFormSection(),
                  SizedBox(height: 20),

                  ProcessTimelineSection(),
                ],
              ),
            ),
            CancelContractBottomBar(),
          ],
        ),
      ),
    );
  }
}
