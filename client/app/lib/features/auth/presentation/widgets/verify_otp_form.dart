import 'dart:async';

import 'package:core/constants.dart';
import 'package:core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/router/route_constants.dart';
import '../blocs/verify_otp/verify_otp_bloc.dart';

class VerifyOtpForm extends StatefulWidget {
  const VerifyOtpForm({super.key});

  @override
  State<StatefulWidget> createState() => _VerifyOtpFormState();
}

class _VerifyOtpFormState extends State<VerifyOtpForm> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _showError = false;

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  int _countdown = 60;
  Timer? _timer;
  bool _canResend = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _canResend = false;
    _countdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        setState(() => _canResend = true);
        _timer?.cancel();
      }
    });
  }

  void _onOtpChanged(int index, String value) {
    if (_showError) setState(() => _showError = false);
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }
  }

  void _onResend() {
    if (!_canResend) return;
    _isResending = true;
    context.read<VerifyOtpBloc>().add(const ResendOtpRequested());
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    final isValid = form != null && form.validate();

    final otp = _otpControllers
        .map((otpController) => otpController.text)
        .join();

    if (!isValid || otp.length != 6) {
      setState(() => _showError = true);
      return;
    }

    setState(() => _showError = false);
    context.read<VerifyOtpBloc>().add(VerifyOtpRequested(otp: otp));
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final _otpController in _otpControllers) {
      _otpController.dispose();
    }
    for (final _otpFocusNode in _otpFocusNodes) {
      _otpFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpLoadFailure) {
          _isResending = false;
          showToast(message: state.failure.message, type: ToastType.error);
        }
        if (state is VerifyOtpLoadSuccess) {
          showToast(
            message: "Xác thực OTP thành công!",
            type: ToastType.success,
          );

          final email = context.read<VerifyOtpBloc>().email;
          final otp = _otpControllers
              .map((otpController) => otpController.text)
              .join();

          context.goNamed(
            RouteNames.forgotPassword,
            extra: {'step': '3', 'email': email, 'otp': otp},
          );
        }
        if (state is VerifyOtpInitial && _isResending) {
          _isResending = false;
          showToast(
            message: "Mã OTP đã gửi đến email của bạn!",
            type: ToastType.success,
          );
          _startCountdown();
        }
      },
      builder: (context, state) {
        final isLoading = state is VerifyOtpLoadInProgress;
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 32,
              children: [
                // 6 OTP fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 52,
                      height: 56,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate900,
                          fontFamily: 'Nunito',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.slate300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.blue500,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.red500,
                              width: 1.5,
                            ),
                          ),
                          errorStyle: const TextStyle(
                            height: 0,
                            fontSize: 0,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                        onChanged: (value) => _onOtpChanged(index, value),
                        textInputAction: index < 5
                            ? TextInputAction.next
                            : TextInputAction.done,
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nhập mã';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                ),

                // Error message
                if (_showError)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Vui lòng nhập đầy đủ mã OTP',
                      style: TextStyle(
                        color: AppColors.red500,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Noto Sans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Countdown
                const SizedBox(height: 16),
                Center(
                  child: _canResend
                      ? GestureDetector(
                          onTap: isLoading ? null : _onResend,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Text(
                                'Chưa nhận được mã?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.slate500,
                                  fontFamily: 'Noto Sans',
                                ),
                              ),

                              Text(
                                'Gửi lại mã',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blue700,
                                  fontFamily: 'Noto Sans',
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          'Gửi lại mã sau $_countdown giây',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.slate500,
                            fontFamily: 'Noto Sans',
                          ),
                        ),
                ),

                // Submit button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue700,
                      disabledBackgroundColor: AppColors.blue700.withValues(
                        alpha: 0.6,
                      ),
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withValues(alpha: 1),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Text(
                            'Xác nhận',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
