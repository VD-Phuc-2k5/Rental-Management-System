import 'package:app/core/constants.dart';
import 'package:app/screens/tenant-invoice-payment-screen/components/payment_models.dart';
import 'package:flutter/material.dart';

class PaymentMethodOptionWidget extends StatelessWidget {
  final PaymentMethodOption option;
  final VoidCallback? onTap;

  const PaymentMethodOptionWidget({
    super.key,
    required this.option,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            width: 2.0,
            color: option.isSelected ? AppColors.blue700 : AppColors.slate200,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(spacing: 16.0, children: [_buildIcon(), _buildContent()]),
            _buildCheckmark(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    switch (option.type) {
      case PaymentMethodType.vnpay:
        iconData = Icons.qr_code;
        break;
      case PaymentMethodType.momo:
        iconData = Icons.account_balance_wallet;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.slate100,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: AppColors.blue700),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          option.name,
          style: const TextStyle(
            color: AppColors.blue950,
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        Text(
          option.description,
          style: const TextStyle(
            color: AppColors.slate500,
            fontFamily: "Inter",
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckmark() {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: option.isSelected ? AppColors.blue700 : AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(
          width: 2.0,
          color: option.isSelected ? AppColors.blue700 : AppColors.slate300,
        ),
      ),
      child: Icon(Icons.check, size: 14.0, color: AppColors.white),
    );
  }
}
