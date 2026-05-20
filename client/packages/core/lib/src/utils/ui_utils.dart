import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

enum ToastType { success, error, info, warning }

void showToast({
  required String message,
  ToastType type = ToastType.info,
}) {
  final config = switch (type) {
    ToastType.success => (color: AppColors.green500),
    ToastType.error => (color: AppColors.red500),
    ToastType.warning => (color: AppColors.amber500),
    ToastType.info => (color: AppColors.blue700),
  };

  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: config.color,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}
