import 'package:app/screens/forgot-password-screen/components/forgot-password/forgot_password_logo.dart';
import 'package:app/screens/forgot-password-screen/components/forgot-password/instruction_text.dart';
import 'package:app/screens/forgot-password-screen/components/forgot-password/phone_email_input.dart';
import 'package:app/screens/forgot-password-screen/components/forgot-password/send_otp_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordBody extends StatelessWidget {
  const ForgotPasswordBody({super.key});

  void _handleSendOtp(BuildContext context) {
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP input screen is not implemented yet.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ForgotPasswordLogo(),
                const SizedBox(height: 32),
                const InstructionText(),
                const SizedBox(height: 32),
                const PhoneEmailInput(),
                const SizedBox(height: 32),
                SendOtpButton(onPressed: () => _handleSendOtp(context)),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}