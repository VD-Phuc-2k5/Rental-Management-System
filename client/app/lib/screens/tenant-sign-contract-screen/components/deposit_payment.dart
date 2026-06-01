import 'package:domain/rental_request.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/di/di.dart';
import '../../../core/format_currency.dart';
import 'package:core/usecase.dart';
import '../../../features/rental_request/presentation/pages/deposit_payment_sheet.dart';
class DepositPaymentCard extends StatelessWidget {
  const DepositPaymentCard({super.key});

  Future<void> _openDepositPayment(BuildContext context) async {
    final result =
        await getIt<GetMyContractsUsecase>().call(const NoParams());
    if (!context.mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.toString())),
        );
      },
      (contracts) {
        final sent =
            contracts.where((c) => c.status == ContractStatus.sent).toList();
        if (sent.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không có hợp đồng cần thanh toán.')),
          );
          return;
        }
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => DepositPaymentSheet(contract: sent.first),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int depositAmount = 5000000;
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.orange100,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'CHƯA THANH TOÁN',
                style: TextStyle(
                  color: AppColors.red700,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Số tiền cọc cần đóng:',
                  style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w500,fontSize: 16),
                ),
                const Spacer(),
                Text(
                  formatVND(depositAmount),
                  style: const TextStyle(
                    color: AppColors.blue700,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openDepositPayment(context),
                icon: const Icon(Icons.credit_card, color: AppColors.white),
                label: const Text(
                  'Thanh toán tiền cọc ngay',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue700,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Khoản tiền này sẽ được giữ an toàn và hoàn lại khi kết\nthúc hợp đồng theo điều khoản.',
              style: TextStyle(color: AppColors.slate400, height: 1.25,
                fontSize: 12,
                fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}