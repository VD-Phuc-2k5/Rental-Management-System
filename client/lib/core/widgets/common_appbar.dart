import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class CommonAppBarBadge {
  final String text;
  final Color textColor;
  final Color backgroundColor;

  CommonAppBarBadge({
    required this.text,
    this.textColor = AppColors.blue700,
    this.backgroundColor = AppColors.blue100,
  });
}

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final double appbarBorderWidth;
  final CommonAppBarBadge? badge;

  static const double _badgeRowHeight = 24.0;
  static const double _badgeBottomMargin = 8.0;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.appbarBorderWidth = 1.0,
    this.badge,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight +
        (badge != null ? _badgeRowHeight + _badgeBottomMargin : 0) +
        appbarBorderWidth,
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      leading: showBack
          ? IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back, color: AppColors.blue950),
            )
          : null,
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
      actions:
          actions ??
          const [
            SizedBox(width: 48), // bằng kích thước leading
          ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(
          badge != null
              ? _badgeRowHeight + _badgeBottomMargin + appbarBorderWidth
              : appbarBorderWidth,
        ),
        child: Column(
          children: [
            if (badge != null)
              SizedBox(
                height: _badgeRowHeight,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badge!.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge!.text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: badge!.textColor,
                        fontSize: 12,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            if (badge != null) const SizedBox(height: _badgeBottomMargin),
            Container(height: appbarBorderWidth, color: AppColors.slate100),
          ],
        ),
      ),
      elevation: 0,
    );
  }
}
