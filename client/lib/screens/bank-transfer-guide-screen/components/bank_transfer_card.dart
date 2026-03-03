import 'package:flutter/material.dart';
import 'package:app/screens/bank-transfer-guide-screen/components/copy_pill_button.dart';
import 'package:app/core/constants.dart';
class BankTransferCard extends StatelessWidget {
  const BankTransferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: const [
          _BankRow(),
          Divider(height: 1,color: AppColors.slate100,),
          _TextRow(
            label: 'Chủ tài khoản',
            value: 'CONG TY CONG NGHE NHATRO PLUS',
          ),
          Divider(height: 1,color: AppColors.slate100),
          _CopyRow(
            label: 'Số tài khoản',
            value: '1234567890',
          ),
          Divider(height: 1,color: AppColors.slate100),
          _CopyRow(
            label: 'Số tiền',
            value: '5.000.000đ',
            valueColor: AppColors.blue700,
          ),
          Divider(height: 1,color: AppColors.slate100),
          _CopyRow(
            label: 'Nội dung chuyển khoản',
            value: 'NTPLUS 301A 0912345678',
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _BankRow extends StatelessWidget {
  const _BankRow();

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
              color: AppColors.blue700.withOpacity(0.1),
            ),
            child: const Icon(Icons.account_balance_rounded, color: AppColors.blue700),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ngân hàng',
                  style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 3),
                Text(
                  'Vietcombank (VCB)',
                  style: TextStyle(color: AppColors.blue950, fontWeight: FontWeight.w600),
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
  final String label;
  final String value;

  const _TextRow({
    required this.label,
    required this.value,
  });

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
  final String label;
  final String value;
  final Color? valueColor;
  final bool highlight;

  const _CopyRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.highlight = false,
  });

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
          const CopyPillButton(),
        ],
      ),
    );
  }
}