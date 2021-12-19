import 'package:flutter/widgets.dart';

class ClickableArea extends StatelessWidget {
  const ClickableArea({
    Key? key,
    required this.onTap,
    required this.child,
    this.onHover,
  }) : super(key: key);

  final Widget child;
  final Function onTap;
  final Function(bool)? onHover;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover?.call(true),
      onExit: (_) => onHover?.call(false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTap(),
        child: child,
      ),
    );
  }
}
