import '../../core/widgets/common_appbar.dart';
import 'components/body.dart';
import 'package:flutter/material.dart';

class LandlordUtilityMeterScreen extends StatelessWidget {
  const LandlordUtilityMeterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: "Cập nhật chỉ số điện-nước"),
      body: Body(),
    );
  }
}
