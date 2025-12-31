import 'package:flutter/material.dart';

class AppNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static void toLogin({bool clearStack = false}) {
    if (clearStack) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } else {
      navigatorKey.currentState?.pushNamed('/login');
    }
  }
}
