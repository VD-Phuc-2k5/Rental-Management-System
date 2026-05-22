import 'package:domain/rental_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../blocs/my_rental_request_list/my_rental_request_list_bloc.dart';

class MyRentalRequestsPage extends StatelessWidget {
  const MyRentalRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyRentalRequestListBloc>()
        ..add(MyRentalRequestListFetched()),
      child: const _MyRentalRequestsView(),
    );
  }
}

class _MyRentalRequestsView extends StatelessWidget {
  const _MyRentalRequestsView();

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Yêu cầu thuê của tôi',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
      body: BlocBuilder<MyRentalRequestListBloc, MyRentalRequestListState>(
        builder: (context, state) {
          return switch (state) {
            MyRentalRequestListLoadInProgress() => const Center(
                child: CircularProgressIndicator(),
              ),
            MyRentalRequestListLoadFailure(:final failure) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      failure.toString(),
                      style: const TextStyle(color: AppColors.red500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context
                          .read<MyRentalRequestListBloc>()
                          .add(MyRentalRequestListFetched()),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            MyRentalRequestListLoadSuccess(:final data) when data.isEmpty =>
              const Center(
                child: Text(
                  'Bạn chưa có yêu cầu thuê nào.',
                  style: TextStyle(color: AppColors.slate500),
                ),
              ),
            MyRentalRequestListLoadSuccess(:final data) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _RentalRequestCard(request: data[index]),
              ),
            _ => const SizedBox.shrink(),
          };
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await getIt<CancelRentalRequestUsecase>().call(
                      CancelRentalRequestParams(id: request.id),
                    );
                    if (context.mounted) {
                      context
                          .read<MyRentalRequestListBloc>()
                          .add(MyRentalRequestListFetched());
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red500,
                    side: const BorderSide(color: AppColors.red500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Huỷ yêu cầu'),
                ),
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
