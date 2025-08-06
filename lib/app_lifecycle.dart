import 'package:flutter/material.dart';
import 'package:onmitrix/utils/session_manager.dart';

class AppLifecycle extends StatefulWidget {
  final Widget child;

  const AppLifecycle({
    Key? key,
    required this.child,
  }) : super(key: key);

  static AppLifecycleState state = AppLifecycleState.resumed;
  static bool wasInBackground = false;

  @override
  State<AppLifecycle> createState() => _AppLifecycleState();
}

class _AppLifecycleState extends State<AppLifecycle> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppLifecycle.state = state;

    switch (state) {
      case AppLifecycleState.resumed:
        _onMoveToForeground();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _onMoveToBackground();
        break;
      case AppLifecycleState.hidden:
        // Handle hidden state if needed
        break;
    }
  }

  void _onMoveToForeground() {
    AppLifecycle.wasInBackground = true;
    // Add any other foreground tasks
  }

  void _onMoveToBackground() {
    AppLifecycle.wasInBackground = false;
    // Add any background tasks
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// Extension to add lifecycle awareness to the app
extension AppLifecycleAware on BuildContext {
  bool get isInForeground => AppLifecycle.state == AppLifecycleState.resumed;
  bool get wasInBackground => AppLifecycle.wasInBackground;
}