import 'package:flutter/material.dart';

class PieceWidget extends StatelessWidget {
  final Size size;
  const PieceWidget({required this.size, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/icons/radiation_icon.png",
      height: size.height,
      width: size.width,
    );
  }
}
