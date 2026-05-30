import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants.dart';
import '../../../core/format_currency.dart';

class PaymentQr extends StatelessWidget {
  const PaymentQr({
    super.key,
    required this.price,
    required this.roomName,
    this.qrCodeBase64,
  });

  final int price;
  final String roomName;
  /// PayOS QR payload (EMVCo string) — được render bằng QrImageView
  final String? qrCodeBase64;

  static const String _fallbackBankName = 'MB Bank';
  static const String _fallbackAccountNumber = '0963368368';
  static const String _fallbackAccountName = 'VO DUC PHUC';

  String get _transferContent {
    final sanitized = roomName.replaceAll(RegExp(r'[^\w\s\-]'), '');
    return 'Thanh toan tien phong $sanitized';
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.slate500,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              color: AppColors.blue950,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVietQr() {
    final cleanRoomName = Uri.encodeComponent(_transferContent);
    final qrUrl = "https://img.vietqr.io/image/mbbank-0963368368-compact2.png?amount=$price&addInfo=$cleanRoomName&accountName=VO%20DUC%20PHUC";
    return Image.network(
      qrUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          "assets/images/qr-payment.png",
          semanticLabel: "Mã QR để thanh toán (Dự phòng)",
        );
      },
    );
  }

  Widget _buildPayosQr() {
    return QrImageView(
      data: qrCodeBase64!,
      version: QrVersions.auto,
      size: 300,
      backgroundColor: Colors.white,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget qrWidget;
    final bool isPayos = qrCodeBase64 != null && qrCodeBase64!.isNotEmpty;
    if (isPayos) {
      qrWidget = _buildPayosQr();
    } else {
      qrWidget = _buildVietQr();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(width: 1.0, color: AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        spacing: 16.0,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: AppColors.blue700.withAlpha(26),
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: SizedBox(
                height: 300,
                child: qrWidget,
              ),
            ),
          ),
          Text(
            isPayos ? "Quét mã để thanh toán (PayOS)" : "Quét mã để thanh toán",
            style: const TextStyle(
              fontFamily: "Inter",
              color: AppColors.blue950,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.slate100),
            ),
            child: Column(
              spacing: 10,
              children: [
                _infoRow('Số tiền', formatVND(price)),
                if (!isPayos) ...[
                  _infoRow('Ngân hàng', _fallbackBankName),
                  _infoRow('Chủ tài khoản', _fallbackAccountName),
                  _infoRow('Số tài khoản', _fallbackAccountNumber),
                  _infoRow('Nội dung', _transferContent),
                ] else ...[
                  _infoRow('Phương thức', 'PayOS'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
