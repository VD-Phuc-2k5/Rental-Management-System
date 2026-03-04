import "package:app/core/constants.dart";
import "package:app/core/models/maintenance_request.dart";
import "package:app/core/widgets/maintenance_request_card.dart";
import 'package:app/core/models/priority.dart';
import "package:app/screens/landlord-maintenance-schedule-screen/landlord_maintenance_schedule_screen.dart";
import "package:flutter/material.dart";

class ProcessRequestsList extends StatefulWidget {
  const ProcessRequestsList({super.key});

  @override
  State<ProcessRequestsList> createState() => _ProcessRequestsListState();
}

class _ProcessRequestsListState extends State<ProcessRequestsList> {
  bool _isLoading = false;
  List<MaintenanceRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TO DO: Implement API call to fetch pending/processing requests
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - only pending and processing requests
      final mockRequests = [
        MaintenanceRequest(
          id: "1",
          title: "Vòi nước rò rỉ",
          description: "Nước chảy liên tục ở bồn rửa mặt, gây lãng phí nước.",
          location: "Phòng 101 - Nguyễn Văn A",
          priority: Priority.high,
          status: RequestStatus.pending,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          imageUrls: [
            "assets/images/maintenance1-image.png",
            "assets/images/maintenance2-image.png",
          ],
        ),
        MaintenanceRequest(
          id: "2",
          title: "Hỏng khóa cửa chính",
          description: "Khóa bị kẹt, rất khó mở từ bên ngoài...",
          location: "Phòng 204 - Trần Thị B",
          priority: Priority.medium,
          status: RequestStatus.pending,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          imageUrls: [],
        ),
        MaintenanceRequest(
          id: "3",
          title: "Thay bóng đèn hành lang",
          description: "Bóng đèn bị cháy sáng nay.",
          location: "Tầng 3 - Khu A",
          priority: Priority.low,
          status: RequestStatus.processing,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          imageUrls: [],
        ),
      ];

      if (mounted) {
        setState(() {
          _requests = mockRequests;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _requests.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.blue700),
      );
    }

    if (_requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: AppColors.slate300),
            const SizedBox(height: 16),
            Text(
              "Không có yêu cầu cần xử lý",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.slate500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.blue700,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final request = _requests[index];
          return MaintenanceRequestCard(
            request: request,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      LandlordMaintenanceScheduleScreen(request: request),
                ),
              );
            },
            actionButton: _buildActionButton(request),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(MaintenanceRequest request) {
    if (request.status == RequestStatus.pending) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.orange100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          "Chờ xử lý",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.orange600,
          ),
        ),
      );
    } else if (request.status == RequestStatus.processing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.blue100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          "Chờ xác nhận",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.blue700,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
