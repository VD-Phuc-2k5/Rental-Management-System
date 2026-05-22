import '../../../core/constants.dart';
import 'package:flutter/material.dart';

class InfoMessage extends StatelessWidget {
  const InfoMessage({
    super.key,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.blue50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: (backgroundColor ?? AppColors.blue50).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.0,
        children: [
          Icon(
            Icons.info_outline,
            color: iconColor ?? AppColors.blue600,
            size: 20,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: textColor ?? AppColors.slate700,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: "Chủ trọ sẽ xem xét yêu cầu và gửi lại ",
                  ),
                  const TextSpan(
                    text: "hợp đồng",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(
                    text: " qua ứng dụng để bạn ký xác nhận online.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
