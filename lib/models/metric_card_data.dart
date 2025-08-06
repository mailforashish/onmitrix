import 'package:flutter/material.dart';

class MetricCardData {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;
  final String buttonText;
  final bool isButton;
  final VoidCallback? onPressed;

  const MetricCardData({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    required this.buttonText,
    this.isButton = true,
    this.onPressed,
  });
}