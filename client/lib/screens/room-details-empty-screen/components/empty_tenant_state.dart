import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class EmptyTenantState extends StatelessWidget {
  const EmptyTenantState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: const BoxDecoration(
                  color: AppColors.slate50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_off_outlined,
                  size: 52,
                  color: AppColors.slate300,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.slate200,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gray25, width: 4),
                  ),
                  child: const Center(
                    child: Text(
                      "?",
                      style: TextStyle(
                        color: AppColors.slate500,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Phòng hiện chưa có khách thuê",
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Bạn có thể đăng ký khách mới hoặc cập nhật thông tin phòng để thu hút người thuê.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.slate500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
