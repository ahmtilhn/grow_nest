import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as timezone;

import 'app/app.dart';
import 'app/app_controller.dart';
import 'core/firebase/firebase_auth_gateway.dart';
import 'core/firebase/email_verification_service.dart';
import 'core/firebase/firebase_sync_service.dart';
import 'core/notifications/notification_service.dart';
import 'core/notifications/push_notification_bridge.dart';
import 'data/local/app_database.dart';
import 'data/repositories/app_repository.dart';
import 'firebase_options.dart';

const _useFirebaseEmulators = bool.fromEnvironment('USE_FIREBASE_EMULATORS');
const _firebaseEmulatorHost = String.fromEnvironment(
  'FIREBASE_EMULATOR_HOST',
  defaultValue: 'localhost',
);
const _allowLocalAuthFallback = bool.fromEnvironment(
  'ALLOW_LOCAL_AUTH_FALLBACK',
);

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  timezone.initializeTimeZones();

  final firebaseBindings = await _initializeFirebaseBindings();
  final authGateway = firebaseBindings.authGateway;

  final database = AppDatabase.open();
  final repository = AppRepository(database);
  await repository.seedContent();
  final currentUser = authGateway.currentUser;
  if (currentUser != null) {
    await repository.upsertAuthenticatedUser(
      id: currentUser.id,
      email: currentUser.email,
      displayName: currentUser.displayName,
      emailVerified: currentUser.emailVerified,
      avatarUrl: currentUser.avatarUrl,
    );
  }
  final notificationService = await _createNotificationService();
  final controller = AppController(
    repository,
    authGateway: authGateway,
    emailVerificationService: firebaseBindings.emailVerificationService,
    syncService: firebaseBindings.syncService,
    notificationService: notificationService,
  );
  await controller.load();
  await controller.refreshFamilyInvites(showDeviceNotification: false);
  await controller.refreshRemoteFamilies(showDeviceNotification: false);

  runApp(
    ProviderScope(
      overrides: [appControllerProvider.overrideWith((ref) => controller)],
      child: const MiniAdimlarApp(),
    ),
  );

  if (firebaseBindings.syncService.isEnabled) {
    unawaited(_bindPushNotifications(controller));
  }
}

Future<NotificationService> _createNotificationService() async {
  try {
    return await LocalNotificationService.create();
  } catch (error, stackTrace) {
    debugPrint('Local notification initialization skipped: $error');
    debugPrintStack(stackTrace: stackTrace);
    return InMemoryNotificationService();
  }
}

Future<void> _bindPushNotifications(AppController controller) async {
  try {
    await PushNotificationBridge().bind(controller);
  } catch (error, stackTrace) {
    debugPrint('Push notification bridge disabled: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

Future<_FirebaseBindings> _initializeFirebaseBindings() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final auth = firebase_auth.FirebaseAuth.instance;
    final firestoreInstance = firestore.FirebaseFirestore.instance;

    if (_useFirebaseEmulators) {
      await auth.useAuthEmulator(_firebaseEmulatorHost, 9099);
      firestoreInstance.useFirestoreEmulator(_firebaseEmulatorHost, 8080);
    }

    return _FirebaseBindings(
      authGateway: FirebaseAuthGateway(auth: auth),
      emailVerificationService: FirebaseEmailVerificationService(auth: auth),
      syncService: FirebaseFirestoreSyncService(
        firestoreInstance: firestoreInstance,
        auth: auth,
      ),
    );
  } catch (error) {
    if (!_allowLocalAuthFallback) {
      debugPrint('Firebase initialization failed: $error');
      rethrow;
    }
    return _FirebaseBindings(
      authGateway: await LocalAuthGateway.create(),
      emailVerificationService: const NoopEmailVerificationService(),
      syncService: const NoopRemoteSyncService(),
    );
  }
}

class _FirebaseBindings {
  const _FirebaseBindings({
    required this.authGateway,
    required this.emailVerificationService,
    required this.syncService,
  });

  final AuthGateway authGateway;
  final EmailVerificationService emailVerificationService;
  final RemoteSyncService syncService;
}
