import 'package:flutter/material.dart';

class FloatingAnimationWidget extends StatefulWidget {
  final Widget child;
  final double floatHeight;
  final Duration duration;

  const FloatingAnimationWidget({
    Key? key,
    required this.child,
    this.floatHeight = 10.0,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _FloatingAnimationWidgetState createState() =>
      _FloatingAnimationWidgetState();
}

class _FloatingAnimationWidgetState extends State<FloatingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: widget.floatHeight).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: widget.child,
        );
      },
    );
  }
}
