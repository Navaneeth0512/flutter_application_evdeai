import 'package:flutter/material.dart';

const backGroundColor = Colors.white;
const textColor = Colors.black;

class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final double fontSize;

  const GradientText(this.text,
      {super.key, required this.gradient, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white, // This color is just a placeholder
        ),
      ),
    );
  }
}
