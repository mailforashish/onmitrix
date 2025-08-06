import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onmitrix/utils/platform_utils.dart';

class PlatformAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Widget? bottom;

  const PlatformAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isIOS) {
      return CupertinoNavigationBar(
        middle: Text(title),
        trailing: actions != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            : null,
        leading: leading ??
            (automaticallyImplyLeading
                ? PlatformUtils.platformBackButton(context)
                : null),
        backgroundColor: backgroundColor,
      );
    }

    return AppBar(
      title: Text(title),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: bottom!,
            )
          : null,
    );
  }

  @override
  Size get preferredSize {
    if (PlatformUtils.isIOS) {
      return const Size.fromHeight(44);
    }
    return bottom != null
        ? const Size.fromHeight(96) // AppBar height + bottom height
        : const Size.fromHeight(56); // Default AppBar height
  }
}