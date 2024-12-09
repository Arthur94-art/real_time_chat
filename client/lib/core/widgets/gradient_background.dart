import 'package:flutter/material.dart';

class GradientAppWrapper extends StatelessWidget {
  final Widget child;

  const GradientAppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return _GradientBackground(child: child);
  }
}

class _GradientBackground extends StatelessWidget {
  final Widget child;

  const _GradientBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F2027),
            Color(0xFF203A43),
            Color(0xFF2C5364),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
