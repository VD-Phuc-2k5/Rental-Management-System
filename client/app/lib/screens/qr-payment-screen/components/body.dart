import 'dart:async';
import 'package:app/screens/qr-payment-screen/components/download_button.dart';
import 'package:app/screens/qr-payment-screen/components/payment_countdown.dart';
import 'package:app/screens/qr-payment-screen/components/payment_heading.dart';
import 'package:app/screens/qr-payment-screen/components/payment_qr.dart';
import 'package:flutter/material.dart';

enum PaymentStatus { pending, success, failed }

class Body extends StatefulWidget {
  const Body({
    super.key,
    required this.price,
    required this.roomName,
    required this.onSuccess,
  });

  final int price;
  final String roomName;
  final VoidCallback onSuccess;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Timer? _pollingTimer;
  bool _paymentSuccess = false;
  late final DateTime _expiresAt;

  Future<PaymentStatus> checkPayment(String roomName) async {
    await Future.delayed(const Duration(milliseconds: 12000));
    return PaymentStatus.success;
  }

  void _startPaymentPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_paymentSuccess) return;

      final status = await checkPayment(widget.roomName);

      if (!mounted) return;

      if (status == PaymentStatus.success) {
        _paymentSuccess = true;
        timer.cancel();
        widget.onSuccess();
      }
    });
  }

  void _onExpired() {
    _pollingTimer?.cancel();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("QR đã hết hạn")));
  }

  @override
  void initState() {
    super.initState();
    _expiresAt = DateTime.now().add(const Duration(minutes: 1));
    _startPaymentPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      children: [
        PaymentHeading(price: widget.price, roomName: widget.roomName),
        const PaymentQr(),
        PaymentCountdown(expiresAt: _expiresAt, onExpired: _onExpired),
        const DownloadButton(),
      ],
    );
  }
}
