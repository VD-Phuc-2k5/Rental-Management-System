import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
class TransactionSummaryCard extends StatelessWidget {
  final String? bankName;
  final int? amount;
  final String? transferContent;
  const TransactionSummaryCard({
    super.key,
    this.bankName,
    this.amount,
    this.transferContent,
  });

  @override
  Widget build(BuildContext context) {
    final displayAmount = amount == null ? '' : formatVND(amount!);
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.slate100,width: 1)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.blue700.withValues(alpha: 0.1),
                  ),
                  child: const Icon(Icons.account_balance_rounded, color: AppColors.blue700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ngân hàng',
                        style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w400,fontSize: 12),
                      ),
                      SizedBox(height: 3),
                      Text(
                        (bankName == null || bankName!.trim().isEmpty) ? '—' : bankName!,
                        style: TextStyle(color: AppColors.blue950, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1,color: AppColors.slate100),
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 82,
                  child: Text(
                    'Nội dung:',
                    style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w400),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                       (transferContent == null || transferContent!.trim().isEmpty) ? '—' : transferContent!,
                      style: TextStyle(color: AppColors.blue950, fontWeight: FontWeight.w700),
                    ),
                  ),),
              ],
            ),

            const SizedBox(height: 12),

            const Text(
              'Số tiền chuyển khoản',
              style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w500, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              displayAmount,
              style: TextStyle(
                color: AppColors.blue700,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1,color: AppColors.slate100),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}