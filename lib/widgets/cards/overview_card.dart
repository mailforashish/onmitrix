import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  final String? title;  // Optional title
  final String amount;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? buttonText;  // Optional button text
  final VoidCallback? onButtonPressed;
  final bool showButton;  // New parameter to control button visibility

  const OverviewCard({
    Key? key,
    this.title,  // Made optional
    required this.amount,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.buttonText,  // Made optional
    this.onButtonPressed,
    this.showButton = true,  // Default to true for backward compatibility
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              // Only show button if showButton is true and we have button text
              if (showButton && buttonText != null && buttonText!.isNotEmpty)
                TextButton(
                  onPressed: onButtonPressed,
                  style: TextButton.styleFrom(
                    backgroundColor: color.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    buttonText!,
                    style: TextStyle(color: color),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Only show title if we have one
          if (title != null && title!.isNotEmpty) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            amount,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}