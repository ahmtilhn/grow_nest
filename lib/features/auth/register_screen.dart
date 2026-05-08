import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/app_calculators.dart';
import '../../core/widgets/app_ui.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(appControllerProvider)
          .registerWithEmail(
            name: _name.text,
            email: _email.text,
            password: _password.text,
          );
      if (mounted) showAppSnack(context, 'Hesap oluşturuldu.');
    } catch (error) {
      if (mounted) showAppSnack(context, userFacingErrorMessage(error));
    } finally {
      if (mounted) setState(() => _saving = false);
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
          const CircleAvatar(
            radius: 38,
            backgroundColor: AppColors.accent,
            child: Icon(
              Icons.child_care_rounded,
              color: AppColors.primary,
              size: 38,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Kayıt Ol',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const Text(
            'Ebeveynlik yolculuğunu güvenli ve sade bir akışla başlat.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 22),
          AppCard(
            radius: AppRadius.xl,
            padding: const EdgeInsets.all(22),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _name,
                    label: 'AD SOYAD',
                    hint: 'Anne Aras Yılmaz',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (value) =>
                        (value ?? '').trim().isEmpty ? 'Ad soyad girin.' : null,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _email,
                    label: 'E-POSTA ADRESİ',
                    hint: 'ornek@email.com',
                    prefixIcon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        ValidationUtils.validEmail(value ?? '')
                        ? null
                        : 'Geçerli e-posta girin.',
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _password,
                    label: 'ŞİFRE',
                    obscureText: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: (value) => (value ?? '').length >= 6
                        ? null
                        : 'En az 6 karakter girin.',
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: _saving ? null : _register,
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Hesabımı Oluştur'),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Hesabınız var mı? Giriş Yap'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            color: AppColors.softBlue,
            borderColor: const Color(0xFFD8EAF8),
            child: Row(
              children: [
                const SoftIcon(
                  icon: Icons.notifications_active_outlined,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Hatırlatıcılar ve aile davetleri uygulama içinde görünür; e-posta daveti zorunlu değildir.',
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
