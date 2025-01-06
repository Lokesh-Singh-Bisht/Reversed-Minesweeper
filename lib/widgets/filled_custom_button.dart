import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilledCustomButton extends StatelessWidget {
  final Color buttonColor;
  final VoidCallback onTap;
  final String buttonText;
  const FilledCustomButton(
      {super.key,
      required this.onTap,
      required this.buttonColor,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: buttonColor,
                  blurRadius: 5,
                  spreadRadius: 3,
                  blurStyle: BlurStyle.outer,
                  offset: const Offset(0, 0)),
            ],
          ),
          child: Stack(
            children: [
              const Positioned(
                left: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.white,
                ),
              ),
              const Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                    .copyWith(bottom: 0),
                child: Text(
                  buttonText,
                  style: GoogleFonts.russoOne(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
