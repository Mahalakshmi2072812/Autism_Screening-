import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../assets/assets_paths.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 32,
    this.showText = false,
  });

  final double size;
  final bool showText;

  Future<bool> _assetExists() async {
    try {
      await rootBundle.load(AppIcons.appLogo);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _assetExists(),
      builder: (context, snapshot) {
        final exists = snapshot.data == true;
        if (exists) {
          return _buildImageLogo(context);
        }
        return _buildFallbackLogo(context);
      },
    );
  }

  Widget _buildImageLogo(BuildContext context) {
    final logo = ClipRRect(
      borderRadius: BorderRadius.circular(size / 4),
      child: Image.asset(
        AppIcons.appLogo,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );

    if (!showText) {
      return logo;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        logo,
        const SizedBox(width: 8),
        Text(
          'நெற்றிக்கண்',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildFallbackLogo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final container = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'MH',
        style: theme.textTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    if (!showText) {
      return container;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        container,
        const SizedBox(width: 8),
        Text(
          'நெற்றிக்கண்',
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
