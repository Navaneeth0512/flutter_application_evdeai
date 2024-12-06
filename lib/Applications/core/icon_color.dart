import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class GradientIcon extends StatelessWidget {
  final double size;
  const GradientIcon({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: Icon(
        Bootstrap.bus_front_fill,
        size: size,
        color: Colors.white, // Set a base color for the ShaderMask
      ),
    );
  }
}
