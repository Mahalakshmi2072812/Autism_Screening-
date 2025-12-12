import 'package:flutter/material.dart';

class SafeLottie extends StatelessWidget {
  final String asset;
  final double? height;
  final double? width;

  const SafeLottie({
    super.key,
    required this.asset,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      height: height,
      width: width,
      fit: BoxFit.contain,
    );
  }
}
