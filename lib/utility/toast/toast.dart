import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static void showSuccessAndNavigate({
    required BuildContext context,
    required String message,
    required Widget destination,
  }) {
    // Show toast
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.85),
      textColor: Colors.white,
      fontSize: 14,
    );

    // Small delay so toast is visible
    Future.delayed(const Duration(milliseconds: 400), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => destination),
        (route) => false,
      );
    });
  }
}
