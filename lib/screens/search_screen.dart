import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/bhajan.dart';
import '../services/hive_service.dart';
import '../widgets/bhajan_card.dart';
import 'bhajan_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  late final List<Bhajan> _allBhajans = HiveService.instance.getAllBhajans();

  Map<String, String> _categoryLabels(BuildContext context) {
    final isNepali = Localizations.localeOf(context).languageCode == 'ne';
    return {
      for (final category in HiveService.instance.getCategories())
        category.id: isNepali ? category.nameDevanagari : category.nameEnglish,
    };
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      setState(() => _query = value.trim());
    });
  }

  List<Bhajan> get _results {
    if (_query.isEmpty) return const [];
    final query = _query.toLowerCase();
    return _allBhajans.where((bhajan) {
      if (bhajan.titleDevanagari.toLowerCase().contains(query)) return true;
      if (bhajan.titleRoman.toLowerCase().contains(query)) return true;
      if (bhajan.firstLineDevanagari.toLowerCase().contains(query)) return true;
      if (bhajan.firstLineRoman.toLowerCase().contains(query)) return true;
      if (bhajan.keywords.any((k) => k.toLowerCase().contains(query))) return true;
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final results = _results;
    final categoryLabels = _categoryLabels(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
          ),
        ),
      ),
      body: _query.isEmpty
          ? const SizedBox.shrink()
          : results.isEmpty
              ? Center(child: Text(l10n.noResults))
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final bhajan = results[index];
                    return BhajanCard(
                      bhajan: bhajan,
                      categoryLabel: categoryLabels[bhajan.category] ?? bhajan.category,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BhajanDetailScreen(
                              bhajans: results,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
