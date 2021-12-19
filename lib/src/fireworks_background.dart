import 'dart:async';
import 'dart:math';

import 'package:new_year_countdown/src/fireworks_boom.dart';
import 'package:flutter/widgets.dart';

class FireworksBackground extends StatefulWidget {
  const FireworksBackground({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  State<FireworksBackground> createState() => _FireworksBackgroundState();
}

class _FireworksBackgroundState extends State<FireworksBackground> {
  var items = 30;

  late final Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        fireworks.addAll(List.generate(3, (_) => _buildFireworks()));
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  final List<Widget> fireworks = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Stack(
        fit: StackFit.expand,
        children: fireworks,
      ),
    );
  }

  Positioned _buildFireworks() {
    return Positioned(
      left: (Random().nextDouble() * widget.size.width) - 100,
      top: (Random().nextDouble() * widget.size.height) - 100,
      child: const FireworksBoom(),
    );
  }
}
