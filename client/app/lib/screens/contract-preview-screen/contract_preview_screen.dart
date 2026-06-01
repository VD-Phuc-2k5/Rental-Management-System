import 'package:flutter/material.dart';

import 'components/contract_preview_card.dart';
import 'components/deposit_section.dart';
import 'components/contract_bottom_bar.dart';
import '../contract-status-screen/contract_status_screen.dart';

class ContractPreviewScreen extends StatelessWidget {
  const ContractPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ContractStatusScreen()),
    );
  }
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContractPreviewCard(),
            SizedBox(height: 16),
            DepositSection(),
          ],
        ),
      ),
      bottomNavigationBar: ContractBottomBar(
        text: 'Gửi hợp đồng cho khách',
        onNext: () => _goNext(context),
      ),
    );
  }
}