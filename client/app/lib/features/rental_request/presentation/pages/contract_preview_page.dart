import 'package:domain/rental_request.dart';
import 'package:domain/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/format_currency.dart';
import '../blocs/contract_detail/contract_detail_bloc.dart';

class ContractPreviewPage extends StatelessWidget {
  const ContractPreviewPage({
    super.key,
    required this.contractId,
    this.isLandlord = false,
  });

  final String contractId;
  final bool isLandlord;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ContractDetailBloc>()
            ..add(ContractDetailFetched(contractId: contractId)),
      child: _ContractPreviewView(isLandlord: isLandlord),
    );
  }
}

class _ContractPreviewView extends StatelessWidget {
  const _ContractPreviewView({required this.isLandlord});

  final bool isLandlord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Hợp đồng thuê trọ',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF111417),
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
              child: Text(
                failure.toString(),
                style: const TextStyle(color: AppColors.red500),
                textAlign: TextAlign.center,
              ),
            ),
            ContractDetailLoadSuccess(:final data) => _ContractContent(
              contract: data,
              isLandlord: isLandlord,
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _ContractContent extends StatefulWidget {
  const _ContractContent({required this.contract, required this.isLandlord});

  final ContractEntity contract;
  final bool isLandlord;

  @override
  State<_ContractContent> createState() => _ContractContentState();
}

class _ContractContentState extends State<_ContractContent> {
  late final Future<List<ContractMemberEntity>> _membersFuture;
  late final Future<BrowseRoomDetailEntity?> _roomDetailFuture;

  @override
  void initState() {
    super.initState();
    _membersFuture = getIt<GetContractMembersUsecase>()
        .call(GetContractMembersParams(contractId: widget.contract.id))
        .then(
          (result) => result.fold(
            (_) => <ContractMemberEntity>[],
            (members) => members,
          ),
        );
    _roomDetailFuture = getIt<GetBrowseRoomDetailUsecase>()
        .call(GetBrowseRoomDetailParams(id: widget.contract.roomId))
        .then((result) => result.fold((_) => null, (room) => room));
  }

  int _monthsBetween(String startDate, String endDate) {
    final start = DateTime.tryParse(startDate);
    final end = DateTime.tryParse(endDate);
    if (start == null || end == null) return 0;
    return (end.year - start.year) * 12 + (end.month - start.month);
  }

  @override
  Widget build(BuildContext context) {
    final contract = widget.contract;

    return FutureBuilder<List<ContractMemberEntity>>(
      future: _membersFuture,
      builder: (context, snapshot) {
        final members = snapshot.data ?? [];
        final activeMembers = members.where((m) => m.leftAt == null).toList();
        final tenant = activeMembers.where((m) => m.isRoomLeader).firstOrNull;
        final duration = _monthsBetween(contract.startDate, contract.endDate);

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ContractCard(
                      contract: contract,
                      tenant: tenant,
                      allMembers: activeMembers,
                      durationMonths: duration,
                    ),
                    const SizedBox(height: 16),
                    _DepositCard(deposit: contract.deposit),
                    const SizedBox(height: 16),
                    _ServiceRatesCard(roomDetailFuture: _roomDetailFuture),
                  ],
                ),
              ),
            ),
            if (widget.isLandlord && contract.status == ContractStatus.draft)
              _SendBottomBar(contractId: contract.id),
          ],
        );
      },
    );
  }
}

class _ContractCard extends StatelessWidget {
  const _ContractCard({
    required this.contract,
    required this.tenant,
    required this.allMembers,
    required this.durationMonths,
  });

  final ContractEntity contract;
  final ContractMemberEntity? tenant;
  final List<ContractMemberEntity> allMembers;
  final int durationMonths;

