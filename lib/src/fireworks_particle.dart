import 'package:flutter/material.dart';

class FireworksParticle extends StatefulWidget {
  const FireworksParticle({
    Key? key,
    required this.durationInSeconds,
    required this.distance,
  }) : super(key: key);

  final int durationInSeconds;
  final double distance;

  @override
  State<FireworksParticle> createState() => _FireworksParticleState();
}

class _FireworksParticleState extends State<FireworksParticle>
    with TickerProviderStateMixin {
  late final AnimationController _traverseController;
  late final Animation<double> _traverseAnimation;
  late final AnimationController _opacityController;
  late final Animation<double> _opacityAimation;

  final particleSize = 40.0;

  @override
  void initState() {
    super.initState();

    _traverseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationInSeconds),
    );

    _traverseAnimation = Tween(
      begin: widget.distance - particleSize,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _traverseController,
        curve: Curves.easeOutSine,
      ),
    );

    _traverseController.forward();

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _opacityAimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _opacityController,
        curve: Curves.linear,
      ),
    );

    _opacityController.forward();

    _opacityController.addStatusListener((status) async {
      if (status == AnimationStatus.completed &&
          _opacityController.value == 1) {
        await Future.delayed(
          Duration(seconds: widget.durationInSeconds - 1),
        );
        _opacityController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _traverseController.dispose();
    _opacityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _opacityAimation,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAimation.value,
            child: AnimatedBuilder(
              animation: _traverseAnimation,
              builder: (context, child) {
                return SizedBox(
                  height: widget.distance,
                  width: particleSize,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: _traverseAnimation.value,
                        child: child!,
                      ),
                    ],
                  ),
                );
              },
              child: Image.asset(
                _asset,
                width: particleSize,
              ),
            ),
          );
        });
  }
}

const _asset = 'assets/fireworks-particle.png';
