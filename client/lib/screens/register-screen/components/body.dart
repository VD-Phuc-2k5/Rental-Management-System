import 'package:app/core/constants.dart';
import 'package:app/screens/register-screen/components/register_form.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/register-screen/components/register_logo.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    children: [
                      const RegisterLogo(),
                      const SizedBox(height: 8),
                      Text(
                        'Chào mừng đến với NhàTrọ+',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: const RegisterForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}