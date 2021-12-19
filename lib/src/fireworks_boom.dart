import 'dart:math';

import 'package:new_year_countdown/src/fireworks_particle.dart';
import 'package:flutter/material.dart';

class FireworksBoom extends StatelessWidget {
  const FireworksBoom({
    Key? key,
    this.size = 200,
  }) : super(key: key);

  final double size;

  final particles = 5;

  double get degrees => 360 / particles;

  @override
  Widget build(BuildContext context) {
    final durationInSeconds = _generateRandomDurationInSeconds();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: Stack(
        children: List.generate(particles, (index) {
          return RotationTransition(
            turns: AlwaysStoppedAnimation(degrees * (index + 1) / 360.0),
            child: Padding(
              padding: EdgeInsets.only(bottom: size / 2),
              child: FireworksParticle(
                durationInSeconds: durationInSeconds,
                distance: size,
              ),
            ),
          );
        }),
      ),
    );
  }

  int _generateRandomDurationInSeconds() {
    final seconds = [1, 3, 5, 7];

    return seconds[Random().nextInt(seconds.length)];
  }
}
