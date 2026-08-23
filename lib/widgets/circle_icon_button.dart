import 'package:flutter/material.dart';

/// A 40dp circular icon button on a tinted roundel — the recurring chrome
/// for app bar actions (search, bookmark, share) across Home and the bhajan
/// detail screen, replacing bare [IconButton]s with something that reads as
/// a deliberate, warm-toned control rather than default Material chrome.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.accent = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  /// True for a state-carrying action (e.g. an active bookmark) — tints the
  /// icon with the theme's tertiary (gold) color instead of the neutral one.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 19,
        color: accent ? colorScheme.tertiary : colorScheme.secondary,
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerHigh,
          shape: CircleBorder(
            side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
