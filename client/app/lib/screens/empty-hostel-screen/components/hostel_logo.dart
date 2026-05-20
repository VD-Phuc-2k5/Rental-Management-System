import 'dart:ui';

import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class HostelLogo extends StatelessWidget {
  const HostelLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256,
      height: 256,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 32.0, sigmaY: 32.0),
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                color: AppColors.blue700.withAlpha(13),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: 162.35,
            height: 153.5,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: AppColors.slate100),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue700.withAlpha(26),
                  blurRadius: 25,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.apartment,
                size: 96.0,
                color: AppColors.blue700,
              ),
            ),
          ),
          Positioned(
            bottom: 45,
            right: 40,
            child: Container(
              width: 51,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.blue700,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 4.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withAlpha(26),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.add_home, size: 20, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
