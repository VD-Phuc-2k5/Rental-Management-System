import 'package:flutter/material.dart';

import 'components/contract_preview_card.dart';
import 'components/deposit_section.dart';
import 'components/contract_bottom_bar.dart';

class ContractPreviewScreen extends StatelessWidget {
  const ContractPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hợp đồng thuê trọ',
          style: TextStyle(fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF111417),),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ContractPreviewCard(),
            SizedBox(height: 16),
            DepositSection(),
          ],
        ),
      ),
      bottomNavigationBar: const ContractBottomBar(
        text: 'Gửi hợp đồng cho khách  >',
      ),
    );
  }
}