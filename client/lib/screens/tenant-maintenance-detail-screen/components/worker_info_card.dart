import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class WorkerInfoCard extends StatelessWidget {
  final String workerName;
  final String scheduledTime;
  const WorkerInfoCard({
    super.key,
    required this.workerName,
    required this.scheduledTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'THÔNG TIN THỢ',
              style: TextStyle(
                color: AppColors.slate500,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const _Avatar(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workerName,
                        style: TextStyle(
                          color: AppColors.blue950,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: AppColors.slate500),
                          SizedBox(width: 6),
                          Text(
                            scheduledTime,
                            style: TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Gọi thợ',
                  child: InkWell(
                    onTap: () {},
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green50,
                      ),
                      child: const Icon(Icons.call, color: AppColors.green600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              //color: Color(0xFFE2E8F0),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/avatar_worker.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF22C55E),
              ),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}