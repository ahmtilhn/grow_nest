import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/app_ui.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  final _code = TextEditingController();
  bool _verifying = false;
  bool _resending = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_verifying) return;
    setState(() => _verifying = true);
    try {
      final verified = await ref
          .read(appControllerProvider)
          .verifyEmailCode(_code.text);
      if (!mounted) return;
      if (verified) {
        showAppSnack(context, 'E-posta doğrulandı.');
        context.go('/growth');
      } else {
        showAppSnack(context, 'Kod doğrulanamadı. Süresi dolmuş olabilir.');
      }
    } catch (error) {
      if (mounted) showAppSnack(context, userFacingErrorMessage(error));
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _resend() async {
    if (_resending) return;
    setState(() => _resending = true);
    try {
      await ref.read(appControllerProvider).resendEmailVerificationCode();
      if (mounted) showAppSnack(context, 'Doğrulama kodu tekrar gönderildi.');
    } catch (error) {
      if (mounted) showAppSnack(context, userFacingErrorMessage(error));
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(appSnapshotProvider);
    final email = snapshot.user?.email ?? 'e-posta adresiniz';
    return Scaffold(
      body: SafeArea(
        child: AppScreen(
          maxWidth: 460,
          bottomPadding: 32,
          children: [
            const SizedBox(height: 24),
            const CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.softBlue,
              child: Icon(
                Icons.mark_email_read_outlined,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'E-postanı doğrula',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              '$email adresine gönderilen 6 haneli kodu gir. Verilerini güvenli şekilde buluta bağlamadan ana ekrana geçmiyoruz.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, height: 1.35),
            ),
            const SizedBox(height: 26),
            AppCard(
              radius: AppRadius.xl,
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    key: const ValueKey('email_verification_code'),
                    controller: _code,
                    label: 'DOĞRULAMA KODU',
                    hint: '123456',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _verifying ? null : _verify,
                    icon: _verifying
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.verified_user_outlined),
                    label: const Text('Doğrula ve devam et'),
                  ),
                  TextButton(
                    onPressed: _resending ? null : _resend,
                    child: Text(
                      _resending
                          ? 'Kod gönderiliyor...'
                          : 'Doğrulama kodunu tekrar gönder',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              color: AppColors.softGreen,
              borderColor: const Color(0xFFD3E3DC),
              child: Row(
                children: const [
                  SoftIcon(
                    icon: Icons.cloud_done_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Doğrulama tamamlanmadan aile, bebek ve bakım kaydı oluşturulmaz.',
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(appControllerProvider).logout();
                if (context.mounted) context.go('/login');
              },
              child: const Text('Farklı hesapla giriş yap'),
            ),
          ],
        ),
      ),
    );
  }
}
