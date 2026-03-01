import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class BlueprintIllustration extends StatelessWidget {
  const BlueprintIllustration({super.key});

  Widget _buildHouseBox() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blue700.withAlpha(128), width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Center(
        child: Icon(Icons.add_home_outlined, color: AppColors.blue700, size: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256,
      height: 256,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 256,
            height: 256,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
          ),

          Container(
            width: 192,
            height: 192,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.blue700, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withAlpha(25),
                  blurRadius: 25,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.blue700,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _buildHouseBox()),
                            const SizedBox(width: 10),
                            Expanded(child: _buildHouseBox()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _buildHouseBox()),
                            const SizedBox(width: 10),
                            Expanded(child: _buildHouseBox()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: -8,
            right:-8,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.blue700,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withAlpha(25),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.search_off, color: AppColors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}