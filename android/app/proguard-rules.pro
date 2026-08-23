# Firebase discovers its SDKs (Crashlytics, Firestore, Auth, ...) at runtime
# by reflectively instantiating each one's ComponentRegistrar, looked up by
# class name string from the merged manifest — nothing in our code
# references these classes directly, so without a keep rule R8 strips/renames
# them. That breaks Firebase silently: CrashlyticsRegistrar in particular
# fails with "NullPointerException: FirebaseCrashlytics component is not
# present", which surfaces as Firebase.initializeApp() itself throwing —
# taking every step after it in main.dart's bootstrap down too (update
# check, festival sync, notification permission prompt) and leaving
# Firestore permanently unusable ("[core/no-app] No Firebase App '[DEFAULT]'
# has been created").
-keep class com.google.firebase.components.ComponentRegistrar { *; }
-keep interface com.google.firebase.components.ComponentRegistrar
-keep class * implements com.google.firebase.components.ComponentRegistrar { *; }

# Room (used internally by WorkManager, pulled in transitively via
# firebase_messaging/flutter_local_notifications) instantiates its generated
# *_Impl database/DAO classes via reflection at runtime. Without an explicit
# keep rule, R8 strips or renames them and startup crashes with:
# "RuntimeException: Failed to create an instance of androidx.work.impl.WorkDatabase".
-keep class * extends androidx.room.RoomDatabase
-keep class androidx.work.impl.** { *; }
-keep class androidx.room.** { *; }
