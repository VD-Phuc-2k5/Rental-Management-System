import 'dart:async';
import 'dart:developer';
import 'download_button.dart';
import 'payment_countdown.dart';
import 'payment_heading.dart';
import 'payment_qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../../tenant-invoice-payment-screen/api_invoice_payment.dart';

class Body extends StatefulWidget {
  const Body({
    super.key,
    this.invoiceId,
    this.contractId,
    required this.price,
    required this.roomName,
    required this.onSuccess,
    this.qrCodeBase64,
    this.payerName,
  });

  final String? invoiceId;
  /// Contract ID để poll trạng thái ký hợp đồng (deposit payment)
  final String? contractId;
  final int price;
  final String roomName;
  final VoidCallback onSuccess;
  /// PayOS QR payload — truyền xuống PaymentQr render QrImageView
  final String? qrCodeBase64;
  /// Tên người thanh toán (nếu có)
  final String? payerName;

  /// Thời gian QR hết hạn (giây) — không còn auto chuyển trang theo thời gian.
  static const int qrExpireAfterSeconds = 15 * 60;

  /// Chu kỳ polling server để check trạng thái thanh toán (giây)
  static const int pollIntervalSeconds = 2;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Timer? _pollTimer;
  late final DateTime _expiresAt;
  bool _navigated = false;
  bool _devLoading = false;

  bool _isUuid(String value) {
    final v = value.trim();
    final uuid = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return uuid.hasMatch(v);
  }

  void _navigateSuccessOnce() {
    if (_navigated) return;
    _navigated = true;
    widget.onSuccess();
  }

  void _startPollingPaymentStatus() {
    final invoiceId = widget.invoiceId?.trim() ?? '';
    final contractId = widget.contractId?.trim() ?? '';

    log('[Polling] invoiceId: $invoiceId, contractId: $contractId');

    if (invoiceId.isEmpty && contractId.isEmpty) {
      log('[Polling] No ID to poll — skipping');
      return;
    }

    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: Body.pollIntervalSeconds),
      (_) async {
        if (!mounted || _navigated) return;
        if (DateTime.now().isAfter(_expiresAt)) return;

        final token = context.read<AuthenticationBloc>().state.user?.token ?? '';
        if (token.isEmpty) {
          log('[Polling] Token empty — skipping');
          return;
        }

        try {
          bool done = false;
          if (invoiceId.isNotEmpty && _isUuid(invoiceId)) {
            done = await isInvoicePaid(token: token, invoiceId: invoiceId);
            log('[Polling] Invoice paid: $done');
          } else if (contractId.isNotEmpty && _isUuid(contractId)) {
            done = await isContractSigned(token: token, contractId: contractId);
            log('[Polling] Contract signed: $done');
          }
          if (!mounted) return;
          if (done) {
            log('[Polling] Done — navigating to success');
            _pollTimer?.cancel();
            _navigateSuccessOnce();
          }
        } catch (e) {
          log('[Polling] Error: $e');
        }
      },
    );
  }

  Future<void> _devConfirmPayment() async {
    final contractId = widget.contractId?.trim() ?? '';
    if (contractId.isEmpty) return;

    setState(() => _devLoading = true);
    try {
      final token =
          context.read<AuthenticationBloc>().state.user?.token ?? '';
      await devConfirmPayment(token: token, contractId: contractId);
      log('[Dev] Confirm payment sent — polling will detect signed contract');
    } catch (e) {
      log('[Dev] Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _devLoading = false);
    }
  }

  Future<void> _devConfirmInvoicePayment() async {
    final invoiceId = widget.invoiceId?.trim() ?? '';
    if (invoiceId.isEmpty) return;

    setState(() => _devLoading = true);
    try {
      final token =
          context.read<AuthenticationBloc>().state.user?.token ?? '';
      await devConfirmInvoicePayment(token: token, invoiceId: invoiceId);
      log('[Dev] Confirm invoice payment sent — polling will detect paid invoice');
    } catch (e) {
      log('[Dev] Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _devLoading = false);
    }
  }

  void _onExpired() {
    _pollTimer?.cancel();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("QR đã hết hạn")));
  }

  @override
  void initState() {
    super.initState();
    _expiresAt = DateTime.now().add(
      const Duration(seconds: Body.qrExpireAfterSeconds),
    );
    _startPollingPaymentStatus();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 24,
              children: [
                PaymentHeading(
                  price: widget.price,
                  roomName: widget.roomName,
                  payerName: widget.payerName,
                ),
                PaymentQr(price: widget.price, roomName: widget.roomName, qrCodeBase64: widget.qrCodeBase64),
                PaymentCountdown(expiresAt: _expiresAt, onExpired: _onExpired),
                const DownloadButton(),
                if (widget.contractId != null && widget.contractId!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _devLoading ? null : _devConfirmPayment,
                        icon: _devLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.developer_mode, size: 20),
                        label: Text(
                          _devLoading ? 'Đang xử lý...' : 'Xác nhận đã thanh toán (Dev)',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                if (widget.invoiceId != null && widget.invoiceId!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _devLoading ? null : _devConfirmInvoicePayment,
                        icon: _devLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.developer_mode, size: 20),
                        label: Text(
                          _devLoading ? 'Đang xử lý...' : 'Xác nhận đã thanh toán hóa đơn (Dev)',
                          style: const TextStyle(fontWeight: FontWeight.w600),
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
