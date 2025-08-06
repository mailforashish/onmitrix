import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onmitrix/utils/platform_utils.dart';

class PlatformButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isPrimary;
  final bool isDestructive;
  final double? width;
  final double height;
  final EdgeInsets? margin;

  const PlatformButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.isDestructive = false,
    this.width,
    this.height = 48,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isIOS) {
      return Container(
        width: width ?? double.infinity,
        height: height,
        margin: margin,
        child: CupertinoButton(
          onPressed: isLoading ? null : onPressed,
          padding: EdgeInsets.zero,
          color: _getButtonColor(context),
          child: isLoading
              ? const CupertinoActivityIndicator(color: Colors.white)
              : Text(
                  text,
                  style: TextStyle(
                    color: isPrimary || isDestructive ? Colors.white : CupertinoColors.activeBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      );
    }

    return Container(
      width: width ?? double.infinity,
      height: height,
      margin: margin,
      child: isPrimary
          ? ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getButtonColor(context),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _buildButtonContent(),
            )
          : OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: _getButtonColor(context),
                side: BorderSide(color: _getButtonColor(context)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _buildButtonContent(),
            ),
    );
  }

  Widget _buildButtonContent() {
    return isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isPrimary ? Colors.white : _getButtonColor(null),
              ),
              strokeWidth: 2,
            ),
          )
        : Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isPrimary ? Colors.white : _getButtonColor(null),
            ),
          );
  }

  Color _getButtonColor(BuildContext? context) {
    if (isDestructive) {
      return PlatformUtils.isIOS ? CupertinoColors.destructiveRed : Colors.red;
    }
    if (context != null) {
      return isPrimary ? Theme.of(context).primaryColor : Colors.transparent;
    }
    return Colors.blue;
  }
}