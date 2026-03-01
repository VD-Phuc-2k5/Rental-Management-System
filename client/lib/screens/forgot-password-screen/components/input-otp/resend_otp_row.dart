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
    // Assign directly — no setState during initState
    _startTimer(fromInit: true);
  }

  void _startTimer({bool fromInit = false}) {
    // Cancel before anything else to avoid racey ordering
    _timer?.cancel();
    _secondsRemaining = widget.countdownSeconds;
    _canResend = false;
    // Only trigger a rebuild when called after the first build
    if (!fromInit) setState(() {});
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
            TextButton(
              onPressed: _canResend ? _handleResend : null,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Gửi lại',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _canResend ? AppColors.blue700 : AppColors.slate500,
                  fontFamily: 'Noto Sans',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
