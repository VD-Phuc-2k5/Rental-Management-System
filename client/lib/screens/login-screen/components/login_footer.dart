import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class LoginFooter extends StatelessWidget {
  final VoidCallback? onSignUpPressed;

  const LoginFooter({
    super.key,
    this.onSignUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Chưa có tài khoản? ",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.gray600,
          ),
        ),
        TextButton(
          onPressed: onSignUpPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Đăng ký ngay",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.blue700,
            ),
          ),
        ),
      ],
    );
  }
}
