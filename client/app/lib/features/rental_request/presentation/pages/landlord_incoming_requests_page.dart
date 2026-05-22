import 'package:domain/rental_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/utils/sealed_class_state.dart';
import '../blocs/landlord_request_list/landlord_request_list_bloc.dart';

class LandlordIncomingRequestsPage extends StatelessWidget {
  const LandlordIncomingRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LandlordRequestListBloc>()
        ..add(LandlordRequestListFetched()),
      child: const _LandlordIncomingRequestsView(),
    );
  }
}

class _LandlordIncomingRequestsView extends StatelessWidget {
  const _LandlordIncomingRequestsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue700),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Yêu cầu thuê',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.description_outlined, color: AppColors.blue700),
            tooltip: 'Hợp đồng',
            onPressed: () => context.push(RoutePaths.landlordContracts),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.blue700),
            onPressed: () => context
                .read<LandlordRequestListBloc>()
                .add(LandlordRequestListFetched()),
          ),
        ],
      ),
      body: BlocBuilder<LandlordRequestListBloc, LandlordRequestListState>(
        builder: (context, state) {
          final list = state.currentOrPreviousData;
          final isLoading = state is LandlordRequestListLoadInProgress;

          if (state is LandlordRequestListInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LandlordRequestListLoadFailure && list == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.failure.toString(),
                    style: const TextStyle(color: AppColors.red500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<LandlordRequestListBloc>()
                        .add(LandlordRequestListFetched()),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          if (list != null && list.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có yêu cầu thuê nào.',
                style: TextStyle(color: AppColors.slate500),
              ),
            );
          }
          return RefreshIndicator(
            color: AppColors.blue700,
            onRefresh: () async => context
                .read<LandlordRequestListBloc>()
                .add(LandlordRequestListFetched()),
            child: Stack(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list?.length ?? 0,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _RentalRequestCard(request: list![index]),
                ),
                if (isLoading)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(color: AppColors.blue700),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RentalRequestCard extends StatelessWidget {
  const _RentalRequestCard({required this.request});

  final RentalRequestEntity request;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.slate200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.home_outlined,
                    size: 18, color: AppColors.blue700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Phòng: ${request.roomId}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _StatusChip(status: request.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Ngày gửi: ${request.createdAt.substring(0, 10)}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.slate500,
              ),
            ),
            if (request.note != null && request.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Ghi chú: ${request.note}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.slate500,
                ),
              ),
            ],
            if (request.status == RentalRequestStatus.pending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context
                          .read<LandlordRequestListBloc>()
                          .add(LandlordRequestListRejected(id: request.id)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.red500,
                        side: const BorderSide(color: AppColors.red500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Từ chối'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          context.push(RoutePaths.landlordContracts),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Xem HĐ'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final RentalRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      RentalRequestStatus.pending => (
          'Chờ duyệt',
          AppColors.amber100,
          AppColors.amber500,
        ),
      RentalRequestStatus.accepted => (
          'Đã chấp nhận',
          AppColors.green100,
          AppColors.green700,
        ),
      RentalRequestStatus.rejected => (
          'Từ chối',
          AppColors.red100,
          AppColors.red500,
        ),
      RentalRequestStatus.contracted => (
          'Đã ký HĐ',
          AppColors.blue100,
          AppColors.blue700,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
