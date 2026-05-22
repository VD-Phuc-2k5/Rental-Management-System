import '../../core/widgets/common_appbar.dart';
import 'components/body.dart';
import 'package:flutter/material.dart';

class UpdateRentalContractScreen extends StatelessWidget {
  const UpdateRentalContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: "Cập nhật hợp đồng"),
      body: Body(),
    );
  }
}
