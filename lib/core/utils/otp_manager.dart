// utils/otp_input_manager.dart
import 'package:flutter/material.dart';

class OTPInputManager {
  final int length;
  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;
  final ValueNotifier<int> currentIndexNotifier = ValueNotifier(0);
  final ValueNotifier<bool> allFilledNotifier = ValueNotifier(false);

  OTPInputManager({this.length = 6}) {
    controllers = List.generate(length, (_) => TextEditingController());
    focusNodes = List.generate(length, (_) => FocusNode());
    _setupListeners();
  }

  void _setupListeners() {
    for (int i = 0; i < length; i++) {
      controllers[i].addListener(() => _updateAllFilled());
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus) {
          currentIndexNotifier.value = i;
        }
      });
    }
  }

  void _updateAllFilled() {
    allFilledNotifier.value = controllers.every((c) => c.text.isNotEmpty);
  }

  String get otp => controllers.map((c) => c.text).join();

  bool validate() {
    final otpString = otp;
    return otpString.length == length && RegExp(r'^\d+$').hasMatch(otpString);
  }

  void handleInput(String value, int index) {
    if (value.isNotEmpty && index < length - 1) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void clear() {
    for (var controller in controllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
  }

  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    currentIndexNotifier.dispose();
    allFilledNotifier.dispose();
  }
}