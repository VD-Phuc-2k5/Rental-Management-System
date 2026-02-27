import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final double appbarBorderWidth;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.appbarBorderWidth = 1.0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.blue950),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.blue950,
          fontFamily: "Inter",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: showBack,
      iconTheme: const IconThemeData(color: AppColors.blue950),
      actions: const [
        SizedBox(width: 48), // bằng kích thước leading
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(appbarBorderWidth),
        child: Container(height: appbarBorderWidth, color: AppColors.slate100),
      ),
      elevation: 0,
    );
  }
}
