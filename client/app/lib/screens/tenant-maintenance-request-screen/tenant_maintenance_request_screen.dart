import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/core/widgets/tenant_navigation_bottom.dart';
import 'package:app/screens/tenant-maintenance-request-screen/components/body.dart';
import 'package:flutter/material.dart';

class TenantMaintenanceRequestScreen extends StatelessWidget {
  const TenantMaintenanceRequestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: "Báo sự cố"),
      body: Body(),
      bottomNavigationBar: TenantNavigationBottom(currentIndex: 2),
    );
  }
}
