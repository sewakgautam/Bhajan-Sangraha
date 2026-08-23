# Changelog

## 2026-07-25

### Content
- Added 15 new bhajans (`bhajan-052` through `bhajan-066`), bringing the total to 66:
  - बिदाई भजन, 2× दुर्गा bhajans, लक्ष्मी bhajan, 2× शिव bhajans, 4× कृष्ण bhajans
  - श्री हनुमान चालीसा (full text, doha + 40 chaupai, with meaning)
  - नित्य मन्त्र संग्रह — combined Ganesh/Shiv/Hanuman/Devi/Surya/Vishnu mantras
- Fixed `bhajan-052` missing `updated_at` field (was blocking incremental sync from picking it up).
- Fixed `categories/Bidai` — `sort_order` was stored as a string instead of a number, which crashed `Category.fromFirestore` and silently broke sync for **all** bhajans, not just the new one.

### New: Verse meanings (अर्थ)
- Added `meaning_devanagari` field to the `Bhajan` model (Dart model, Hive adapter, Firestore schema).
- Bhajan detail screen now shows an "अर्थ" section under the lyrics when a meaning is present.

### New: Gita Quotes tab (गीता ज्ञान)
- New Firestore collection `gita_quotes`, with security rules (`is_active == true` gate, matching the bhajans pattern).
- New `GitaQuote` model with Hive caching, synced alongside bhajans/categories.
- New tab in the bottom nav (4 tabs now: Home, Bookmarks, गीता, Settings).
- 49 Bhagavad Gita shlokas seeded so far — Sanskrit (Devanagari), romanization, Nepali meaning, and chapter/verse reference for each.
- List sorts by chapter then verse (added dedicated numeric `chapter`/`verse` fields — the display string alone couldn't sort correctly since its digits are Devanagari).
- Copy-to-clipboard button on each card; confirmation toast names the exact verse copied (e.g. "अध्याय २ - श्लोक ४७ कपी भयो").

### New: Daily Gita quote notification
- Added `firebase_messaging`; app requests notification permission and subscribes every install to the `daily_gita_quote` topic on launch.
- Added a Cloud Function (`functions/`, `sendDailyGitaQuote`) — runs daily at 6am Nepal time, rotates through active quotes in chapter/verse order, and pushes one to the topic. Position is tracked in `meta/quote_rotation` so it doesn't repeat until the full set has cycled.
- Firebase project upgraded to the Blaze plan and the function is deployed and live.

### App icon & branding
- Replaced the old edge-to-edge Om logo with the new circular badge (माला/mandala design) as the primary app icon.
- Fixed adaptive icon clipping: the badge now sits inside a transparent safe-zone margin (62% fill) instead of touching the canvas edge, so it survives every OEM mask shape (circle/squircle/rounded-square) without cropping.
- Removed all forced white padding — both the adaptive icon background and the Android 12+ splash screen background now use the badge's own maroon (`#350712`) instead of white, so the margin is invisible rather than a white box.
- Legacy (pre-Android 8) fallback icon also switched to the new circular badge for consistency.
- In-app logo (home screen app bar, Settings screen) left unchanged, as requested.

### Housekeeping
- `pubspec.yaml`: added `firebase_messaging`, pinned `intl` (was `any`), updated the app description from the Flutter boilerplate default.
- Drafted the Nepali Play Store "What's new" release note for this update.

---

*Still pending: more Gita quotes to reach the full ~100 (currently at 49); a dedicated `surya` category (Surya bhajans currently filed under `other`).*
