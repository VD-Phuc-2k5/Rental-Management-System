import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

import 'basic_info_section.dart';
import 'bottom_action_bar.dart';
import 'images_section.dart';
import 'utilities_section.dart';

class AddHostelBody extends StatelessWidget {
  const AddHostelBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const BasicInfoSection(),
                Container(height: 8, color: AppColors.slate100),
                const UtilitiesSection(),
                Container(height: 8, color: AppColors.slate100),
                const ImagesSection(),
              ],
            ),
          ),
        ),
        const BottomActionBar(),
      ],
    );
  }
}
