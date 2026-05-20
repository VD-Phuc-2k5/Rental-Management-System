import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';
import 'package:flutter/material.dart';

import 'components/calculation_section.dart';
import 'components/checklist_section.dart';
import 'components/contract_info_card.dart';
import 'components/finish_contract_bottom_bar.dart';

class FinishContractScreen extends StatelessWidget {
  const FinishContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: const CommonAppBar(title: "Kết thúc hợp đồng"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ContractInfoCard(),
                  SizedBox(height: 24),

                  ChecklistSection(),
                  SizedBox(height: 24),

                  CalculationSection(),
                ],
              ),
            ),
            const FinishContractBottomBar(),
          ],
        ),
      ),
    );
  }
}
