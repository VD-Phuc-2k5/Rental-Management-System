import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/screens/update-rental-contract-screen/components/body.dart';
import 'package:flutter/material.dart';

class UpdateRentalContractScreen extends StatelessWidget {
  const UpdateRentalContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Cập nhật hợp đồng"),
      body: Body(),
    );
  }
}
