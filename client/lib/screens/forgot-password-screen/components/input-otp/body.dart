import 'package:app/screens/forgot-password-screen/components/input-otp/otp_input_fields.dart';
import 'package:app/screens/forgot-password-screen/components/input-otp/otp_instruction_text.dart';
import 'package:app/screens/forgot-password-screen/components/input-otp/resend_otp_row.dart';
import 'package:app/screens/forgot-password-screen/components/input-otp/verify_otp_button.dart';
import 'package:flutter/material.dart';

class InputOtpBody extends StatefulWidget {
  final String contact;

  const InputOtpBody({super.key, required this.contact});

  @override
  State<InputOtpBody> createState() => _InputOtpBodyState();
}

class _InputOtpBodyState extends State<InputOtpBody> {
  String _otp = '';

  bool get _isOtpComplete => _otp.length == 6;

  void _handleOtpCompleted(String otp) {
    setState(() => _otp = otp);
  }

  void _handleOtpChanged(String otp) {
    setState(() => _otp = otp);
  }

  void _handleVerify() {
    if (!_isOtpComplete) return;
    // TODO: navigate to reset-password screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mã OTP đã được xác nhận!')),
    );
  }

  void _handleResend() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã gửi lại mã OTP!')),
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
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OtpInstructionText(contact: widget.contact),
                        const SizedBox(height: 32),
                        OtpInputFields(
                          onCompleted: _handleOtpCompleted,
                          onChanged: _handleOtpChanged,
                        ),
                        const SizedBox(height: 16),
                        ResendOtpRow(onResend: _handleResend),
                      ],
                    ),
                  ),
                ),
                VerifyOtpButton(
                  onPressed: _isOtpComplete ? _handleVerify : null,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
