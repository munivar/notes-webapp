import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAppAnimation extends StatelessWidget {
  final Widget child;
  const FadeAppAnimation({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Specify your tween
    final MovieTween tween = MovieTween()
      ..scene(
              curve: Curves.easeOut,
              begin: const Duration(milliseconds: 0),
              end: const Duration(milliseconds: 700))
          .tween('opacity', Tween(begin: 0.0, end: 1.0))
      ..scene(
              begin: const Duration(milliseconds: 700),
              end: const Duration(milliseconds: 1200))
          .tween('opacity', Tween(begin: 1.0, end: 1.0));
    return PlayAnimationBuilder<Movie>(
      tween: tween, // Pass in tween
      duration: tween.duration, // Obtain duration
      builder: (context, value, widget) {
        return Opacity(
          opacity: value.get('opacity'),
          child: child,
        );
      },
    );
  }
}
