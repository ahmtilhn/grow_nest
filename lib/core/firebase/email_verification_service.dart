import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class EmailVerificationState {
  const EmailVerificationState({
    required this.verified,
    this.cooldownSeconds = 0,
    this.remainingAttempts,
    this.message,
  });

  final bool verified;
  final int cooldownSeconds;
  final int? remainingAttempts;
  final String? message;
}

abstract class EmailVerificationService {
  bool get isEnabled;
  Future<EmailVerificationState> requestCode();
  Future<EmailVerificationState> verifyCode(String code);
}

class NoopEmailVerificationService implements EmailVerificationService {
  const NoopEmailVerificationService();

  @override
  bool get isEnabled => false;

  @override
  Future<EmailVerificationState> requestCode() async {
    return const EmailVerificationState(verified: true);
  }

  @override
  Future<EmailVerificationState> verifyCode(String code) async {
    return const EmailVerificationState(verified: true);
  }
}

class FirebaseEmailVerificationService implements EmailVerificationService {
  FirebaseEmailVerificationService({firebase_auth.FirebaseAuth? auth})
    : _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _auth;

  @override
  bool get isEnabled => true;

  @override
  Future<EmailVerificationState> requestCode() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'not-authenticated',
        message: 'Önce giriş yapmalısınız.',
      );
    }

    await user.reload();
    final refreshedUser = _auth.currentUser;
    if (refreshedUser?.emailVerified == true) {
      return const EmailVerificationState(verified: true);
    }

    await refreshedUser?.sendEmailVerification();
    return const EmailVerificationState(
      verified: false,
      cooldownSeconds: 60,
      message: 'Doğrulama bağlantısı e-posta adresine gönderildi.',
    );
  }

  @override
  Future<EmailVerificationState> verifyCode(String code) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'not-authenticated',
        message: 'Önce giriş yapmalısınız.',
      );
    }

    await user.reload();
    return EmailVerificationState(
      verified: _auth.currentUser?.emailVerified == true,
    );
  }
}
