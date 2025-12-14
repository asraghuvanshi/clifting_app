import 'package:flutter/material.dart';
import 'package:clifting_app/core/exceptions/api_exceptions.dart';

class ErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    if (error is UnauthorizedException) {
      // Redirect to login screen
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      _showToast(context, error.message);
    } else if (error is NetworkException || error is TimeoutException) {
      // Show custom offline UI
      _showOfflineDialog(context);
    } else if (error is ApiException) {
      // Show toast for other API errors
      _showToast(context, error.message);
    } else {
      // Generic error
      _showToast(context, 'Something went wrong. Please try again.');
    }
  }
  
  static void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  static void _showOfflineDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.orange),
            SizedBox(width: 10),
            Text('No Internet Connection'),
          ],
        ),
        content: const Text(
          'Please check your internet connection and try again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}