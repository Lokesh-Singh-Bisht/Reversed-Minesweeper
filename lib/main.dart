import 'package:flutter/material.dart';

import 'package:reversed_minesweeper/theme.dart';
import 'screens/setup_screen.dart';

void main() {
  runApp(ReversedMinesweeperApp());
}

class ReversedMinesweeperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: MaterialApp(
        title: 'Reversed Minesweeper',
        theme: GameTheme.lightTheme,
        home: SetupScreen(),
      ),
    );
  }
}
