import 'package:domain/rental_request.dart';
import 'package:domain/room.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../screens/qr-payment-screen/qr_payment_screen.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/format_currency.dart';
import '../blocs/deposit_payment/deposit_payment_cubit.dart';

class DepositPaymentSheet extends StatelessWidget {
  const DepositPaymentSheet({super.key, required this.contract});

  final ContractEntity contract;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DepositPaymentCubit>(),
      child: _DepositPaymentContent(contract: contract),
    );
  }
}

class _DepositPaymentContent extends StatefulWidget {
  const _DepositPaymentContent({required this.contract});

  final ContractEntity contract;

  @override
  State<_DepositPaymentContent> createState() => _DepositPaymentContentState();
}

class _DepositPaymentContentState extends State<_DepositPaymentContent> {
  late final Future<BrowseRoomDetailEntity?> _roomDetailFuture;
  late final Future<RentalRequestEntity?> _rentalRequestFuture;

  @override
  void initState() {
    super.initState();
    _roomDetailFuture = getIt<GetBrowseRoomDetailUsecase>()
        .call(GetBrowseRoomDetailParams(id: widget.contract.roomId))
        .then((result) => result.fold((_) => null, (room) => room));
    final rentalRequestId = widget.contract.rentalRequestId;
    _rentalRequestFuture = rentalRequestId != null
        ? getIt<GetRentalRequestByIdUsecase>()
            .call(GetRentalRequestByIdParams(id: rentalRequestId))
            .then((result) => result.fold((_) => null, (req) => req))
        : Future.value(null);
  }

  void _navigateToQrPayment(
    NavigatorState navigator, {
    required String contractId,
    required String? qrCodeBase64,
    required String roomName,
    required int amount,
  }) {
    navigator.push(
      MaterialPageRoute(
        builder: (_) => QrPaymentScreen(
          price: amount,
          roomName: roomName,
          contractId: contractId,
          qrCodeBase64: qrCodeBase64,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DepositPaymentCubit, DepositPaymentState>(
      listener: (context, state) async {
        if (state is DepositPaymentSuccess) {
          log('[DepositPayment] payUrl: \'${state.payUrl}\'', name: 'DepositPaymentSheet');
          final room = await _roomDetailFuture;
          final roomName = room?.title ?? 'Phòng';
          final amount = widget.contract.deposit.toInt();
          log('[DepositPayment] roomName: $roomName, amount: $amount', name: 'DepositPaymentSheet');
          if (context.mounted) {
            final navigator = Navigator.of(context, rootNavigator: true);
            navigator.pop();
            log('[DepositPayment] Push QrPaymentScreen with qrCodeUrl: \'${state.qrCodeUrl}\'', name: 'DepositPaymentSheet');
            _navigateToQrPayment(
              navigator,
              contractId: widget.contract.id,
              qrCodeBase64: state.qrCodeUrl,
              roomName: roomName,
              amount: amount,
            );
          }
        }
        if (state is DepositPaymentRejected) {
          if (context.mounted) {
            final router = GoRouter.of(context);
            final messenger = ScaffoldMessenger.of(context);
            Navigator.of(context).pop();
            messenger.showSnackBar(
              const SnackBar(content: Text('Đã từ chối hợp đồng.')),
            );
            router.push(RoutePaths.myRequests); // ignore: unawaited_futures
          }
        }
      },
      builder: (context, state) {
        final isLoading =
            state is DepositPaymentLoading || state is DepositPaymentRejecting;

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.gray300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Thanh toán tiền cọc',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ContractSummaryCard(contract: widget.contract),
                  const SizedBox(height: 16),
                  _ServiceRatesSection(
                    roomDetailFuture: _roomDetailFuture,
                    rentalRequestFuture: _rentalRequestFuture,
                  ),
                  const SizedBox(height: 20),
                  if (state is DepositPaymentFailure) ...[
                    Text(
                      state.message,
                      style: const TextStyle(
                        color: AppColors.red500,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => context
                              .read<DepositPaymentCubit>()
                              .pay(widget.contract.id),
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.account_balance_wallet_outlined),
                      label: const Text(
                        'Thanh toán cọc qua PayOS',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAE2070),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context
                              .read<DepositPaymentCubit>()
                              .reject(widget.contract.id),
                      child: const Text(
                        'Từ chối hợp đồng',
                        style: TextStyle(
                          color: AppColors.red500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ServiceRatesSection extends StatelessWidget {
  const _ServiceRatesSection({
    required this.roomDetailFuture,
    required this.rentalRequestFuture,
  });

  final Future<BrowseRoomDetailEntity?> roomDetailFuture;
  final Future<RentalRequestEntity?> rentalRequestFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object?>>(
      future: Future.wait([roomDetailFuture, rentalRequestFuture]),
      builder: (context, snapshot) {
        final room = snapshot.data?[0] as BrowseRoomDetailEntity?;
        if (room == null) return const SizedBox.shrink();

        final parking =
            (snapshot.data?[1] as RentalRequestEntity?)?.parkingInfo ?? [];
        final motorbikeCount = parking
            .where((v) => v.type == 'Xe máy')
            .fold(0, (sum, v) => sum + v.quantity);
        final carCount = parking
            .where((v) => v.type == 'Ô tô')
            .fold(0, (sum, v) => sum + v.quantity);

        final motorbikeTotal = room.parkingFees.motorbike * motorbikeCount;
        final carTotal = room.parkingFees.car * carCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bảng giá dịch vụ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.slate600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.gray25,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.slate200),
              ),
              child: Column(
                children: [
                  _RateRow(
                    icon: Icons.bolt_outlined,
                    label: 'Điện (kWh)',
                    value: formatCurrency(room.electricityRatePerKwh),
                  ),
                  const SizedBox(height: 6),
                  _RateRow(
                    icon: Icons.water_drop_outlined,
                    label: 'Nước (m³)',
                    value: formatCurrency(room.waterRatePerM3),
                  ),
                  if (motorbikeTotal > 0) ...[
                    const SizedBox(height: 6),
                    _RateRow(
                      icon: Icons.two_wheeler_outlined,
                      label: 'Xe máy ($motorbikeCount chiếc/tháng)',
                      value: formatCurrency(motorbikeTotal),
                    ),
                  ],
                  if (carTotal > 0) ...[
                    const SizedBox(height: 6),
                    _RateRow(
                      icon: Icons.directions_car_outlined,
                      label: 'Ô tô ($carCount chiếc/tháng)',
                      value: formatCurrency(carTotal),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RateRow extends StatelessWidget {
  const _RateRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.slate500),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.slate500,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.blue950,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ContractSummaryCard extends StatelessWidget {
  const _ContractSummaryCard({required this.contract});

  final ContractEntity contract;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.gray25,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.slate200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'TIỀN CỌC',
                style: TextStyle(
                  color: AppColors.gray500,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                formatCurrency(contract.deposit),
                style: const TextStyle(
                  color: AppColors.blue700,
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
              ),
            ),
            const Divider(height: 24, color: AppColors.slate200),
            _InfoRow(
              icon: Icons.apartment_rounded,
              label: 'Phòng',
              value: contract.roomId,
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Bắt đầu',
              value: contract.startDate.substring(0, 10),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.event_outlined,
              label: 'Kết thúc',
              value: contract.endDate.substring(0, 10),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.payments_outlined,
              label: 'Thuê/tháng',
              value: formatCurrency(contract.monthlyRent),
            ),
            if (contract.terms != null && contract.terms!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.description_outlined,
                label: 'Điều khoản',
                value: contract.terms!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.slate500),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.slate500,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
