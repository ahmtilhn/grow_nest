import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';

class AuthIdentity {
  const AuthIdentity({
    required this.id,
    required this.email,
    required this.displayName,
    required this.emailVerified,
    required this.providerId,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String displayName;
  final bool emailVerified;
  final String providerId;
  final String? avatarUrl;
}

abstract class AuthGateway {
  AuthIdentity? get currentUser;
  Future<AuthIdentity?> signInWithGoogle();
  Future<AuthIdentity?> signInWithApple();
  Future<AuthIdentity?> signInWithEmail(String email, String password);
  Future<AuthIdentity?> createWithEmail(String email, String password);
  Future<AuthIdentity?> refreshCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> deleteCurrentUser();
  Future<void> signOut();
}

class LocalAuthGateway implements AuthGateway {
  LocalAuthGateway({SharedPreferences? preferences})
    : _preferences = preferences;

  static const _sessionKey = 'local_auth_session';
  static const _googleEmail = 'google.local@grownest.app';
  static const _googleName = 'Google Yerel Hesap';

  final SharedPreferences? _preferences;
  AuthIdentity? _memoryUser;

  static Future<LocalAuthGateway> create() async {
    return LocalAuthGateway(preferences: await SharedPreferences.getInstance());
  }

  @override
  AuthIdentity? get currentUser {
    final raw = _preferences?.getString(_sessionKey);
    if (raw == null || raw.trim().isEmpty) return _memoryUser;
    return _decode(raw);
  }

  @override
  Future<AuthIdentity?> signInWithGoogle() {
    return _save(
      AuthIdentity(
        id: _stableId(_googleEmail, 'google'),
        email: _googleEmail,
        displayName: _googleName,
        emailVerified: true,
        providerId: 'google.com',
      ),
    );
  }

  @override
  Future<AuthIdentity?> signInWithApple() {
    const email = 'apple.local@grownest.app';
    return _save(
      AuthIdentity(
        id: _stableId(email, 'apple'),
        email: email,
        displayName: 'Apple Yerel Hesap',
        emailVerified: true,
        providerId: 'apple.com',
      ),
    );
  }

  @override
  Future<AuthIdentity?> signInWithEmail(String email, String password) {
    final normalized = email.trim().toLowerCase();
    return _save(
      AuthIdentity(
        id: _stableId(normalized, 'email'),
        email: normalized,
        displayName: _nameFromEmail(normalized),
        emailVerified: true,
        providerId: 'password',
      ),
    );
  }

  @override
  Future<AuthIdentity?> createWithEmail(String email, String password) {
    final normalized = email.trim().toLowerCase();
    return _save(
      AuthIdentity(
        id: _stableId(normalized, 'email'),
        email: normalized,
        displayName: _nameFromEmail(normalized),
        emailVerified: true,
        providerId: 'password',
      ),
    );
  }

  @override
  Future<AuthIdentity?> refreshCurrentUser() async => currentUser;

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> deleteCurrentUser() async {}

  @override
  Future<void> signOut() async {
    _memoryUser = null;
    await _preferences?.remove(_sessionKey);
  }

  Future<AuthIdentity> _save(AuthIdentity identity) async {
    _memoryUser = identity;
    await _preferences?.setString(_sessionKey, _encode(identity));
    return identity;
  }

  String _encode(AuthIdentity identity) {
    return [
      identity.id,
      identity.email,
      identity.displayName,
      identity.emailVerified ? 'true' : 'false',
      identity.providerId,
      identity.avatarUrl ?? '',
    ].join('\n');
  }

  AuthIdentity? _decode(String raw) {
    final parts = raw.split('\n');
    if (parts.length < 3) return null;
    return AuthIdentity(
      id: parts[0],
      email: parts[1],
      displayName: parts[2],
      emailVerified: parts.length > 3 ? parts[3] == 'true' : true,
      providerId: parts.length > 4 ? parts[4] : 'password',
      avatarUrl: parts.length > 5 && parts[5].isNotEmpty ? parts[5] : null,
    );
  }

  String _stableId(String email, String prefix) {
    final slug = email
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return '$prefix-${slug.isEmpty ? 'local-user' : slug}';
  }

  String _nameFromEmail(String email) {
    final name = email.split('@').first.replaceAll('.', ' ').trim();
    if (name.isEmpty) return 'MiniAdımlar';
    return name
        .split(RegExp(r'\s+'))
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }
}

class FirebaseAuthGateway implements AuthGateway {
  FirebaseAuthGateway({firebase_auth.FirebaseAuth? auth})
    : _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _auth;
  bool _googleInitialized = false;
  LocalAuthGateway? _developerFallbackAuth;

  @override
  AuthIdentity? get currentUser => _fromFirebaseUser(_auth.currentUser);

  Future<void> _ensureGoogleInitialized() async {
    if (kIsWeb || _googleInitialized) return;
    await GoogleSignIn.instance.initialize(clientId: _googleClientId);
    _googleInitialized = true;
  }

  @override
  Future<AuthIdentity?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = firebase_auth.GoogleAuthProvider()
          ..addScope('email')
          ..addScope('profile');
        final credential = await _auth.signInWithPopup(provider);
        return _fromFirebaseUser(credential.user);
      }

      await _ensureGoogleInitialized();
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      return _fromFirebaseUser(result.user);
    } catch (error) {
      return _developerGoogleFallback(error);
    }
  }

  @override
  Future<AuthIdentity?> signInWithApple() async {
    try {
      if (kIsWeb) {
        final provider = firebase_auth.OAuthProvider('apple.com')
          ..addScope('email')
          ..addScope('name');
        final result = await _auth.signInWithPopup(provider);
        return _fromFirebaseUser(result.user);
      }

      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        throw const SignInWithAppleNotSupportedException(
          message: 'Sign in with Apple is not available on this device.',
        );
      }
      final rawNonce = _generateNonce();
      final nonce = _sha256OfString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = firebase_auth.OAuthProvider(
        'apple.com',
      ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);
      final result = await _auth.signInWithCredential(oauthCredential);
      final user = result.user;
      final displayName = [
        appleCredential.givenName,
        appleCredential.familyName,
      ].where((part) => part != null && part.trim().isNotEmpty).join(' ');
      if (user != null &&
          displayName.trim().isNotEmpty &&
          (user.displayName == null || user.displayName!.trim().isEmpty)) {
        await user.updateDisplayName(displayName.trim());
        await user.reload();
      }
      return _fromFirebaseUser(_auth.currentUser ?? user);
    } catch (error) {
      return _developerAppleFallback(error);
    }
  }

  @override
  Future<AuthIdentity?> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _fromFirebaseUser(result.user);
  }

  @override
  Future<AuthIdentity?> createWithEmail(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _fromFirebaseUser(result.user);
  }

  @override
  Future<AuthIdentity?> refreshCurrentUser() async {
    await _auth.currentUser?.reload();
    return _fromFirebaseUser(_auth.currentUser);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> deleteCurrentUser() async {
    await _auth.currentUser?.delete();
  }

  @override
  Future<void> signOut() async {
    if (!kIsWeb && _googleInitialized) {
      await GoogleSignIn.instance.signOut();
    }
    await _auth.signOut();
  }

  AuthIdentity? _fromFirebaseUser(firebase_auth.User? user) {
    if (user == null) return null;
    final providerIds = user.providerData
        .map((item) => item.providerId)
        .toSet();
    final federatedVerified =
        providerIds.contains('google.com') || providerIds.contains('apple.com');
    final providerId = providerIds.isEmpty ? 'password' : providerIds.first;
    return AuthIdentity(
      id: user.uid,
      email: user.email ?? '',
      displayName: (user.displayName ?? user.email ?? 'MiniAdımlar').trim(),
      emailVerified: user.emailVerified || federatedVerified,
      providerId: providerId,
      avatarUrl: user.photoURL,
    );
  }

  String? get _googleClientId {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return DefaultFirebaseOptions.ios.iosClientId;
    }
    return null;
  }

  bool get _allowDeveloperAuthFallback {
    return kDebugMode || const bool.fromEnvironment('ALLOW_LOCAL_AUTH_FALLBACK');
  }

  Future<AuthIdentity?> _developerGoogleFallback(Object error) async {
    if (!_allowDeveloperAuthFallback || _isUserCancelledGoogleSignIn(error)) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    debugPrint('Google sign-in fell back to local debug auth: $error');
    final fallback = await _developerFallback();
    return fallback.signInWithGoogle();
  }

  Future<AuthIdentity?> _developerAppleFallback(Object error) async {
    if (!_allowDeveloperAuthFallback || _isUserCancelledAppleSignIn(error)) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    debugPrint('Apple sign-in fell back to local debug auth: $error');
    final fallback = await _developerFallback();
    return fallback.signInWithApple();
  }

  Future<LocalAuthGateway> _developerFallback() async {
    return _developerFallbackAuth ??= await LocalAuthGateway.create();
  }

  bool _isUserCancelledGoogleSignIn(Object error) {
    return error is GoogleSignInException &&
        error.code == GoogleSignInExceptionCode.canceled;
  }

  bool _isUserCancelledAppleSignIn(Object error) {
    return error is SignInWithAppleAuthorizationException &&
        error.code == AuthorizationErrorCode.canceled;
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256OfString(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
