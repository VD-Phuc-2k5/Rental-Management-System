import 'package:flutter/material.dart';

import 'components/contract_status_top_card.dart';
import 'components/contract_preview_file_card.dart';
import 'components/contract_status_actions.dart';

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
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        child: Column(
          children: const [
            ContractStatusTopCard(),
            SizedBox(height: 14),
            ContractPreviewFileCard(),
            SizedBox(height: 18),
            ContractStatusActions(),
          ],
        ),
      ),
    );
  }
}