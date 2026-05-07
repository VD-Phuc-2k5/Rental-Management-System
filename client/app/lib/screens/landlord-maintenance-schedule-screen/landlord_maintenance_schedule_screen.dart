import 'package:app/core/models/maintenance_request.dart';
import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/screens/landlord-maintenance-schedule-screen/components/body.dart';
import 'package:flutter/material.dart';

class LandlordMaintenanceScheduleScreen extends StatelessWidget {
  final MaintenanceRequest request;
  const LandlordMaintenanceScheduleScreen({super.key, required this.request});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Lập lịch sửa chữa"),
      body: Body(request: request),
    );
  }
}
