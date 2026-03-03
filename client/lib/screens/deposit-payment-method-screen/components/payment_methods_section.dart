import 'package:flutter/material.dart';
import 'payment_method_tile.dart';

class PaymentMethodsSection extends StatelessWidget {
  const PaymentMethodsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Chọn phương thức thanh toán',
          style: TextStyle(
            color: Color(0xFF1A202C),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),

        PaymentMethodTile(
          title: 'Ví điện tử MoMo',
          subtitle: 'Miễn phí giao dịch',
          icon: Icons.account_balance_wallet_outlined,
          selected: false,
        ),
        SizedBox(height: 12),

        PaymentMethodTile(
          title: 'Cổng thanh toán VNPay',
          subtitle: 'Thẻ ATM, QR Code',
          icon: Icons.qr_code_2_rounded,
          selected: false,
        ),
        SizedBox(height: 12),

        PaymentMethodTile(
          title: 'Chuyển khoản ngân hàng',
          subtitle: 'Ngân hàng',
          icon: Icons.account_balance_rounded,
          selected: true, // giống ảnh
        ),
      ],
    );
  }
}