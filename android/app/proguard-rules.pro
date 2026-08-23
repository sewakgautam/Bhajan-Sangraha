# Firebase, Google Sign-In, and Firestore ship their own consumer ProGuard
# rules inside their AARs, so no manual keep rules are needed here today.

# Room (used internally by WorkManager, pulled in transitively via
# firebase_messaging/flutter_local_notifications) instantiates its generated
# *_Impl database/DAO classes via reflection at runtime. Without an explicit
# keep rule, R8 strips or renames them and startup crashes with:
# "RuntimeException: Failed to create an instance of androidx.work.impl.WorkDatabase".
-keep class * extends androidx.room.RoomDatabase
-keep class androidx.work.impl.** { *; }
-keep class androidx.room.** { *; }
