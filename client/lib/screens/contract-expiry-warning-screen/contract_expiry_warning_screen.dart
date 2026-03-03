import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/screens/contract-expiry-warning-screen/components/body.dart';
import 'package:flutter/material.dart';

class ContractExpiryWarningScreen extends StatelessWidget {
  // TO DO: Add contract parameter when contract model is available
  // final Contract contract;
  const ContractExpiryWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: "Cảnh báo hết hạn"),
      body: Body(),
    );
  }
}
