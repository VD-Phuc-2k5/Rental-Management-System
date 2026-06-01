import 'package:domain/rental_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/format_currency.dart';
import '../../../../core/utils/sealed_class_state.dart';
import '../blocs/my_contract_list/my_contract_list_bloc.dart';

class MyContractsPage extends StatelessWidget {
  const MyContractsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyContractListBloc>()..add(MyContractListFetched()),
      child: const _MyContractsView(),
    );
  }
}

class _MyContractsView extends StatelessWidget {
  const _MyContractsView();

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
          'Hợp đồng của tôi',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.blue700),
            onPressed: () =>
                context.read<MyContractListBloc>().add(MyContractListFetched()),
          ),
        ],
      ),
      body: BlocBuilder<MyContractListBloc, MyContractListState>(
        builder: (context, state) {
          final list = state.currentOrPreviousData;
          final isLoading = state is MyContractListLoadInProgress;

          if (state is MyContractListInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MyContractListLoadFailure && list == null) {
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
                        .read<MyContractListBloc>()
                        .add(MyContractListFetched()),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          if (list != null && list.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có hợp đồng nào.',
                style: TextStyle(color: AppColors.slate500),
              ),
            );
          }
          return RefreshIndicator(
            color: AppColors.blue700,
            onRefresh: () async =>
                context.read<MyContractListBloc>().add(MyContractListFetched()),
            child: Stack(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list?.length ?? 0,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _MyContractCard(contract: list![index]),
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

class _MyContractCard extends StatelessWidget {
  const _MyContractCard({required this.contract});

  final ContractEntity contract;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        RoutePaths.contractPreview,
        extra: {'contractId': contract.id, 'isLandlord': false},
      ),
      borderRadius: BorderRadius.circular(12),
      child: Card(
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
                  const Icon(Icons.description_outlined,
                      size: 18, color: AppColors.blue700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Phòng: ${contract.roomId}',
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
                  _ContractStatusChip(status: contract.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${contract.startDate.substring(0, 10)} → ${contract.endDate.substring(0, 10)}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.slate500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${formatCurrency(contract.monthlyRent)}/tháng • Cọc: ${formatCurrency(contract.deposit)}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.slate500,
                ),
              ),
              if (contract.status == ContractStatus.sent) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit_note, size: 16),
                    label: const Text('Xem & Ký hợp đồng'),
                    onPressed: () => context.push(
                      RoutePaths.contractPreview,
                      extra: {'contractId': contract.id, 'isLandlord': false},
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
            ],
          ),
        ),
      ),
    );
  }
}

class _ContractStatusChip extends StatelessWidget {
  const _ContractStatusChip({required this.status});

  final ContractStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      ContractStatus.draft => (
          'Bản nháp',
          AppColors.slate100,
          AppColors.slate500,
        ),
      ContractStatus.sent => (
          'Chờ ký',
          AppColors.amber100,
          AppColors.amber500,
        ),
      ContractStatus.signed => (
          'Đã ký',
          AppColors.green100,
          AppColors.green700,
        ),
      ContractStatus.cancelled => (
          'Đã huỷ',
          AppColors.red100,
          AppColors.red500,
        ),
      ContractStatus.finished => (
          'Kết thúc',
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
