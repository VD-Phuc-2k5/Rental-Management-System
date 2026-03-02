import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
class ContractStatusTopCard extends StatelessWidget {
  final String tenantName;
  final String sentTime;
  
  const ContractStatusTopCard({
    super.key,
    required this.tenantName,
    required this.sentTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
        child: Column(
          children: [
            const _HourglassIcon(),
            const SizedBox(height: 14),
            const Text(
              'Đang chờ khách thuê ký',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A202C),
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF647487),
                  height: 1.25,
                  fontSize: 14,
                ),
                children: [
                  const TextSpan(text: 'Hợp đồng mới đã được gửi đến ',style: TextStyle(fontWeight: FontWeight.w600,color: AppColors.slate500)),
                  TextSpan(
                    text: tenantName,
                    style: const TextStyle(
                      color: Color(0xFF1A202C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: '\nA lúc $sentTime.',style: TextStyle(fontWeight: FontWeight.w600,color: AppColors.slate500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HourglassIcon extends StatelessWidget {
  const _HourglassIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.orange50,
      ),
      child: const Icon(
        Icons.hourglass_empty_rounded,
        size: 34,
        color: AppColors.orange500,
      ),
    );
  }
}