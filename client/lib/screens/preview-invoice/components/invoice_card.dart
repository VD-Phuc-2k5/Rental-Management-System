import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
import 'package:app/core/models/invoice_preview.dart';

class InvoiceCard extends StatelessWidget {
  final InvoicePreview invoice;
  final bool isSelected;
  final ValueChanged<bool> onToggleSelect;
  final VoidCallback? onEdit;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.isSelected,
    required this.onToggleSelect,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.slate200.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => onToggleSelect(!isSelected),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.blue700 : AppColors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.blue700 : AppColors.slate400,
                        width: 1.5,
                      ),
                    ),
                    child:
                        isSelected
                            ? const Icon(
                              Icons.check,
                              color: AppColors.white,
                              size: 14,
                            )
                            : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.hostelName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.blue700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Phòng ${invoice.roomNumber}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue950,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.blue500,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _feeItem(
                      'Tiền phòng',
                      _formatShort(invoice.rentFee),
                    ),
                    const SizedBox(width: 12),
                    _feeItem(
                      'Điện (${invoice.electricKwh} số)',
                      _formatShort(invoice.electricFee),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _feeItem(
                      'Nước (${invoice.waterM3}m3)',
                      _formatShort(invoice.waterFee),
                    ),
                    const SizedBox(width: 12),
                    _feeItem(
                      'Dịch vụ',
                      _formatShort(invoice.serviceFee),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.slate100),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng cộng',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.slate500,
                  ),
                ),
                Text(
                  formatVND(invoice.total),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feeItem(String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: AppColors.slate600,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.slate600,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatShort(int value) {
    if (value >= 1000) {
      final k = value / 1000;
      final isWhole = k == k.truncateToDouble();
      return '${isWhole ? k.toInt() : k.toStringAsFixed(1)}k';
    }
    return value.toString();
  }
}
