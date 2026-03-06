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
        createdAt: DateTime(2026, 3, 5, 10, 0),
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
        createdAt: DateTime(2026, 3, 5, 12, 0),
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
        createdAt: DateTime(2026, 3, 5, 1, 0),
        priority: Priority.low,
        status: RequestStatus.processing,
        imageUrls: const [],
      ),
    ];
    
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
      itemCount: historyRequests.length,
      itemBuilder: (context, i) => MaintenanceRequestCard(
        request: historyRequests[i],
        onTap: () {},
      ),
    );
  }
}