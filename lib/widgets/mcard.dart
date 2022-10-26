import 'package:flutter/material.dart';

class MCard extends StatelessWidget {
  const MCard({
    Key? key,
    required this.child,
    this.elevation = 0.0,
  }) : super(key: key);

  final Widget child;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      elevation: elevation,
      child: child,
    );
  }
}
