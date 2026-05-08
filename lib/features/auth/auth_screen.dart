import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/app_calculators.dart';
import '../../core/widgets/app_ui.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref
          .read(appControllerProvider)
          .loginLocal(_emailController.text, _passwordController.text);
      if (mounted) showAppSnack(context, 'Giriş başarılı.');
    } catch (error) {
      if (mounted) showAppSnack(context, userFacingErrorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginGoogle() async {
    setState(() => _loading = true);
    try {
      await ref.read(appControllerProvider).loginWithGoogle();
      if (mounted) showAppSnack(context, 'Google hesabı bağlandı.');
    } catch (error) {
      if (mounted) showAppSnack(context, userFacingErrorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginApple() async {
    setState(() => _loading = true);
    try {
      await ref.read(appControllerProvider).loginWithApple();
      if (mounted) showAppSnack(context, 'Apple hesabı bağlandı.');
    } catch (error) {
      if (mounted) showAppSnack(context, userFacingErrorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: AppScreen(
          maxWidth: 460,
          bottomPadding: 36,
          children: [
            const SizedBox(height: 18),
            const CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.accent,
              child: Icon(
                Icons.child_care_rounded,
                color: AppColors.primary,
                size: 42,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.t('loginTitle'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.t('loginSubtitle'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.muted,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 42),
            AppCard(
              radius: AppRadius.xl,
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      key: const ValueKey('login_email'),
                      controller: _emailController,
                      label: l10n.t('email').toUpperCase(),
                      hint: 'ornek@email.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          ValidationUtils.validEmail(value ?? '')
                          ? null
                          : 'Geçerli e-posta girin.',
                    ),
                    AppTextField(
                      key: const ValueKey('login_password'),
                      controller: _passwordController,
                      label: l10n.t('password').toUpperCase(),
                      obscureText: true,
                      validator: (value) => (value ?? '').length >= 6
                          ? null
                          : 'En az 6 karakter girin.',
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: Text(l10n.t('forgotPassword')),
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      key: const ValueKey('login_button'),
                      onPressed: _loading ? null : _login,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.t('login')),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(l10n.t('or').toUpperCase()),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: _loading ? null : _loginGoogle,
                      icon: const _GoogleMark(),
                      label: Text(l10n.t('continueWithGoogle')),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _loading ? null : _loginApple,
                      icon: const Icon(Icons.apple_rounded),
                      label: const Text('Apple ile devam et'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Giriş zorunludur; veriler hesabınıza bağlanır ve aile paylaşımı yalnız yetkili üyelerle senkronlanır.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => context.push('/register'),
              child: Text('Henüz hesabınız yok mu? ${l10n.t('register')}'),
            ),
            const SpacerCard(),
          ],
        ),
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
    );
  }
}

class SpacerCard extends StatelessWidget {
  const SpacerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.softPink,
      borderColor: const Color(0xFFFAD2E1),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/apple.png',
              width: 46,
              height: 46,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Haftalık takip: bebeğinizin gelişimini güvenli, yerel ve sade biçimde izleyin.',
            ),
          ),
        ],
      ),
    );
  }
}
