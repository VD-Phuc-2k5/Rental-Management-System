import 'package:app/core/constants.dart';
import 'package:app/screens/main-tab-screen/main_tab_screen.dart';
import 'package:app/screens/update-hostel-screen/update_hostel_screen.dart';
import 'package:flutter/material.dart';

class HostelCard extends StatelessWidget {
  final String title;
  final String statusText;
  final int blueBlocks;
  final int orangeBlocks;
  final int greyBlocks;

  const HostelCard({
    super.key,
    required this.title,
    required this.statusText,
    this.blueBlocks = 0,
    this.orangeBlocks = 0,
    this.greyBlocks = 0,
  });

  Widget _buildUpdateButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UpdateHostelScreen()),
        );
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.blue700),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Cập nhật",
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: AppColors.blue700,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.edit_square, size: 12, color: AppColors.blue700),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomBlocks() {
    if (blueBlocks == 0 && orangeBlocks == 0 && greyBlocks == 0) {
      return const SizedBox.shrink();
    }

    List<Widget> blocks = [];
    Widget buildBlock(Color color) => Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3.0),
      ),
    );

    for (int i = 0; i < blueBlocks; i++) {
      blocks.add(buildBlock(AppColors.blue700));
    }
    for (int i = 0; i < orangeBlocks; i++) {
      blocks.add(buildBlock(AppColors.amber500));
    }
    for (int i = 0; i < greyBlocks; i++) {
      blocks.add(buildBlock(AppColors.slate300));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Wrap(spacing: 6.0, runSpacing: 6.0, children: blocks),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        MainTabScreen.of(context)?.switchTab(1);
      },
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.slate200),
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withAlpha(13),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.slate900,
              ),
            ),
            _buildRoomBlocks(),
            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                final boxWidth = constraints.constrainWidth();
                const dashWidth = 4.0;
                final dashCount = (boxWidth / (2 * dashWidth)).floor();
                return Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dashCount, (_) {
                    return const SizedBox(
                      width: dashWidth,
                      height: 1.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: AppColors.slate100),
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  statusText,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.slate500,
                  ),
                ),
                _buildUpdateButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
