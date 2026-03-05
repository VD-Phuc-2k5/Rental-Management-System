import 'package:flutter/material.dart';
import 'package:app/core/models/maintenance_request.dart';
import 'package:app/core/models/priority.dart';
import 'package:app/core/widgets/maintenance_request_card.dart';

class HistoryRequestsView extends StatelessWidget {
  const HistoryRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final historyRequests = <MaintenanceRequest>[
      MaintenanceRequest(
        id: 'mr_001',
        title: 'Vòi nước rò rỉ',
        description: 'Nước chảy liên tục ở bồn rửa mặt, g...',
        location: '',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        priority: Priority.high,
        status: RequestStatus.pending,
        imageUrls: const [
          'assets/images/water_tap.png',
        ],
      ),
      MaintenanceRequest(
        id: 'mr_002',
        title: 'Hỏng khoá cửa chính',
        description: 'Khoá bị kẹt, rất khó mở từ bên ngoài...',
        location: '',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        priority: Priority.medium,
        status: RequestStatus.pending,
        imageUrls: const [
          'assets/images/primary_key.png',
        ],
      ),
      MaintenanceRequest(
        id: 'mr_003',
        title: 'Thay bóng đèn hành lang',
        description: 'Bóng đèn bị cháy sáng nay.',
        location: '',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        priority: Priority.low,
        status: RequestStatus.processing,
        imageUrls: const [],
      ),
    ];

    if (historyRequests.isEmpty) {
      return const Center(child: Text('Chưa có dữ liệu'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      itemCount: historyRequests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => MaintenanceRequestCard(
        request: historyRequests[i],
        onTap: () {},
      ),
    );
  }
}