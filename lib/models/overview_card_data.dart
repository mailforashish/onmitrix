import 'package:flutter/material.dart';

class OverviewCardData {
  final String title;
  final String amount;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const OverviewCardData({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.buttonText = '',
    this.onButtonPressed,
  });
}