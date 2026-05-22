import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';
import 'components/body.dart';
import 'package:flutter/material.dart';

class AddElectricWaterScreen extends StatelessWidget {
  const AddElectricWaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(
        title: "Nhập chỉ số điện - nước", 
        badge: CommonAppBarBadge(
          text: "THÁNG 02/2026",
        ),
      ),
      body: const AddElectricWaterBody(),
    );
  }
}