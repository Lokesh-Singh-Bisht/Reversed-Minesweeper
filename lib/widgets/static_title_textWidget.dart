import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StaticTitleTextWidget extends StatelessWidget {
  final Color textColor;
  StaticTitleTextWidget({this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'REVERSED\n',
              style: GoogleFonts.pressStart2p(
                fontSize: 35,
                color: textColor,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                    color: Colors.white,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            TextSpan(
              text: 'MINESWEEPER',
              style: GoogleFonts.pressStart2p(
                fontSize: 25,
                color: textColor,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                    color: Colors.white,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
