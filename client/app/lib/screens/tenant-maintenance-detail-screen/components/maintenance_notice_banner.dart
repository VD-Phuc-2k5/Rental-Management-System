import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class MaintenanceNoticeBanner extends StatelessWidget {
  const MaintenanceNoticeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.yellow50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.amber100,width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline_rounded, color: AppColors.yellow600),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sự cố đã được sửa. Vui lòng kiểm tra và xác\nnhận kết quả bên dưới.',
              style: TextStyle(
                color: AppColors.yellow800,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}