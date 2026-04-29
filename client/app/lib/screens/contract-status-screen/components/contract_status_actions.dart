import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class ContractStatusActions extends StatelessWidget {
  const ContractStatusActions({super.key});

 @override
Widget build(BuildContext context) {
  return Container(
    color: AppColors.white,
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 52,
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded,
                  color: AppColors.blue700),
              label: const Text(
                'Nhắc khách ký',
                style: TextStyle(
                  color: AppColors.blue700,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.blue700, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: 18),

          SizedBox(
            height: 52,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide.none,
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Hủy yêu cầu này',
                style: TextStyle(
                  color: AppColors.red500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}