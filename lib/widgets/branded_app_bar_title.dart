import 'package:flutter/material.dart';

/// The logo + screen title used in every main tab's AppBar (Home,
/// Bookmarks, Gita Gyan, Settings) — kept as one widget so the four stay
/// visually identical instead of drifting apart screen by screen.
class BrandedAppBarTitle extends StatelessWidget {
  const BrandedAppBarTitle({super.key, required this.title, this.style});

  final String title;

  /// Style override for [title] — e.g. the Devanagari text theme, so
  /// non-Latin titles get the app's Devanagari font instead of silently
  /// falling back to a system font that renders visibly smaller/thinner.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/branding/logo.png',
            width: 34,
            height: 34,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: (style ?? Theme.of(context).textTheme.headlineSmall)?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
