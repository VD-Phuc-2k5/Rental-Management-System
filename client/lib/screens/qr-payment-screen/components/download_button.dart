import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({super.key});

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
                elevation: 0,
                side: BorderSide(
                  color: AppColors.blue700.withAlpha(51),
                  width: 2,
                ),
              ),
              onPressed: () {
                // TO DO: handle to save QR Image
              },
              child: Row(
                spacing: 4.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.download, color: AppColors.blue700),
                  const Text(
                    "Lưu mã QR",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
