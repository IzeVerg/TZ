import 'dart:math';

import 'package:flutter/material.dart';


class CanvasAnimatedCheckbox extends StatefulWidget {
  final Duration duration;
  final void Function() onTap;

  const CanvasAnimatedCheckbox({super.key,
    required this.duration,
    required this.onTap,

  });

  @override
  CanvasAnimatedCheckboxState createState() => CanvasAnimatedCheckboxState();
}

class CanvasAnimatedCheckboxState extends State<CanvasAnimatedCheckbox> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(duration: widget.duration, vsync: this, value: 0.0);
    // animationController.addListener(_animationControllerUpdateListener);
    super.initState();
  }

  @override
  void dispose() {
    // animationController.removeListener();

    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: _buttonTap,
        // child: const Painter(),
      ),
    );
  }

  void _buttonTap() {

  }
}
