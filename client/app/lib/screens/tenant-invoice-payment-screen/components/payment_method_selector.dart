import '../../../core/constants.dart';
import 'payment_method_option.dart';
import 'payment_models.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {

  const PaymentMethodSelector({
    super.key,
    required this.paymentMethods,
    this.onMethodSelected,
  });
  final List<PaymentMethodOption> paymentMethods;
  final ValueChanged<PaymentMethodType>? onMethodSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        const Text(
          "Chọn phương thức thanh toán",
          style: TextStyle(
            color: AppColors.blue950,
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        ...paymentMethods.map(
          (option) => PaymentMethodOptionWidget(
            option: option,
            onTap: () => onMethodSelected?.call(option.type),
          ),
        ),
      ],
    );
  }
}
