import 'package:app/screens/forgot-password-screen/components/forgot-password/forgot_password_logo.dart';
import 'package:app/screens/forgot-password-screen/components/forgot-password/instruction_text.dart';
import 'package:app/screens/forgot-password-screen/components/forgot-password/phone_email_input.dart';
import 'package:app/screens/forgot-password-screen/components/forgot-password/send_otp_button.dart';
import 'package:app/screens/forgot-password-screen/input_otp_screen.dart';
import 'package:flutter/material.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final TextEditingController _contactController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  void _handleSendOtp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OPT đã được gửi! Vui lòng kiểm tra email hoặc số điện thoại của bạn.'),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputOtpScreen(contact: _contactController.text),
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
                PhoneEmailInput(controller: _contactController),
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