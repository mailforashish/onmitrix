import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformUtils {
  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;

  static Widget platformLoadingIndicator({Color? color}) {
    return isIOS
        ? CupertinoActivityIndicator(color: color)
        : CircularProgressIndicator(color: color);
  }

  static Future<bool?> showPlatformDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? cancelText,
    String? confirmText,
  }) async {
    if (isIOS) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            if (cancelText != null)
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context, false),
                child: Text(cancelText),
              ),
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmText ?? 'OK'),
            ),
          ],
        ),
      );
    }

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText ?? 'OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> showPlatformBottomSheet({
    required BuildContext context,
    required Widget child,
    String? title,
  }) {
    if (isIOS) {
      return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: title != null ? Text(title) : null,
          message: child,
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
      );
    }

    return showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }

  static Widget platformSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? activeColor,
  }) {
    return isIOS
        ? CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          )
        : Switch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          );
  }

  static TextStyle get platformTextStyle {
    return isIOS
        ? const TextStyle(fontFamily: '.SF Pro Text')
        : const TextStyle(fontFamily: 'Roboto');
  }

  static EdgeInsets get platformPadding {
    return isIOS
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  }

  static Widget platformBackButton(BuildContext context) {
    return isIOS
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.back),
            onPressed: () => Navigator.of(context).pop(),
          )
        : IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          );
  }
}