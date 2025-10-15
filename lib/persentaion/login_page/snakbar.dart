import 'package:flutter/material.dart';

/// 🟢🔴 دالة عامة لإظهار SnackBar
void showAppSnackBar(
    BuildContext context, {
      required String message,
      bool isSuccess = true,
    }) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}
