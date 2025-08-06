import 'package:flutter/material.dart';

enum SlideDirection {
  left,
  right,
  up,
  down,
}

class AnimationUtils {
  /// Shakes a view horizontally
  static void shakeView(BuildContext context, Widget child) {
    final animationKey = GlobalKey<_ShakeAnimationState>();
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => _ShakeAnimation(
        key: animationKey,
        child: child,
      ),
    );
  }

  /// Fades in a view
  static void fadeIn(BuildContext context, Widget child, {Duration? duration}) {
    final animationKey = GlobalKey<_FadeAnimationState>();
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => _FadeAnimation(
        key: animationKey,
        child: child,
        duration: duration ?? const Duration(milliseconds: 1000),
      ),
    );
  }

  /// Slides up a view
  static void slideUp(BuildContext context, Widget child, {Duration? duration}) {
    final animationKey = GlobalKey<_SlideAnimationState>();
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => _SlideAnimation(
        key: animationKey,
        child: child,
        duration: duration ?? const Duration(milliseconds: 500),
        direction: _SlideDirection.up,
      ),
    );
  }

  /// Slides down a view
  static void slideDown(BuildContext context, Widget child, {Duration? duration}) {
    final animationKey = GlobalKey<_SlideAnimationState>();
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => _SlideAnimation(
        key: animationKey,
        child: child,
        duration: duration ?? const Duration(milliseconds: 500),
        direction: _SlideDirection.down,
      ),
    );
  }

  /// Creates a circular reveal animation
  static void circularReveal(BuildContext context, Widget child) {
    final animationKey = GlobalKey<_CircularRevealState>();
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => _CircularReveal(
        key: animationKey,
        child: child,
      ),
    );
  }

  /// Creates a fade in transition animation
  static Widget fadeInTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Creates a slide transition animation
  /// Builds a slide animation for list items
  static Widget buildSlideAnimation({
    required int index,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: AlwaysStoppedAnimation(1.0),
          curve: Interval(
            index * 0.1,
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      ),
      builder: (context, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: AlwaysStoppedAnimation(1.0),
            curve: Interval(
              index * 0.1,
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        ),
        child: child,
      ),
      child: child,
    );
  }

  static Widget slideTransition({
    required Animation<double> animation,
    required Widget child,
    SlideDirection direction = SlideDirection.right,
  }) {
    final Tween<Offset> tween;
    switch (direction) {
      case SlideDirection.left:
        tween = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        );
        break;
      case SlideDirection.right:
        tween = Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        );
        break;
      case SlideDirection.up:
        tween = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        );
        break;
      case SlideDirection.down:
        tween = Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: Offset.zero,
        );
        break;
    }

    return SlideTransition(
      position: tween.animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
      ),
      child: child,
    );
  }
}

enum _SlideDirection { up, down }

class _ShakeAnimation extends StatefulWidget {
  final Widget child;

  const _ShakeAnimation({Key? key, required this.child}) : super(key: key);

  @override
  _ShakeAnimationState createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<_ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

class _FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const _FadeAnimation({
    Key? key,
    required this.child,
    required this.duration,
  }) : super(key: key);

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<_FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class _SlideAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final _SlideDirection direction;

  const _SlideAnimation({
    Key? key,
    required this.child,
    required this.duration,
    required this.direction,
  }) : super(key: key);

  @override
  _SlideAnimationState createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<_SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final begin = widget.direction == _SlideDirection.up
        ? const Offset(0, 1)
        : const Offset(0, -1);
    final end = const Offset(0, 0);

    _animation = Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

class _CircularReveal extends StatefulWidget {
  final Widget child;

  const _CircularReveal({Key? key, required this.child}) : super(key: key);

  @override
  _CircularRevealState createState() => _CircularRevealState();
}

class _CircularRevealState extends State<_CircularReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}