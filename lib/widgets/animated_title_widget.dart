import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reversed_minesweeper/theme.dart';

class AnimatedTitleTextWidget extends StatefulWidget {
  @override
  _AnimatedTitleTextWidgetState createState() =>
      _AnimatedTitleTextWidgetState();
}

class _AnimatedTitleTextWidgetState extends State<AnimatedTitleTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _reversedSlideAnimation;
  late Animation<Offset> _minesweeperSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _reversedSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -10.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _minesweeperSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 10.0),
      end: const Offset(0.0, 0.0),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SlideTransition(
              position: _reversedSlideAnimation,
              child: Text(
                'REVERSED',
                style: GoogleFonts.pressStart2p(
                  fontSize: 35,
                  color: Colors.white,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      color: GameTheme.secondryColor,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SlideTransition(
              position: _minesweeperSlideAnimation,
              child: Text(
                'MINESWEEPER',
                style: GoogleFonts.pressStart2p(
                  fontSize: 25,
                  color: Colors.white,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      color: GameTheme.secondryColor,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ],
    );
  }
}
