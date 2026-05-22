import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';
import 'package:flutter/material.dart';

import 'components/calculation_section.dart';
import 'components/checklist_section.dart';
import 'components/contract_info_card.dart';
import 'components/finish_contract_bottom_bar.dart';

class FinishContractScreen extends StatelessWidget {
  const FinishContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: CommonAppBar(title: "Kết thúc hợp đồng"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContractInfoCard(),
                  SizedBox(height: 24),

                  ChecklistSection(),
                  SizedBox(height: 24),

                  CalculationSection(),
                ],
              ),
            ),
            FinishContractBottomBar(),
          ],
        ),
      ),
    );
  }
}
