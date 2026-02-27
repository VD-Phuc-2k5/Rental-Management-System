import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class PaymentCountdown extends StatefulWidget {
  final DateTime expiresAt;
  final VoidCallback? onExpired;

  const PaymentCountdown({super.key, required this.expiresAt, this.onExpired});

  @override
  State<PaymentCountdown> createState() => _PaymentCountdownState();
}

class _PaymentCountdownState extends State<PaymentCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _expiredCalled = false;

  @override
  void initState() {
    super.initState();
    _updateRemaining();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateRemaining(),
    );
  }

  void _updateRemaining() {
    final now = DateTime.now();
    final diff = widget.expiresAt.difference(now);

    if (diff <= Duration.zero) {
      _timer?.cancel();
      _remaining = Duration.zero;

      if (!_expiredCalled) {
        _expiredCalled = true;
        widget.onExpired?.call();
      }
    } else {
      _remaining = diff;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Mã hết hạn sau: ",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.red500,
          ),
        ),
        Text(
          _format(_remaining),
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.red500,
          ),
        ),
      ],
    );
  }
}
