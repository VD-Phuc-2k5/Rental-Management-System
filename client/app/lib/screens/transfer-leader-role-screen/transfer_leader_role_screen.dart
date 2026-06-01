import '../../core/widgets/common_appbar.dart';
import 'components/body.dart';
import 'package:flutter/material.dart';

class TransferLeaderRoleScreen extends StatelessWidget {
  const TransferLeaderRoleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: "Chuyển quyền"),
      body: Body(),
    );
  }
}
