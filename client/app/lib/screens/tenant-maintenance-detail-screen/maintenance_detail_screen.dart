import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';

import 'components/maintenance_notice_banner.dart';
import 'components/worker_info_card.dart';
import 'components/processing_timeline_card.dart';
import 'components/issue_detail_card.dart';
import 'components/maintenance_detail_bottom_bar.dart';
import '../../core/models/maintenance_request.dart';
import 'package:intl/intl.dart';
class TenantMaintenanceDetailScreen extends StatefulWidget {
  const TenantMaintenanceDetailScreen({
    super.key,
    required this.request,
  });

  final MaintenanceRequest request;

  @override
  State<TenantMaintenanceDetailScreen> createState() =>
      _TenantMaintenanceDetailScreenState();
}

class _TenantMaintenanceDetailScreenState
    extends State<TenantMaintenanceDetailScreen> {
  late MaintenanceRequest _request;

  @override
  void initState() {
    super.initState();
    _request = widget.request;
  }

  void _updateRequest(MaintenanceRequest newRequest) {
    setState(() {
      _request = newRequest;
    });
  }

  @override
  Widget build(BuildContext context) {
     final scheduledTime = _request.scheduledAt == null
    ? null
    : DateFormat('HH:mm, dd/MM/yyyy').format(_request.scheduledAt!);

    return  Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: const CommonAppBar(title: 'Chi tiết sự cố'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MaintenanceNoticeBanner(),
            const SizedBox(height: 14),

            if (_request.technicianName != null ||
              _request.technicianPhone != null ||
              _request.scheduledAt != null) ...[
            WorkerInfoCard(
              workerName: _request.technicianName ?? 'Chưa có tên thợ',
              scheduledTime: scheduledTime ?? 'Chưa có lịch sửa',
            ),
              const SizedBox(height: 14),
            ],

            ProcessingTimelineCard(
              request: _request,
            ),
            const SizedBox(height: 14),
            IssueDetailCard(
              request: _request,
            ),
          ],
        ),
      ),
      bottomNavigationBar:  MaintenanceDetailBottomBar(
        request: _request,
        onRequestChanged: _updateRequest,
      ),
    );
  }
}