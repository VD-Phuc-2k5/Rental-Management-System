import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class ComplaintNoteBanner extends StatelessWidget {
  const ComplaintNoteBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.red50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.red100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline_rounded, color: AppColors.red500),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Khiếu nại của bạn sẽ được gửi trực tiếp đến\nchủ trọ để xem xét và lên lịch sửa lại.',
              style: TextStyle(
                color: AppColors.red500,
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}