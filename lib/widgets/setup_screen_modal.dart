import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reversed_minesweeper/bloc/game_bloc.dart';
import 'package:reversed_minesweeper/bloc/game_event.dart';
import 'package:reversed_minesweeper/helpers/constants.dart';
import 'package:reversed_minesweeper/screens/game_screen.dart';
import 'package:reversed_minesweeper/theme.dart';
import 'package:reversed_minesweeper/widgets/filled_custom_button.dart';
import 'package:reversed_minesweeper/widgets/floating_animation_widget.dart';

class SelectBoardWidget extends StatefulWidget {
  @override
  _SelectBoardWidgetState createState() => _SelectBoardWidgetState();
}

class _SelectBoardWidgetState extends State<SelectBoardWidget> {
  void navigateToGameScreen(int boardSize) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => GameBloc(
            boardSize: boardSize,
            timerInterval: 10,
          )..add(GameStartEvent()),
          child: GameScreen(boardSize: boardSize),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingAnimationWidget(
      child: Container(
        height: Constants.screenHeight * 0.7,
        width: Constants.screenWidth - 40,
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          border: Border.all(color: GameTheme.secondryColor),
          boxShadow: const [
            BoxShadow(
                color: GameTheme.secondryColor,
                blurRadius: 8,
                spreadRadius: 5,
                offset: Offset(0, -1)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: GameTheme.secondryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: GameTheme.secondryColor,
                      blurRadius: 10,
                      spreadRadius: 3,
                      blurStyle: BlurStyle.outer,
                      offset: Offset(0, 0)),
                ],
              ),
              child: Text(
                'CHOOSE BOARD SIZE TO\nPLAY!',
                style: GoogleFonts.russoOne(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 70),
            FilledCustomButton(
                onTap: () => navigateToGameScreen(6),
                buttonColor: GameTheme.primaryColor,
                buttonText: '6  x  6'),
            const SizedBox(height: 20),
            FilledCustomButton(
                onTap: () => navigateToGameScreen(8),
                buttonColor: GameTheme.primaryColor,
                buttonText: '8  x  8'),
            const SizedBox(height: 20),
            FilledCustomButton(
                onTap: () => navigateToGameScreen(10),
                buttonColor: GameTheme.primaryColor,
                buttonText: '10 x 10'),
            const SizedBox(height: 20),
            FilledCustomButton(
                onTap: () => navigateToGameScreen(12),
                buttonColor: GameTheme.primaryColor,
                buttonText: '12 x 12'),
          ],
        ),
      ),
    );
  }
}
