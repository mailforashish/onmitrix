import 'package:flutter/material.dart';

class ViewSelectorButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? iconSize;
  final double? fontSize;

  const ViewSelectorButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.selectedColor = const Color(0xFF2B4380),
    this.unselectedColor,
    this.iconSize = 18,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unselectedTextColor = unselectedColor ?? Colors.grey[600];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: isSelected ? Colors.white : unselectedTextColor,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : unselectedTextColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}