import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ne.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ne'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ne, this message translates to:
  /// **'भजन संग्रह'**
  String get appTitle;

  /// No description provided for @noBhajansYet.
  ///
  /// In ne, this message translates to:
  /// **'अहिलेसम्म कुनै भजन छैन।'**
  String get noBhajansYet;

  /// No description provided for @allCategory.
  ///
  /// In ne, this message translates to:
  /// **'सबै'**
  String get allCategory;

  /// No description provided for @searchHint.
  ///
  /// In ne, this message translates to:
  /// **'भजन खोज्नुहोस्...'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In ne, this message translates to:
  /// **'कुनै नतिजा फेला परेन।'**
  String get noResults;

  /// No description provided for @viewModeDevanagari.
  ///
  /// In ne, this message translates to:
  /// **'देवनागरी'**
  String get viewModeDevanagari;

  /// No description provided for @viewModeRoman.
  ///
  /// In ne, this message translates to:
  /// **'रोमन'**
  String get viewModeRoman;

  /// No description provided for @viewModeBoth.
  ///
  /// In ne, this message translates to:
  /// **'दुवै'**
  String get viewModeBoth;

  /// No description provided for @shareTooltip.
  ///
  /// In ne, this message translates to:
  /// **'साझा गर्नुहोस्'**
  String get shareTooltip;

  /// No description provided for @bookmarkAdd.
  ///
  /// In ne, this message translates to:
  /// **'बुकमार्क गर्नुहोस्'**
  String get bookmarkAdd;

  /// No description provided for @bookmarkRemove.
  ///
  /// In ne, this message translates to:
  /// **'बुकमार्क हटाउनुहोस्'**
  String get bookmarkRemove;

  /// No description provided for @bookmarkAdded.
  ///
  /// In ne, this message translates to:
  /// **'बुकमार्क थपियो'**
  String get bookmarkAdded;

  /// No description provided for @bookmarkRemoved.
  ///
  /// In ne, this message translates to:
  /// **'बुकमार्क हटाइयो'**
  String get bookmarkRemoved;

  /// No description provided for @sourceLabel.
  ///
  /// In ne, this message translates to:
  /// **'स्रोत'**
  String get sourceLabel;

  /// No description provided for @sourceBook.
  ///
  /// In ne, this message translates to:
  /// **'पुस्तक:'**
  String get sourceBook;

  /// No description provided for @sourceAuthor.
  ///
  /// In ne, this message translates to:
  /// **'लेखक:'**
  String get sourceAuthor;

  /// No description provided for @sourcePublisher.
  ///
  /// In ne, this message translates to:
  /// **'प्रकाशक:'**
  String get sourcePublisher;

  /// No description provided for @sourceYear.
  ///
  /// In ne, this message translates to:
  /// **'वर्ष:'**
  String get sourceYear;

  /// No description provided for @sourcePage.
  ///
  /// In ne, this message translates to:
  /// **'पृष्ठ:'**
  String get sourcePage;

  /// No description provided for @signInToSync.
  ///
  /// In ne, this message translates to:
  /// **'आफ्ना बुकमार्कहरू सिंक गर्न साइन इन गर्नुहोस्'**
  String get signInToSync;

  /// No description provided for @signInToViewBookmarks.
  ///
  /// In ne, this message translates to:
  /// **'बुकमार्कहरू हेर्न र सिंक गर्न साइन इन गर्नुहोस्'**
  String get signInToViewBookmarks;

  /// No description provided for @signIn.
  ///
  /// In ne, this message translates to:
  /// **'साइन इन गर्नुहोस्'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In ne, this message translates to:
  /// **'साइन आउट गर्नुहोस्'**
  String get signOut;

  /// No description provided for @notSignedIn.
  ///
  /// In ne, this message translates to:
  /// **'साइन इन गरिएको छैन'**
  String get notSignedIn;

  /// No description provided for @signOutConfirm.
  ///
  /// In ne, this message translates to:
  /// **'तपाईंका बुकमार्कहरू यस डिभाइसमा रहनेछन् तर अब सिंक हुनेछैनन्। जारी राख्ने?'**
  String get signOutConfirm;

  /// No description provided for @cancel.
  ///
  /// In ne, this message translates to:
  /// **'रद्द गर्नुहोस्'**
  String get cancel;

  /// No description provided for @signedInAndSynced.
  ///
  /// In ne, this message translates to:
  /// **'{name} को रूपमा साइन इन गरियो। बुकमार्कहरू सिंक भयो।'**
  String signedInAndSynced(String name);

  /// No description provided for @signInFailed.
  ///
  /// In ne, this message translates to:
  /// **'साइन इन असफल भयो। फेरि प्रयास गर्नुहोस्।'**
  String get signInFailed;

  /// No description provided for @noBookmarksYet.
  ///
  /// In ne, this message translates to:
  /// **'अहिलेसम्म कुनै बुकमार्क छैन। यहाँ सेभ गर्न कुनै पनि भजनमा ⭐ थिच्नुहोस्।'**
  String get noBookmarksYet;

  /// No description provided for @navHome.
  ///
  /// In ne, this message translates to:
  /// **'गृह'**
  String get navHome;

  /// No description provided for @navBookmarks.
  ///
  /// In ne, this message translates to:
  /// **'बुकमार्क'**
  String get navBookmarks;

  /// No description provided for @navQuotes.
  ///
  /// In ne, this message translates to:
  /// **'गीता'**
  String get navQuotes;

  /// No description provided for @navSettings.
  ///
  /// In ne, this message translates to:
  /// **'सेटिङ'**
  String get navSettings;

  /// No description provided for @quotesScreenTitle.
  ///
  /// In ne, this message translates to:
  /// **'गीता ज्ञान'**
  String get quotesScreenTitle;

  /// No description provided for @noQuotesYet.
  ///
  /// In ne, this message translates to:
  /// **'अहिलेसम्म कुनै वचन छैन।'**
  String get noQuotesYet;

  /// No description provided for @copyTooltip.
  ///
  /// In ne, this message translates to:
  /// **'कपी गर्नुहोस्'**
  String get copyTooltip;

  /// No description provided for @quoteCopied.
  ///
  /// In ne, this message translates to:
  /// **'{chapterVerse} कपी भयो'**
  String quoteCopied(String chapterVerse);

  /// No description provided for @fontSize.
  ///
  /// In ne, this message translates to:
  /// **'फन्ट साइज'**
  String get fontSize;

  /// No description provided for @theme.
  ///
  /// In ne, this message translates to:
  /// **'थिम'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In ne, this message translates to:
  /// **'उज्यालो'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ne, this message translates to:
  /// **'अँध्यारो'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In ne, this message translates to:
  /// **'प्रणाली'**
  String get themeSystem;

  /// No description provided for @about.
  ///
  /// In ne, this message translates to:
  /// **'हाम्रो बारेमा'**
  String get about;

  /// No description provided for @language.
  ///
  /// In ne, this message translates to:
  /// **'भाषा'**
  String get language;

  /// No description provided for @syncFailedMessage.
  ///
  /// In ne, this message translates to:
  /// **'भजनहरू लोड गर्न सकिएन। आफ्नो इन्टरनेट जडान जाँच्नुहोस्।'**
  String get syncFailedMessage;

  /// No description provided for @retry.
  ///
  /// In ne, this message translates to:
  /// **'फेरि प्रयास गर्नुहोस्'**
  String get retry;

  /// No description provided for @festivalGreeting.
  ///
  /// In ne, this message translates to:
  /// **'{festivalName} को शुभकामना!'**
  String festivalGreeting(String festivalName);

  /// No description provided for @festivalCta.
  ///
  /// In ne, this message translates to:
  /// **'{categoryName} भजनहरू हेर्न ट्याप गर्नुहोस्'**
  String festivalCta(String categoryName);

  /// No description provided for @watchOnYoutube.
  ///
  /// In ne, this message translates to:
  /// **'युट्युबमा हेर्नुहोस्'**
  String get watchOnYoutube;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ne'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ne':
      return AppLocalizationsNe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
