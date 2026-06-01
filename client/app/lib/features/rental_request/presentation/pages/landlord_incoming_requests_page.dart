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
      create: (_) =>
          getIt<LandlordRequestListBloc>()..add(LandlordRequestListFetched()),
      child: const _LandlordIncomingRequestsView(),
    );
  }
}

class _LandlordIncomingRequestsView extends StatelessWidget {
  const _LandlordIncomingRequestsView();

  // Hide rejected requests that are older than 24 hours.
  List<RentalRequestEntity> _filterVisible(List<RentalRequestEntity> list) {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    return list.where((r) {
      if (r.status != RentalRequestStatus.rejected) return true;
      final updatedAt = DateTime.tryParse(r.updatedAt);
      return updatedAt != null && updatedAt.isAfter(cutoff);
    }).toList();
  }

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
            icon: const Icon(
              Icons.description_outlined,
              color: AppColors.blue700,
            ),
            tooltip: 'Hợp đồng',
            onPressed: () => context.push(RoutePaths.landlordContracts),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.blue700),
            onPressed: () => context.read<LandlordRequestListBloc>().add(
              LandlordRequestListFetched(),
            ),
          ),
        ],
      ),
      body: BlocBuilder<LandlordRequestListBloc, LandlordRequestListState>(
        builder: (context, state) {
          final raw = state.currentOrPreviousData;
          final list = raw != null ? _filterVisible(raw) : null;
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
            onRefresh: () async => context.read<LandlordRequestListBloc>().add(
              LandlordRequestListFetched(),
            ),
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

class _RentalRequestCard extends StatefulWidget {
  const _RentalRequestCard({required this.request});

  final RentalRequestEntity request;

  @override
  State<_RentalRequestCard> createState() => _RentalRequestCardState();
}

enum _ContractAction { view, edit }

class _RentalRequestCardState extends State<_RentalRequestCard> {
  _ContractAction? _loadingAction;

  bool get _isLoadingContract => _loadingAction != null;

  String _formatDateDMY(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      final trimmed = raw.length >= 10 ? raw.substring(0, 10) : raw;
      return trimmed.replaceAll('-', '/');
    }
    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    return '$day/$month/${parsed.year}';
  }

  String get _senderName {
    final members = widget.request.memberInfo;
    final leader = members.where((m) => m.isRoomLeader).firstOrNull;
    return (leader ?? members.firstOrNull)?.fullName ?? 'Không rõ';
  }

  String get _roomDisplay => widget.request.roomTitle ?? widget.request.roomId;

  bool get _hasContract =>
      widget.request.status == RentalRequestStatus.pending ||
      widget.request.status == RentalRequestStatus.accepted ||
      widget.request.status == RentalRequestStatus.contracted;

  Future<void> _withContract(
    BuildContext context,
    _ContractAction action,
    Future<void> Function(ContractEntity contract) onSuccess,
  ) async {
    if (_isLoadingContract) return;
    setState(() => _loadingAction = action);
    try {
      final result = await getIt<GetContractByRentalRequestIdUsecase>()(
        GetContractByRentalRequestIdParams(
          rentalRequestId: widget.request.id,
        ),
      );
      if (!mounted) return;
      await result.fold(
        (failure) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.toString())),
          );
        },
        onSuccess,
      );
    } finally {
      if (mounted) setState(() => _loadingAction = null);
    }
  }

  Future<void> _openContract(BuildContext context) async {
    await _withContract(
      context,
      _ContractAction.view,
      (contract) async {
        await context.push(
          RoutePaths.contractPreview,
          extra: {'contractId': contract.id, 'isLandlord': true},
        );
      },
    );
  }

  Future<void> _openContractEditor(BuildContext context) async {
    await _withContract(
      context,
      _ContractAction.edit,
      (contract) async {
        await context.push(
          RoutePaths.landlordContractEdit,
          extra: contract,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    return Card(
      color: AppColors.white,
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
                const Icon(
                  Icons.home_outlined,
                  size: 18,
                  color: AppColors.blue700,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Phòng: $_roomDisplay',
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
            const SizedBox(height: 4),
            Text(
              'Người gửi: $_senderName',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.slate500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Ngày gửi: ${_formatDateDMY(request.createdAt)}',
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
            if (request.status == RentalRequestStatus.pending ||
                _hasContract) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.slate50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    if (request.status == RentalRequestStatus.pending)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isLoadingContract
                              ? null
                              : () =>
                                    context.read<LandlordRequestListBloc>().add(
                                      LandlordRequestListRejected(
                                        id: request.id,
                                      ),
                                    ),
                          icon: const Icon(Icons.close_rounded, size: 16),
                          label: const Text('Từ chối'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.red500,
                            side: const BorderSide(color: AppColors.red500),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    if (request.status == RentalRequestStatus.pending &&
                        _hasContract)
                      const SizedBox(height: 8),
                    if (_hasContract)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isLoadingContract
                                  ? null
                                  : () => _openContract(context),
                              icon: _loadingAction == _ContractAction.view
                                  ? const SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.blue700,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.visibility_outlined,
                                      size: 16,
                                    ),
                              label: Text(
                                _loadingAction == _ContractAction.view
                                    ? 'Đang tải...'
                                    : 'Xem HĐ',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.blue700,
                                side: const BorderSide(
                                  color: AppColors.blue700,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isLoadingContract
                                  ? null
                                  : () => _openContractEditor(context),
                              icon: _loadingAction == _ContractAction.edit
                                  ? const SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.edit_outlined, size: 16),
                              label: Text(
                                _loadingAction == _ContractAction.edit
                                    ? 'Đang tải...'
                                    : 'Cập nhật HĐ',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blue700,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
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
