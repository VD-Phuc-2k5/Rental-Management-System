import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class BackToHomeButton extends StatelessWidget {
  const BackToHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                elevation: 0,
                side: BorderSide(
                  color: AppColors.blue700.withAlpha(51),
                  width: 2,
                ),
              ),
              onPressed: () {
                // TO DO: handle to navigate to home page
              },
              child: const Text(
                "Về trang chủ",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
