import 'package:flutter/material.dart';

enum PrimaryButtonType {
  primary,
  success,
  danger,
  info,
  warning
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final PrimaryButtonType type;
  final bool fullWidth;
  final double? height;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.type = PrimaryButtonType.primary,
    this.fullWidth = false,
    this.height,
  }) : super(key: key);

  Color _getButtonColor() {
    switch (type) {
      case PrimaryButtonType.success:
        return const Color(0xFF28A745);
      case PrimaryButtonType.danger:
        return const Color(0xFFDC3545);
      case PrimaryButtonType.info:
        return const Color(0xFF17A2B8);
      case PrimaryButtonType.warning:
        return const Color(0xFFFFC107);
      default:
        return const Color(0xFF2196F3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getButtonColor(),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}