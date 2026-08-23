// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bhajan Sangraha';

  @override
  String get noBhajansYet => 'No bhajans yet.';

  @override
  String get allCategory => 'All';

  @override
  String get searchHint => 'Search bhajans...';

  @override
  String get noResults => 'No results.';

  @override
  String get viewModeDevanagari => 'Devanagari';

  @override
  String get viewModeRoman => 'Roman';

  @override
  String get viewModeBoth => 'Both';

  @override
  String get shareTooltip => 'Share';

  @override
  String get bookmarkAdd => 'Bookmark';

  @override
  String get bookmarkRemove => 'Remove bookmark';

  @override
  String get bookmarkAdded => 'Bookmark added';

  @override
  String get bookmarkRemoved => 'Bookmark removed';

  @override
  String get sourceLabel => 'Source';

  @override
  String get sourceBook => 'Book:';

  @override
  String get sourceAuthor => 'Author:';

  @override
  String get sourcePublisher => 'Publisher:';

  @override
  String get sourceYear => 'Year:';

  @override
  String get sourcePage => 'Page:';

  @override
  String get signInToSync => 'Sign in to sync your bookmarks across devices';

  @override
  String get signInToViewBookmarks => 'Sign in to view and sync your bookmarks';

  @override
  String get signIn => 'Sign In';

  @override
  String get signOut => 'Sign Out';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get signOutConfirm =>
      'Your bookmarks will remain on this device but will no longer sync. Continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String signedInAndSynced(String name) {
    return 'Signed in as $name. Bookmarks synced.';
  }

  @override
  String get signInFailed => 'Sign in failed. Try again.';

  @override
  String get noBookmarksYet =>
      'No bookmarks yet. Tap ⭐ on any bhajan to save it here.';

  @override
  String get navHome => 'Home';

  @override
  String get navBookmarks => 'Bookmarks';

  @override
  String get navQuotes => 'Gita';

  @override
  String get navSettings => 'Settings';

  @override
  String get quotesScreenTitle => 'Gita Quotes';

  @override
  String get noQuotesYet => 'No quotes yet.';

  @override
  String get copyTooltip => 'Copy';

  @override
  String quoteCopied(String chapterVerse) {
    return '$chapterVerse copied';
  }

  @override
  String get fontSize => 'Font size';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get about => 'About US';

  @override
  String get language => 'Language';

  @override
  String get syncFailedMessage =>
      'Could not load bhajans. Check your connection.';

  @override
  String get retry => 'Retry';

  @override
  String festivalGreeting(String festivalName) {
    return 'Happy $festivalName!';
  }

  @override
  String festivalCta(String categoryName) {
    return 'Tap to view $categoryName bhajans';
  }

  @override
  String get watchOnYoutube => 'Watch on YouTube';
}
