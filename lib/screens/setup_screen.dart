import 'package:flutter/material.dart';
import 'package:reversed_minesweeper/helpers/constants.dart';
import 'package:reversed_minesweeper/theme.dart';

import 'package:reversed_minesweeper/widgets/setup_screen_modal.dart';
import 'package:reversed_minesweeper/widgets/animated_title_widget.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _containerSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.45),
      end: const Offset(0.0, 0.1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _containerSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(seconds: 4), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameTheme.primaryColor,
      body: Center(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _titleSlideAnimation,
                  child: SizedBox(
                      width: Constants.screenWidth,
                      child: AnimatedTitleTextWidget()),
                );
              },
            ),
            Positioned(
              bottom: 35,
              left: 20,
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return SlideTransition(
                        position: _containerSlideAnimation,
                        child: SelectBoardWidget());
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
