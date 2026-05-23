import 'package:domain/rental_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
                const SizedBox(height: 8),
                _MembersSection(contractId: contract.id),
              ],
            ),
          ),
        ),
        if (contract.status == ContractStatus.sent) ...[
          if (contract.momoNumber != null)
            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(
                      'momo://transfer?phone=${contract.momoNumber}',
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Không thể mở ứng dụng MoMo'),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.payment, color: Color(0xFFAE2070)),
                  label: Text(
                    'Chuyển cọc qua MoMo (${contract.momoNumber})',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFAE2070),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFAE2070)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
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

class _MembersSection extends StatefulWidget {
  const _MembersSection({required this.contractId});

  final String contractId;

  @override
  State<_MembersSection> createState() => _MembersSectionState();
}

class _MembersSectionState extends State<_MembersSection> {
  late final Future<List<ContractMemberEntity>> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<GetContractMembersUsecase>()
        .call(GetContractMembersParams(contractId: widget.contractId))
        .then(
          (result) => result.fold(
            (_) => <ContractMemberEntity>[],
            (members) => members,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ContractMemberEntity>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final members = snapshot.data ?? [];
        if (members.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thành viên',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.slate500,
              ),
            ),
            const SizedBox(height: 8),
            ...members.where((m) => m.leftAt == null).map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          m.isRoomLeader ? Icons.star : Icons.person,
                          size: 16,
                          color: m.isRoomLeader
                              ? AppColors.amber500
                              : AppColors.slate500,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            m.fullName +
                                (m.isRoomLeader ? ' (Trưởng phòng)' : ''),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 8),
            const Divider(color: AppColors.slate200, height: 1),
          ],
        );
      },
    );
  }
}
