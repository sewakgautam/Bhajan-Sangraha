import 'package:share_plus/share_plus.dart';

import '../models/bhajan.dart';

class ShareService {
  ShareService._();

  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.pahadilabs.bhajan_sangraha';

  static String formatText(Bhajan bhajan) {
    final sourceLines = <String>[
      if ((bhajan.sourceBook ?? '').isNotEmpty)
        'स्रोत / Source: ${bhajan.sourceBook}',
      if ((bhajan.sourceAuthor ?? '').isNotEmpty)
        'लेखक / Author: ${bhajan.sourceAuthor}',
      if ((bhajan.sourcePublisher ?? '').isNotEmpty)
        'प्रकाशक / Publisher: ${bhajan.sourcePublisher}',
    ];

    return [
      bhajan.titleDevanagari,
      bhajan.titleRoman,
      '',
      bhajan.lyricsDevanagari,
      '',
      '—',
      '',
      bhajan.lyricsRoman,
      '',
      '—',
      if (sourceLines.isNotEmpty) sourceLines.join('\n'),
      '',
      'Shared from Bhajan Sangraha',
      _playStoreUrl,
    ].join('\n');
  }

  static Future<void> share(Bhajan bhajan) {
    return Share.share(formatText(bhajan));
  }
}
