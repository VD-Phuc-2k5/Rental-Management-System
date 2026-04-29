import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/screens/contract-extension-request-screen/components/body.dart';
import 'package:flutter/material.dart';

class ContractExtensionRequestScreen extends StatelessWidget {
  const ContractExtensionRequestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Gia hạn hợp đồng"),
      body: Body(),
    );
  }
}
