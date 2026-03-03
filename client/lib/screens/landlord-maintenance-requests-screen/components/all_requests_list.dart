import "package:app/core/constants.dart";
import "package:app/core/models/maintenance_request.dart";
import "package:app/core/widgets/maintenance_request_card.dart";
import "package:app/core/models/priority.dart";
import "package:flutter/material.dart";

class AllRequestsList extends StatefulWidget {
  const AllRequestsList({super.key});

  @override
  State<AllRequestsList> createState() => _AllRequestsListState();
}

class _AllRequestsListState extends State<AllRequestsList> {
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
      // TODO: Implement API call to fetch all maintenance requests
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - all requests from all rooms
      final mockRequests = [
        MaintenanceRequest(
          id: "1",
          title: "Vòi nước rò rỉ",
          description: "Nước chảy liên tục ở bồn rửa mặt, gây lãng phí nước.",
          location: "Phòng 101 - Nguyễn Văn A",
          priority: Priority.high,
          status: RequestStatus.pending,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          imageUrl: null,
        ),
        MaintenanceRequest(
          id: "2",
          title: "Hỏng khóa cửa chính",
          description: "Khóa bị kẹt, rất khó mở từ bên ngoài...",
          location: "Phòng 204 - Trần Thị B",
          priority: Priority.medium,
          status: RequestStatus.pending,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          imageUrl: null,
        ),
        MaintenanceRequest(
          id: "3",
          title: "Thay bóng đèn hành lang",
          description: "Bóng đèn bị cháy sáng nay.",
          location: "Tầng 3 - Khu A",
          priority: Priority.low,
          status: RequestStatus.processing,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          imageUrl: null,
        ),
        MaintenanceRequest(
          id: "4",
          title: "Sửa chữa điều hòa",
          description:
              "Điều hòa không hoạt động, phát ra tiếng ồn lớn và không làm lạnh được.",
          location: "Phòng 105 - Lê Văn C",
          priority: Priority.high,
          status: RequestStatus.completed,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          imageUrl: null,
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
              "Chưa có yêu cầu nào",
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
              // TODO: Navigate to request detail
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Chi tiết: ${request.title}"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
