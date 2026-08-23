import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(icon: const Icon(Icons.list_alt), label: l10n.navHome),
        NavigationDestination(icon: const Icon(Icons.star), label: l10n.navBookmarks),
        NavigationDestination(icon: const Icon(Icons.menu_book), label: l10n.navQuotes),
        NavigationDestination(icon: const Icon(Icons.settings), label: l10n.navSettings),
      ],
    );
  }
}
