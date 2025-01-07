import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reversed_minesweeper/theme.dart';
import 'package:reversed_minesweeper/widgets/floating_animation_widget.dart';

class GameOverAnimation extends StatefulWidget {
  final int totalDiscoveredBombs;

  final VoidCallback onExit;

  const GameOverAnimation({
    Key? key,
    required this.totalDiscoveredBombs,
    required this.onExit,
  }) : super(key: key);

  @override
  _GameOverAnimationState createState() => _GameOverAnimationState();
}

class _GameOverAnimationState extends State<GameOverAnimation>
    with TickerProviderStateMixin {
  late AnimationController _gameController;
  late AnimationController _overController;
  late AnimationController _slideController;
  late Animation<double> _gameScaleAnimation;
  late Animation<double> _overScaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _gameController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _overController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _gameScaleAnimation = Tween<double>(begin: 10, end: 1.5).animate(
      CurvedAnimation(
        parent: _gameController,
        curve: Curves.elasticInOut,
      ),
    );

    _overScaleAnimation = Tween<double>(begin: 0.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _overController,
        curve: Curves.elasticInOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 10), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await _gameController.forward();
    await _overController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _gameController.dispose();
    _overController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _gameScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _gameScaleAnimation.value,
                  child: Text(
                    'GAME',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 55,
                      color: GameTheme.secondryColor,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          color: Colors.white,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _overScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _overScaleAnimation.value,
                  child: Text(
                    'OVER',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 55,
                      color: GameTheme.secondryColor,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          color: Colors.white,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  FloatingAnimationWidget(
                    child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: GameTheme.secondryColor, width: 1),
                          boxShadow: const [
                            BoxShadow(
                                color: GameTheme.secondryColor,
                                blurRadius: 12,
                                spreadRadius: 5,
                                offset: Offset(0, 0)),
                          ],
                        ),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.totalDiscoveredBombs == 1
                                      ? 'Bomb Discovered\n'
                                      : 'Bombs Discovered\n',
                                  style: GoogleFonts.russoOne(
                                    fontSize: 18,
                                    color: GameTheme.primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: "${widget.totalDiscoveredBombs}",
                                  style: GoogleFonts.russoOne(
                                    fontSize: 50,
                                    color: GameTheme.secondryColor,
                                    letterSpacing: 2,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ))),
                  ),
                  const SizedBox(height: 40),
                  OutlinedButton(
                    onPressed: widget.onExit,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: GameTheme.alertColor, width: 3),
                    ),
                    child: Text(
                      "Exit",
                      style: GoogleFonts.russoOne(
                        fontSize: 18,
                        color: GameTheme.alertColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
