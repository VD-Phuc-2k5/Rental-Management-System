import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ContractExpiryHeader extends StatelessWidget {
  final String roomNumber;
  final DateTime expiryDate;

  const ContractExpiryHeader({
    super.key,
    required this.roomNumber,
    required this.expiryDate,
  });

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      width: double.infinity,
      child: Stack(
        children: [
          // Center circle
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.blue50,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withAlpha(13),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.calendar_month,
                size: 56,
                color: AppColors.blue700,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 96),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withAlpha(26),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: -2,
                      ),
                      BoxShadow(
                        color: AppColors.black.withAlpha(26),
                        offset: const Offset(0, 4),
                        blurRadius: 6,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.warning_amber,
                    color: AppColors.amber500,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildIcon(),
        Column(
          spacing: 4.0,
          children: [
            const Text(
              "Hợp đồng sắp hết hạn!",
              style: TextStyle(
                color: AppColors.blue950,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: -0.6,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Hợp đồng phòng $roomNumber sẽ hết hạn vào ",
                    style: const TextStyle(
                      color: AppColors.slate500,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: _formatDate(expiryDate),
                    style: const TextStyle(
                      color: AppColors.blue950,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
