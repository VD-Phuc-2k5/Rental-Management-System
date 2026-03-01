import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

import 'update_basic_info_section.dart';
import 'update_bottom_action_bar.dart';
import 'update_images_section.dart';
import 'update_utilities_section.dart';

class UpdateHostelBody extends StatelessWidget {
  const UpdateHostelBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const UpdateBasicInfoSection(),
                Container(height: 8, color: AppColors.slate100),
                const UpdateUtilitiesSection(),
                Container(height: 8, color: AppColors.slate100),
                const UpdateImagesSection(),
              ],
            ),
          ),
        ),
        const UpdateBottomActionBar(),
      ],
    );
  }
}
