import 'package:flutter/material.dart';

import 'morphic_container.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MorphicContainer(
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}
