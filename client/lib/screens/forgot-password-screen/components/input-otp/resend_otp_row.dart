import 'dart:async';

import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ResendOtpRow extends StatefulWidget {
  final int countdownSeconds;
  final VoidCallback onResend;

  const ResendOtpRow({
    super.key,
    this.countdownSeconds = 90,
    required this.onResend,
  });

  @override
  State<ResendOtpRow> createState() => _ResendOtpRowState();
}

class _ResendOtpRowState extends State<ResendOtpRow> {
  late int _secondsRemaining;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.countdownSeconds;
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _canResend = false;
      _secondsRemaining = widget.countdownSeconds;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleResend() {
    widget.onResend();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timer_outlined,
              size: 18,
              color: AppColors.slate500,
            ),
            Text(
              ' ${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.slate500,
                fontWeight: FontWeight.w500,
                fontFamily: 'Noto Sans',
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Chưa nhận được mã? ',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.slate500,
                fontFamily: 'Noto Sans',
              ),
            ),
            if (_canResend)
              GestureDetector(
                onTap: _handleResend,
                child: const Text(
                  'Gửi lại',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blue700,
                    fontFamily: 'Noto Sans',
                    decorationColor: AppColors.blue700,
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}
