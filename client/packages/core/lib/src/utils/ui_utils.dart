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

Future<bool?> showDeleteDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text(
          'Xác nhận',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.red500,
          ),
        ),
        content: const Text('Bạn có chắc chắn muốn xóa không?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text(
              'Hủy',
              style: TextStyle(
                color: AppColors.slate500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red500,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Xóa', style: TextStyle(color: AppColors.white)),
          ),
        ],
      );
    },
  );
}
