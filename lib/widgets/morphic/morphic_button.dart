import 'package:flutter/material.dart';

class MorphicButton extends StatefulWidget {
  const MorphicButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.borderRadius = 24,
  });

  final Widget child;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double borderRadius;

  @override
  State<MorphicButton> createState() => _MorphicButtonState();
}

class _MorphicButtonState extends State<MorphicButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  void _setPressed(bool value) {
    setState(() {
      _isPressed = value;
    });
  }

  void _setHovered(bool value) {
    setState(() {
      _isHovered = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = widget.backgroundColor ?? colorScheme.primary;

    final scale = _isPressed
        ? 0.96
        : _isHovered
            ? 1.02
            : 1.0;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) {
          _setPressed(false);
          widget.onPressed();
        },
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  baseColor.withOpacity(0.95),
                  baseColor.withOpacity(0.75),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: baseColor.withOpacity(0.4),
                  offset: const Offset(0, 14),
                  blurRadius: 24,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            alignment: Alignment.center,
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
