import '../../core/widgets/common_appbar.dart';
import 'components/body.dart';
import 'package:flutter/material.dart';

class ContractExtensionRequestScreen extends StatelessWidget {
  const ContractExtensionRequestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: "Gia hạn hợp đồng"),
      body: Body(),
    );
  }
}
