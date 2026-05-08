import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../app/app_controller.dart';
import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class PushNotificationBridge {
  PushNotificationBridge({FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  Future<void> bind(AppController controller) async {
    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    } catch (error) {
      debugPrint('Firebase background messaging registration skipped: $error');
    }
    await _trySetForegroundPresentationOptions();
    await _tryRequestPermission();
    FirebaseMessaging.onMessage.listen((message) async {
      await controller.refreshRemoteFamilies(force: true);
    });
    final token = await _tryGetToken();
    if (token != null) {
      await controller.syncNotificationToken(
        token: token,
        platform: _platformLabel,
      );
    }
    _messaging.onTokenRefresh.listen(
      (token) async {
        await controller.syncNotificationToken(
          token: token,
          platform: _platformLabel,
        );
      },
      onError: (Object error) {
        debugPrint('Push notification token refresh skipped: $error');
      },
    );
  }

  Future<void> _trySetForegroundPresentationOptions() async {
    try {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (error) {
      debugPrint('Foreground notification presentation skipped: $error');
    }
  }

  Future<void> _tryRequestPermission() async {
    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    } catch (error) {
      debugPrint('Push notification permission request skipped: $error');
    }
  }

  Future<String?> _tryGetToken() async {
    try {
      return await _messaging.getToken();
    } catch (error) {
      debugPrint('Push notification token unavailable: $error');
      return null;
    }
  }

  String get _platformLabel {
    if (kIsWeb) return 'web';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      TargetPlatform.macOS => 'macos',
      TargetPlatform.windows => 'windows',
      TargetPlatform.linux => 'linux',
      TargetPlatform.fuchsia => 'fuchsia',
    };
  }
}
