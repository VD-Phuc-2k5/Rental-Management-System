import 'package:flutter/material.dart';
import 'copy_pill_button.dart';
import '../../../core/constants.dart';
import '../../../core/format_currency.dart';
class BankTransferCard extends StatelessWidget {
  const BankTransferCard({
    super.key,
    this.bankName,
    this.accountName,
    this.accountNumber,
    this.amount,
    this.transferContent,
  });
  final String? bankName;
  final String? accountName;
  final String? accountNumber;
  final double? amount;
  final String? transferContent;

  @override
  Widget build(BuildContext context) {
    final displayAmount = amount == null ? '' : formatVND(amount!.round());
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children:  [
          _BankRow(bankName: bankName),
          const Divider(height: 1,color: AppColors.slate100),
          _TextRow(
            label: 'Chủ tài khoản',
            value: accountName ?? 'lỗi',
          ),
          const Divider(height: 1,color: AppColors.slate100),
          _CopyRow(
            label: 'Số tài khoản',
            value: accountNumber ?? 'lỗi',
          ),
          const Divider(height: 1,color: AppColors.slate100),
          _CopyRow(
            label: 'Số tiền',
            value: displayAmount,
            valueColor: AppColors.blue700,
          ),
          const Divider(height: 1,color: AppColors.slate100),
          _CopyRow(
            label: 'Nội dung chuyển khoản',
            value: transferContent ?? 'lỗi',
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _BankRow extends StatelessWidget {
  const _BankRow(
    {
      required this.bankName,
    }
  );
  final String? bankName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
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
                const Text(
                  'Ngân hàng',
                  style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 3),
                Text(
                  bankName ?? 'lỗi',
                  style: const TextStyle(color: AppColors.blue950, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TextRow extends StatelessWidget {

  const _TextRow({
    required this.label,
    required this.value,
  });
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w400,fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(color: AppColors.blue950, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyRow extends StatelessWidget {

  const _CopyRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.highlight = false,
  });
  final String label;
  final String value;
  final Color? valueColor;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: highlight ? AppColors.yellow50 : AppColors.white,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w400,fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? AppColors.blue950,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          CopyPillButton(textToCopy: value),
        ],
      ),
    );
  }
}