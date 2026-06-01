import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';
import 'package:flutter/material.dart';

import 'components/amenities_section.dart';
import 'components/basic_info_section.dart';
import 'components/description_section.dart';
import 'components/image_upload_section.dart';
import 'components/location_section.dart';
import 'components/update_post_bottom_bar.dart';

class UpdatePostScreen extends StatelessWidget {
  const UpdatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: CommonAppBar(title: "Cập nhật bài đăng"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageUploadSection(),
            SizedBox(height: 24),
            BasicInfoSection(),
            SizedBox(height: 24),
            LocationSection(),
            SizedBox(height: 24),
            AmenitiesSection(),
            SizedBox(height: 24),
            DescriptionSection(),
            SizedBox(height: 32),
            UpdatePostBottomBar(),
          ],
        ),
      ),
    );
  }
}
