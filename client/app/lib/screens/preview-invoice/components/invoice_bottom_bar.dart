import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';

class InvoiceBottomBar extends StatelessWidget {
  final int selectedCount;
  final int totalAmount;
  final VoidCallback? onSend;
  final bool isLoading;

  const InvoiceBottomBar({
    super.key,
    required this.selectedCount,
    required this.totalAmount,
    this.onSend,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.slate200)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Summary row ─────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$selectedCount phòng được chọn',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.slate600,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Tổng thanh toán',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.slate500,
                    ),
                  ),
                  Text(
                    formatVND(totalAmount),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: (selectedCount == 0 || isLoading) ? null : onSend,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue700,
                disabledBackgroundColor: AppColors.blue300,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              icon:
                  isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.white,
                        ),
                      )
                      : const Icon(Icons.send_outlined, size: 18),
              label:
                  isLoading
                      ? const SizedBox.shrink()
                      : const Text(
                        'Gửi hóa đơn',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
