import 'package:flutter/material.dart';

class MoneyOverviewData {
  final String title;
  final String total;
  final String pending;
  final String overdue;
  final Color color;
  final String buttonText;
  final VoidCallback? onPressed;

  const MoneyOverviewData({
    required this.title,
    required this.total,
    required this.pending,
    required this.overdue,
    required this.color,
    required this.buttonText,
    this.onPressed,
  });
}