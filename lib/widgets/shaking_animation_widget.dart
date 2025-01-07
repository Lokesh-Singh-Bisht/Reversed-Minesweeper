import 'package:flutter/material.dart';

class ShakingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final int shakes;
  final double offset;

  const ShakingWidget({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.shakes = 10,
    this.offset = 10.0,
  }) : super(key: key);

  @override
  _ShakingWidgetState createState() => _ShakingWidgetState();
}

class _ShakingWidgetState extends State<ShakingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progress = _animation.value;
        final shakeOffset = widget.offset *
            (1 - progress) *
            ((progress * widget.shakes).floor().isEven ? 1 : -1);
        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
