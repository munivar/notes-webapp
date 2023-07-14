import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeInAnything extends StatelessWidget {
  final Widget child;
  const FadeInAnything({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MovieTween tween = MovieTween()
      ..scene(
        curve: Curves.easeOut,
        begin: const Duration(
            milliseconds: 650), // start after 650 millisecond duration
        end: const Duration(milliseconds: 1350), // Adjusted end duration
      ).tween('opacity', Tween(begin: 0.0, end: 1.0))
      ..scene(
        begin: const Duration(milliseconds: 1350), // Adjusted begin duration
        end: const Duration(milliseconds: 1350),
      ).tween('opacity', Tween(begin: 1.0, end: 1.0));
    return PlayAnimationBuilder(
      tween: tween, // Pass in tween
      duration: tween.duration, // Obtain duration
      builder: (context, value, widget) {
        return Opacity(opacity: value.get('opacity'), child: child);
      },
    );
  }
}
