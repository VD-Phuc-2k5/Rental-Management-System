import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class PendingRequestsSection extends StatelessWidget {
  const PendingRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.notifications_active_outlined,
              color: AppColors.blue700,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              "Thông báo cần xử lý",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.blue700,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.blue700.withAlpha(25),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: const Text(
                "1",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.blue700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: const Border(
              left: BorderSide(color: AppColors.blue400, width: 4.0),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(13),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.blue50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.request_page_outlined,
                      color: AppColors.blue400,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Yêu cầu gia hạn",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.blue400,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Khách muốn gia hạn thêm 6 tháng.",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.slate500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Hôm nay, 09:30",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.slate400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 36,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.blue700.withAlpha(25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.flash_on,
                    size: 16,
                    color: AppColors.blue700,
                  ),
                  label: const Text(
                    "Xử lý ngay",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.blue700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
