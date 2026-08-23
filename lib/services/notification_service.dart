import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// All installs subscribe to this topic; the daily Cloud Function publishes
/// one Gita quote a day to it rather than tracking per-device tokens.
const String dailyQuoteTopic = 'daily_gita_quote';

/// A fixed id so today's notification replaces yesterday's rather than
/// stacking a new one every day.
const int _dailyQuoteNotificationId = 1001;

const AndroidNotificationChannel _dailyQuoteChannel = AndroidNotificationChannel(
  'daily_gita_quote',
  'Daily Gita Quote',
  description: 'One Shrimad Bhagavad Gita verse a day, with its Nepali meaning.',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

bool _localNotificationsReady = false;

/// The Cloud Function sends a data-only FCM message (see
/// functions/index.js) rather than a `notification` payload, so Android
/// never auto-renders it with its own basic (single-line, no line-break)
/// notification — this is what actually builds and shows it, using
/// BigTextStyle so the blank line between the shlok and its Nepali meaning
/// survives on screen instead of being flattened.
Future<void> _ensureLocalNotificationsReady() async {
  if (_localNotificationsReady) return;
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _localNotifications.initialize(
    settings: const InitializationSettings(android: androidInit),
  );
  await _localNotifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_dailyQuoteChannel);
  _localNotificationsReady = true;
}

Future<void> _showQuoteNotification(RemoteMessage message) async {
  final title = message.data['title'];
  final body = message.data['body'];
  if (title == null || body == null) return;

  await _ensureLocalNotificationsReady();
  await _localNotifications.show(
    id: _dailyQuoteNotificationId,
    title: title,
    body: body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        _dailyQuoteChannel.id,
        _dailyQuoteChannel.name,
        channelDescription: _dailyQuoteChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(body, contentTitle: title),
      ),
    ),
  );
}

/// Runs in a separate isolate when a data message arrives while the app is
/// backgrounded or fully killed — must stay a top-level function per
/// firebase_messaging's requirements, and cannot touch any app/UI state
/// beyond what it sets up for itself here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await _showQuoteNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _ensureLocalNotificationsReady();
    FirebaseMessaging.onMessage.listen(_showQuoteNotification);

    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      await FirebaseMessaging.instance.subscribeToTopic(dailyQuoteTopic);
    } catch (e) {
      debugPrint('Notification setup failed: $e');
    }
  }
}
