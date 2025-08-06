import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class QuickAction {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  QuickAction(this.text, this.icon, this.color, [this.onPressed = _defaultAction]);

  static void _defaultAction() {
    debugPrint('Quick Action tapped');
  }
}