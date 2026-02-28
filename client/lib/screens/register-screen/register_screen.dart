import 'package:app/core/constants.dart';
import 'package:app/screens/register-screen/components/body.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue950),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(right: 56.0),
          child: Center(
            child: Text(
              "Tạo tài khoản",
              style: TextStyle(
                color: AppColors.blue950,
                fontFamily: "Inter",
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: const RegisterBody(),
    );
  }
}