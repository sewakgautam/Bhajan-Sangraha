import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../models/gita_quote.dart';
import '../services/hive_service.dart';
import '../services/sync_service.dart';
import '../theme/app_theme.dart';
import '../widgets/branded_app_bar_title.dart';

class GitaQuotesScreen extends StatefulWidget {
  const GitaQuotesScreen({super.key});

  @override
  State<GitaQuotesScreen> createState() => _GitaQuotesScreenState();
}

class _GitaQuotesScreenState extends State<GitaQuotesScreen> {
  List<GitaQuote> get _quotes {
    final quotes = HiveService.instance.getGitaQuotes()
      ..sort((a, b) {
        final chapterCompare = a.chapter.compareTo(b.chapter);
        if (chapterCompare != 0) return chapterCompare;
        return a.verse.compareTo(b.verse);
      });
    return quotes;
  }

  Future<void> _onRefresh() async {
    await SyncService.instance.forceRefresh();
    setState(() {});
  }

  void _copyQuote(GitaQuote quote) {
    final buffer = StringBuffer(quote.textDevanagari);
    if (quote.textRoman != null) {
      buffer
        ..writeln()
        ..write(quote.textRoman);
    }
    if (quote.meaningDevanagari != null) {
      buffer
        ..writeln()
        ..writeln()
        ..write(quote.meaningDevanagari);
    }
    Clipboard.setData(ClipboardData(text: buffer.toString()));
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.quoteCopied(quote.chapterVerse ?? '')),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final devanagariTextTheme = AppTheme.devanagariTextTheme(Theme.of(context).textTheme);
    final quotes = _quotes;

    return Scaffold(
      appBar: AppBar(
        title: BrandedAppBarTitle(
          title: l10n.quotesScreenTitle,
          style: devanagariTextTheme.headlineSmall,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: quotes.isEmpty
            ? ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(child: Text(l10n.noQuotesYet)),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  final quote = quotes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  quote.textDevanagari,
                                  style: devanagariTextTheme.bodyLarge?.copyWith(height: 1.6),
                                ),
                              ),
                              IconButton(
                                tooltip: l10n.copyTooltip,
                                icon: const Icon(Icons.copy_rounded, size: 20),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _copyQuote(quote),
                              ),
                            ],
                          ),
                          if (quote.textRoman != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              quote.textRoman!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                          if (quote.meaningDevanagari != null) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(height: 1),
                            ),
                            Text(
                              quote.meaningDevanagari!,
                              style: devanagariTextTheme.bodyMedium?.copyWith(
                                height: 1.5,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                          if (quote.chapterVerse != null) ...[
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                quote.chapterVerse!,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
