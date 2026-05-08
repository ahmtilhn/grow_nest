import 'package:cloud_functions/cloud_functions.dart';

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
  FirebaseEmailVerificationService({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  @override
  bool get isEnabled => true;

  @override
  Future<EmailVerificationState> requestCode() async {
    final result = await _functions
        .httpsCallable('requestEmailVerificationCode')
        .call<Map<String, dynamic>>();
    return _stateFrom(result.data);
  }

  @override
  Future<EmailVerificationState> verifyCode(String code) async {
    final result = await _functions
        .httpsCallable('verifyEmailCode')
        .call<Map<String, dynamic>>({'code': code.trim()});
    return _stateFrom(result.data);
  }

  EmailVerificationState _stateFrom(Map<String, dynamic> data) {
    return EmailVerificationState(
      verified: data['verified'] == true,
      cooldownSeconds: (data['cooldownSeconds'] as num?)?.toInt() ?? 0,
      remainingAttempts: (data['remainingAttempts'] as num?)?.toInt(),
      message: data['message'] as String?,
    );
  }
}
