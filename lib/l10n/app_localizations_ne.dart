// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appTitle => 'भजन संग्रह';

  @override
  String get noBhajansYet => 'अहिलेसम्म कुनै भजन छैन।';

  @override
  String get allCategory => 'सबै';

  @override
  String get searchHint => 'भजन खोज्नुहोस्...';

  @override
  String get noResults => 'कुनै नतिजा फेला परेन।';

  @override
  String get viewModeDevanagari => 'देवनागरी';

  @override
  String get viewModeRoman => 'रोमन';

  @override
  String get viewModeBoth => 'दुवै';

  @override
  String get shareTooltip => 'साझा गर्नुहोस्';

  @override
  String get bookmarkAdd => 'बुकमार्क गर्नुहोस्';

  @override
  String get bookmarkRemove => 'बुकमार्क हटाउनुहोस्';

  @override
  String get bookmarkAdded => 'बुकमार्क थपियो';

  @override
  String get bookmarkRemoved => 'बुकमार्क हटाइयो';

  @override
  String get sourceLabel => 'स्रोत';

  @override
  String get sourceBook => 'पुस्तक:';

  @override
  String get sourceAuthor => 'लेखक:';

  @override
  String get sourcePublisher => 'प्रकाशक:';

  @override
  String get sourceYear => 'वर्ष:';

  @override
  String get sourcePage => 'पृष्ठ:';

  @override
  String get signInToSync => 'आफ्ना बुकमार्कहरू सिंक गर्न साइन इन गर्नुहोस्';

  @override
  String get signInToViewBookmarks =>
      'बुकमार्कहरू हेर्न र सिंक गर्न साइन इन गर्नुहोस्';

  @override
  String get signIn => 'साइन इन गर्नुहोस्';

  @override
  String get signOut => 'साइन आउट गर्नुहोस्';

  @override
  String get notSignedIn => 'साइन इन गरिएको छैन';

  @override
  String get signOutConfirm =>
      'तपाईंका बुकमार्कहरू यस डिभाइसमा रहनेछन् तर अब सिंक हुनेछैनन्। जारी राख्ने?';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String signedInAndSynced(String name) {
    return '$name को रूपमा साइन इन गरियो। बुकमार्कहरू सिंक भयो।';
  }

  @override
  String get signInFailed => 'साइन इन असफल भयो। फेरि प्रयास गर्नुहोस्।';

  @override
  String get noBookmarksYet =>
      'अहिलेसम्म कुनै बुकमार्क छैन। यहाँ सेभ गर्न कुनै पनि भजनमा ⭐ थिच्नुहोस्।';

  @override
  String get navHome => 'गृह';

  @override
  String get navBookmarks => 'बुकमार्क';

  @override
  String get navQuotes => 'गीता';

  @override
  String get navSettings => 'सेटिङ';

  @override
  String get quotesScreenTitle => 'गीता ज्ञान';

  @override
  String get noQuotesYet => 'अहिलेसम्म कुनै वचन छैन।';

  @override
  String get copyTooltip => 'कपी गर्नुहोस्';

  @override
  String quoteCopied(String chapterVerse) {
    return '$chapterVerse कपी भयो';
  }

  @override
  String get fontSize => 'फन्ट साइज';

  @override
  String get theme => 'थिम';

  @override
  String get themeLight => 'उज्यालो';

  @override
  String get themeDark => 'अँध्यारो';

  @override
  String get themeSystem => 'प्रणाली';

  @override
  String get about => 'हाम्रो बारेमा';

  @override
  String get language => 'भाषा';

  @override
  String get syncFailedMessage =>
      'भजनहरू लोड गर्न सकिएन। आफ्नो इन्टरनेट जडान जाँच्नुहोस्।';

  @override
  String get retry => 'फेरि प्रयास गर्नुहोस्';

  @override
  String festivalGreeting(String festivalName) {
    return '$festivalName को शुभकामना!';
  }

  @override
  String festivalCta(String categoryName) {
    return '$categoryName भजनहरू हेर्न ट्याप गर्नुहोस्';
  }

  @override
  String get watchOnYoutube => 'युट्युबमा हेर्नुहोस्';
}
