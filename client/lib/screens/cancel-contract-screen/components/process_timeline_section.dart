import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ProcessTimelineSection extends StatelessWidget {
  const ProcessTimelineSection({super.key});

  Widget _buildTimelineStep({
    required String stepNumber,
    required String title,
    required String description,
    bool isActive = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.blue700 : const Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 4),
                  boxShadow: isActive
                      ? const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: isActive
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                      )
                    : Text(
                        stepNumber,
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: AppColors.slate500,
                        ),
                      ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: const Color(0xFFE2E8F0)),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 14,
                      color: isActive ? AppColors.blue700 : AppColors.slate900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.slate500,
                    ),
                  ),
                ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 16.0),
          child: Text(
            "Quy trình xử lý",
            style: TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.slate900,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Column(
            children: [
              _buildTimelineStep(
                stepNumber: "1",
                title: "Gửi yêu cầu",
                description: "Bạn gửi yêu cầu hủy hợp đồng/trả phòng.",
                isActive: true,
              ),
              _buildTimelineStep(
                stepNumber: "2",
                title: "Chủ trọ kiểm tra phòng",
                description: "Xác nhận hiện trạng tài sản.",
              ),
              _buildTimelineStep(
                stepNumber: "3",
                title: "Hoàn cọc (nếu có)",
                description: "Thanh toán các khoản phí và hoàn tiền cọc.",
              ),
              _buildTimelineStep(
                stepNumber: "4",
                title: "Kết thúc hợp đồng",
                description: "Hợp đồng chính thức hết hiệu lực.",
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
