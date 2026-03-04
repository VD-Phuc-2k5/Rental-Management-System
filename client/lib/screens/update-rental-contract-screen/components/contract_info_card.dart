import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ContractInfoCard extends StatelessWidget {
  final String roomName;
  final String roomImageUrl;
  final String startDate;
  final String endDate;

  const ContractInfoCard({
    super.key,
    required this.roomName,
    required this.roomImageUrl,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(text: "THÔNG TIN HỢP ĐỒNG"),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: AppColors.slate200),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    roomImageUrl,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(color: AppColors.black.withAlpha(100)),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 8,
                    child: Text(
                      roomName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: AppColors.blue700),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thời hạn hợp đồng",
                          style: TextStyle(
                            color: AppColors.slate500,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "$startDate - $endDate",
                          style: const TextStyle(
                            color: AppColors.blue900,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.slate500,
        fontFamily: "Inter",
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 0.6,
      ),
    );
  }
}
