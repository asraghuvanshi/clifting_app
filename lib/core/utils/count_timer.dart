// utils/countdown_timer.dart
import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer {
  final ValueNotifier<int> remainingSeconds;
  Timer? _timer;

  CountdownTimer({int initialSeconds = 30}) 
      : remainingSeconds = ValueNotifier(initialSeconds) {
    _start();
  }

  bool get isActive => _timer?.isActive ?? false;
  int get seconds => remainingSeconds.value;

  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void reset({int? newSeconds}) {
    _timer?.cancel();
    remainingSeconds.value = newSeconds ?? 30;
    _start();
  }

  void stop() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
    remainingSeconds.dispose();
  }
}