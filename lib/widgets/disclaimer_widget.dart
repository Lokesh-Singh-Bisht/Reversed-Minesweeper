import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reversed_minesweeper/theme.dart';

class DisclaimerDialogWidget extends StatefulWidget {
  @override
  _DisclaimerDialogWidgetState createState() => _DisclaimerDialogWidgetState();
}

class _DisclaimerDialogWidgetState extends State<DisclaimerDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: GameTheme.primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: GameTheme.primaryColor,
                blurRadius: 5,
                spreadRadius: 3,
                blurStyle: BlurStyle.outer,
                offset: Offset(0, 0)),
          ],
        ),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      'Drag the pieces to empty spaces and find the MINES before they ',
                  style: GoogleFonts.russoOne(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'EXPLODE!',
                  style: GoogleFonts.russoOne(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
