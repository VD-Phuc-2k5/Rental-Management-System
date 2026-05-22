import '../../core/models/maintenance_request.dart';
import '../../core/widgets/common_appbar.dart';
import 'components/body.dart';
import 'package:flutter/material.dart';

class LandlordMaintenanceScheduleScreen extends StatelessWidget {
  const LandlordMaintenanceScheduleScreen({super.key, required this.request});
  final MaintenanceRequest request;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Lập lịch sửa chữa"),
      body: Body(request: request),
    );
  }
}
