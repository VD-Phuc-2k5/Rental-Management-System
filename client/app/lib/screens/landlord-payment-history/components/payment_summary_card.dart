import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
import 'package:flutter/material.dart';

class PaymentSummaryCard extends StatelessWidget {
  final int totalCollected;
  final int totalUncollected;

  const PaymentSummaryCard({
    super.key,
    required this.totalCollected,
    required this.totalUncollected,
  });

  @override
  Widget build(BuildContext context) {
    final total = totalCollected + totalUncollected;
    final progress = total > 0 ? totalCollected / total : 1.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.blue100, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ĐÃ THU',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.slate500,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatVND(totalCollected),
                  style: const TextStyle(
                    fontSize: 22,
                    color: AppColors.green600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'CHƯA THU',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.slate500,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatVND(totalUncollected),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.slate700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _CircularProgress(progress: progress),
        ],
      ),
    );
  }
}

class _CircularProgress extends StatelessWidget {
  final double progress;

  const _CircularProgress({required this.progress});

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 7,
              backgroundColor: AppColors.blue100,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.blue500),
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            '$percent%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.blue700,
            ),
          ),
        ],
      ),
    );
  }
}
