import 'package:flutter/services.dart';

class VibrateUtil {
  void vibrate() async {
    HapticFeedback.lightImpact();
  }
}
