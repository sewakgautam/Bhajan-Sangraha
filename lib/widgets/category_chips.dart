import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/category.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelected;

  /// [ChipThemeData.labelStyle] can't vary by selection state, so each chip
  /// overrides it directly — solid saffron with white text when selected,
  /// the muted neutral pill otherwise.
  Widget _chip(BuildContext context, {required String label, required bool selected, required VoidCallback onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: colorScheme.primary,
        labelStyle: TextStyle(
          color: selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onSelected: (_) => onTap(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNepali = Localizations.localeOf(context).languageCode == 'ne';

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        children: [
          _chip(
            context,
            label: AppLocalizations.of(context)!.allCategory,
            selected: selectedCategoryId == null,
            onTap: () => onSelected(null),
          ),
          for (final category in categories)
            _chip(
              context,
              label: isNepali ? category.nameDevanagari : category.nameEnglish,
              selected: selectedCategoryId == category.id,
              onTap: () => onSelected(category.id),
            ),
        ],
      ),
    );
  }
}
