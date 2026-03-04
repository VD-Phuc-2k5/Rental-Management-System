import "package:app/core/widgets/common_appbar.dart";
import "package:app/core/widgets/landlord_navigation_bottom.dart";
import "package:app/screens/landlord-requests-screen/components/body.dart";
import "package:flutter/material.dart";

class LandlordRequestsScreen extends StatelessWidget {
  const LandlordRequestsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Yêu cầu"),
      body: Body(),
      bottomNavigationBar: LandlordNavigationBottom(currentIndex: 2),
    );
  }
}
