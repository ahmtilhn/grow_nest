import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/app_calculators.dart';
import '../../core/widgets/app_ui.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!ValidationUtils.validEmail(_email.text)) {
      showAppSnack(context, 'Geçerli bir e-posta girin.');
      return;
    }
    setState(() => _sending = true);
    try {
      await ref.read(appControllerProvider).sendPasswordResetEmail(_email.text);
      if (mounted) {
        showAppSnack(context, 'Şifre sıfırlama bağlantısı gönderildi.');
      }
    } catch (error) {
      if (mounted) showAppSnack(context, userFacingErrorMessage(error));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('MiniAdımlar'),
      ),
      body: AppScreen(
        maxWidth: 460,
        bottomPadding: 32,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/room_plant.png',
                width: 168,
                height: 168,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Şifremi Unuttum',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const Text(
            'Endişelenmeyin, her ebeveynin başına gelebilir. E-posta adresinizi girin, bağlantıyı gönderelim.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 24),
          AppCard(
            radius: AppRadius.xl,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _email,
                  label: 'E-POSTA ADRESİ',
                  hint: 'ornek@ebeveyn.com',
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _sending ? null : _send,
                  icon: const Icon(Icons.send_rounded),
                  label: Text(
                    _sending ? 'Gönderiliyor' : 'Sıfırlama Bağlantısı Gönder',
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Hatırladınız mı? Giriş Yapın'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const AppCard(
            color: AppColors.softPink,
            borderColor: Color(0xFFFAD2E1),
            child: Row(
              children: [
                SoftIcon(
                  icon: Icons.lightbulb_outline_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Bağlantı güvenlik nedeniyle kısa süre içinde geçerliliğini yitirebilir.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
