import 'package:app/screens/payment-success-screen/components/heading_icon.dart';
import 'package:app/screens/payment-success-screen/components/heading_title.dart';
import 'package:app/screens/payment-success-screen/components/back_to_home_button.dart';
import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/core/fomat_currency.dart';

class Body extends StatelessWidget {
  final int price;
  final TextStyle paymentLabelStyle = const TextStyle(
    color: AppColors.slate500,
    fontFamily: "Inter",
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );
  final TextStyle paymentInfoStyle = const TextStyle(
    color: AppColors.blue950,
    fontFamily: "Inter",
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );
  const Body({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const HeadingIcon(),
                const HeadingTitle(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.only(top: 24.0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(width: 1.0, color: AppColors.slate100),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: AppColors.black.withAlpha(13),
                      ),
                    ],
                  ),
                  child: Column(
                    spacing: 40.0,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Số tiền", style: paymentLabelStyle),
                          Text(
                            formatVND(price),
                            style: const TextStyle(
                              color: AppColors.blue700,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Phương thức", style: paymentLabelStyle),
                          Text("VNPay", style: paymentInfoStyle),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Thời gian", style: paymentLabelStyle),
                          Text("01/03/2026 08:30", style: paymentInfoStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [const BackToHomeButton()],
          ),
        ],
      ),
    );
  }
}
