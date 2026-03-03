import 'package:flutter/material.dart';

import 'package:app/screens/contract-status-screen/components/contract_status_top_card.dart';
import 'package:app/screens/contract-status-screen/components/contract_preview_file_card.dart';
import 'package:app/screens/contract-status-screen/components/contract_status_actions.dart';

class ContractStatusScreen extends StatelessWidget {
  const ContractStatusScreen({super.key});

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
          'Trạng thái hợp đồng',
          style: TextStyle(fontWeight: FontWeight.w700,
              color: Color(0xFF1A202C),
              fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        child: Column(
          children: const [
            const ContractStatusTopCard(
              tenantName: 'Nguyễn Văn A',
              sentTime: '10:30, 01/03/2026',
            ),
            SizedBox(height: 14),
            ContractPreviewFileCard(
              previewImage: const AssetImage('assets/images/preview_contract.png'),
            ),
            SizedBox(height: 18),
            ContractStatusActions(),
          ],
        ),
      ),
    );
  }
}