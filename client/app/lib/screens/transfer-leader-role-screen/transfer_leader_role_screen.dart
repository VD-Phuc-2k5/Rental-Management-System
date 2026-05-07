import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/screens/transfer-leader-role-screen/components/body.dart';
import 'package:flutter/material.dart';

class TransferLeaderRoleScreen extends StatelessWidget {
  const TransferLeaderRoleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Chuyển quyền"),
      body: Body(),
    );
  }
}