  String _formatDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.tryParse(contract.createdAt);
    final dateText = createdAt != null
        ? 'ngày ${createdAt.day} tháng ${createdAt.month} năm ${createdAt.year}'
        : '';

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    'HỢP ĐỒNG THUÊ TRỌ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blue800,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Số: ${contract.id.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(
                      color: AppColors.slate500,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.slate500,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.slate200),
            const SizedBox(height: 12),

            const _SectionTitle(text: 'I. BÊN THUÊ (BÊN B)'),
            const SizedBox(height: 10),
            _InfoRow(label: 'Họ và tên:', value: tenant?.fullName ?? '—'),
            if (tenant?.identityNumber != null)
              _InfoRow(label: 'CMND/CCCD:', value: tenant!.identityNumber!),
            if (tenant?.phone != null)
              _InfoRow(label: 'Điện thoại:', value: tenant!.phone!),
            if (allMembers.length > 1) ...[
              const SizedBox(height: 8),
              const Text(
                'Thành viên:',
                style: TextStyle(
                  color: AppColors.slate500,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              ...allMembers
                  .where((m) => !m.isRoomLeader)
                  .map((m) => _InfoRow(label: '•', value: m.fullName)),
            ],

            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.slate200),
            const SizedBox(height: 12),

            const _SectionTitle(text: 'II. CHI TIẾT THUÊ'),
            const SizedBox(height: 10),
            _InfoRowBlue(
              label: 'Giá thuê:',
              value: '${formatCurrency(contract.monthlyRent)}/tháng',
            ),
            _InfoRow(
              label: 'Từ ngày:',
              value: _formatDate(contract.startDate),
            ),
            _InfoRow(
              label: 'Đến ngày:',
              value: _formatDate(contract.endDate),
            ),
            if (durationMonths > 0)
              _InfoRow(label: 'Thời hạn:', value: '$durationMonths tháng'),

            if (contract.terms != null && contract.terms!.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.slate200),
              const SizedBox(height: 12),
              const _SectionTitle(text: 'III. ĐIỀU KHOẢN CHUNG'),
              const SizedBox(height: 10),
              Text(
                contract.terms!,
                style: const TextStyle(
                  color: AppColors.slate600,
                  height: 1.35,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],

            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.slate200),
            const SizedBox(height: 12),

            Row(
              children: [
                const Expanded(
                  child: _SignatureBox(
                    title: 'BÊN CHO THUÊ',
                    name: '(Chủ trọ)',
                    signed: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SignatureBox(
                    title: 'BÊN THUÊ',
                    name: tenant?.fullName ?? '(Người thuê)',
                    signed: contract.status == ContractStatus.signed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DepositCard extends StatelessWidget {
  const _DepositCard({required this.deposit});

  final double deposit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tiền đặt cọc',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.blue950,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.payments_outlined,
                        color: AppColors.slate500,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          formatCurrency(deposit),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.blue950,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Text(
                        'VND',
                        style: TextStyle(
                          color: AppColors.slate500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Số tiền này sẽ được ghi nhận vào biên lai thu tiền cọc.',
                  style: TextStyle(
                    color: AppColors.slate500,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SendBottomBar extends StatelessWidget {
  const _SendBottomBar({required this.contractId});

  final String contractId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFDCE0E5), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await getIt<SendContractUsecase>().call(
                SendContractParams(id: contractId),
              );
              if (context.mounted) context.pop();
            },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.blue800),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                ),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Gửi hợp đồng cho khách',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceRatesCard extends StatelessWidget {
  const _ServiceRatesCard({required this.roomDetailFuture});

  final Future<BrowseRoomDetailEntity?> roomDetailFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BrowseRoomDetailEntity?>(
      future: roomDetailFuture,
      builder: (context, snapshot) {
        final room = snapshot.data;
        if (room == null) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bảng giá dịch vụ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.blue950,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'Điện (kWh):',
                      value: formatCurrency(room.electricityRatePerKwh),
                    ),
                    _InfoRow(
                      label: 'Nước (m³):',
                      value: formatCurrency(room.waterRatePerM3),
                    ),
                    if (room.parkingFees.motorbike > 0)
                      _InfoRow(
                        label: 'Xe máy/tháng:',
                        value: formatCurrency(room.parkingFees.motorbike),
                      ),
                    if (room.parkingFees.car > 0)
                      _InfoRow(
                        label: 'Ô tô/tháng:',
                        value: formatCurrency(room.parkingFees.car),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.blue950,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 98,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.slate500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.blue950,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRowBlue extends StatelessWidget {
  const _InfoRowBlue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 98,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.slate500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.blue800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignatureBox extends StatelessWidget {
  const _SignatureBox({
    required this.title,
    required this.name,
    required this.signed,
  });

  final String title;
  final String name;
  final bool signed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.slate500,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 86,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: signed ? AppColors.blue800 : AppColors.slate300,
              width: 2,
            ),
            color: AppColors.slate50,
          ),
          child: Center(
            child: Text(
              signed ? 'Đã ký' : 'Chưa ký',
              style: TextStyle(
                color: signed ? AppColors.blue800 : AppColors.slate400,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.blue950,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
