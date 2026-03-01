import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/screens/landlord-utility-meter-screens/components/body.dart';
import 'package:flutter/material.dart';

class LandlordUtilityMeterScreens extends StatelessWidget {
  const LandlordUtilityMeterScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: "Cập nhật chỉ số điện-nước"),
      body: Body(),
    );
  }
}
