import 'package:flutter/material.dart';

import '../services/prefs_service.dart';

/// A compact "A– value A+" stepper — tapping either roundel nudges the
/// font size by one step instead of dragging a slider, matching the
/// bhajan detail screen's control-row layout (label left, stepper right).
class FontControls extends StatelessWidget {
  const FontControls({
    super.key,
    required this.fontSize,
    required this.onChanged,
  });

  final double fontSize;
  final ValueChanged<double> onChanged;

  static const _step = 2.0;

  @override
  Widget build(BuildContext context) {
    const min = PrefsService.minFontSize;
    const max = PrefsService.maxFontSize;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          label: 'A',
          fontSize: 12,
          onPressed: fontSize <= min ? null : () => onChanged((fontSize - _step).clamp(min, max)),
        ),
        SizedBox(
          width: 28,
          child: Text(
            '${fontSize.toInt()}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
          ),
        ),
        _StepButton(
          label: 'A',
          fontSize: 18,
          onPressed: fontSize >= max ? null : () => onChanged((fontSize + _step).clamp(min, max)),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.label, required this.fontSize, required this.onPressed});

  final String label;
  final double fontSize;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerHigh,
          disabledBackgroundColor: colorScheme.surfaceContainerHigh,
          shape: CircleBorder(
            side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          padding: EdgeInsets.zero,
        ),
        icon: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: onPressed == null
                ? colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
                : colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
