import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/core/widgets/tenant_navigation_bottom.dart';
import 'package:app/screens/tenant-invoice-list-screen/components/body.dart';
import 'package:flutter/material.dart';

class TenantInvoiceListScreen extends StatelessWidget {
  const TenantInvoiceListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Hóa đơn của tôi"),
      body: Body(),
      bottomNavigationBar: TenantNavigationBottom(currentIndex: 3),
    );
  }
}
