import 'package:domain/rental_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/format_currency.dart';
import '../blocs/contract_detail/contract_detail_bloc.dart';

class ContractPreviewPage extends StatelessWidget {
  const ContractPreviewPage({super.key, required this.contractId});

  final String contractId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ContractDetailBloc>()
        ..add(ContractDetailFetched(contractId: contractId)),
      child: const _ContractPreviewView(),
    );
  }
}

class _ContractPreviewView extends StatelessWidget {
  const _ContractPreviewView();

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
          'Chi tiết hợp đồng',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
      body: BlocBuilder<ContractDetailBloc, ContractDetailState>(
        builder: (context, state) {
          return switch (state) {
            ContractDetailLoadInProgress() => const Center(
                child: CircularProgressIndicator(),
              ),
            ContractDetailLoadFailure(:final failure) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      failure.toString(),
                      style: const TextStyle(color: AppColors.red500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ContractDetailLoadSuccess(:final data) =>
              _ContractDetail(contract: data),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _ContractDetail extends StatelessWidget {
  const _ContractDetail({required this.contract});

  final ContractEntity contract;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ContractField(
                  label: 'Ngày bắt đầu',
                  value: contract.startDate.substring(0, 10),
                ),
                _ContractField(
                  label: 'Ngày kết thúc',
                  value: contract.endDate.substring(0, 10),
                ),
                _ContractField(
                  label: 'Tiền thuê hàng tháng',
                  value: formatCurrency(contract.monthlyRent),
                ),
                _ContractField(
                  label: 'Tiền đặt cọc',
                  value: formatCurrency(contract.deposit),
                ),
                _ContractField(
                  label: 'Trạng thái',
                  value: _statusLabel(contract.status),
                ),
                if (contract.terms != null && contract.terms!.isNotEmpty)
                  _ContractField(
                    label: 'Điều khoản',
                    value: contract.terms!,
                  ),
              ],
            ),
          ),
        ),
        if (contract.status == ContractStatus.sent)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    await getIt<SignContractUsecase>().call(
                      SignContractParams(id: contract.id),
                    );
                    if (context.mounted) context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Ký hợp đồng',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _statusLabel(ContractStatus status) {
    return switch (status) {
      ContractStatus.draft => 'Bản nháp',
      ContractStatus.sent => 'Chờ ký',
      ContractStatus.signed => 'Đã ký',
      ContractStatus.cancelled => 'Đã huỷ',
      ContractStatus.finished => 'Đã kết thúc',
    };
  }
}

class _ContractField extends StatelessWidget {
  const _ContractField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.slate500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.slate200, height: 1),
        ],
      ),
    );
  }
}
