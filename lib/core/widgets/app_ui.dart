import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_theme.dart';

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.color = AppColors.surface,
    this.borderColor = AppColors.border,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.radius = AppRadius.lg,
    this.onTap,
  });

  final Widget child;
  final Color color;
  final Color borderColor;
  final EdgeInsets padding;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDefaultSurface = color == AppColors.surface;
    final resolvedColor = isDefaultSurface ? theme.cardColor : color;
    final resolvedBorder = isDefaultSurface
        ? theme.colorScheme.outlineVariant
        : borderColor;
    final content = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: resolvedBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? .18 : .035,
            ),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(type: MaterialType.transparency, child: child),
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.children,
    this.title,
    this.subtitle,
    this.bottomPadding = 112,
    this.maxWidth = 640,
  });

  final String? title;
  final String? subtitle;
  final List<Widget> children;
  final double bottomPadding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 22, 20, bottomPadding),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.muted,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                ],
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.maxLines = 1,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
      ),
    );
  }
}

class SoftIcon extends StatelessWidget {
  const SoftIcon({
    super.key,
    required this.icon,
    this.color = AppColors.softBlue,
    this.iconColor = AppColors.primary,
    this.size = 42,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * .3),
      ),
      child: Icon(icon, color: iconColor, size: size * .48),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.softBlue,
      borderColor: const Color(0xFFD7E8F8),
      child: Column(
        children: [
          SoftIcon(icon: icon, color: Colors.white, size: 56),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class MedicalWarningCard extends StatelessWidget {
  const MedicalWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.warning,
      borderColor: const Color(0xFFFFC9C9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SoftIcon(
            icon: Icons.medical_services_outlined,
            color: Colors.white,
            iconColor: AppColors.danger,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.t('medicalDisclaimer'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryDark,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

void showAppSnack(BuildContext context, String message) {
  final messenger =
      rootScaffoldMessengerKey.currentState ??
      ScaffoldMessenger.maybeOf(context);
  if (messenger == null) {
    debugPrint('SnackBar skipped because no ScaffoldMessenger is available.');
    return;
  }
  messenger.showSnackBar(SnackBar(content: Text(message)));
}

String userFacingErrorMessage(Object error) {
  final raw = error.toString();
  final lower = raw.toLowerCase();
  if (lower.contains('user-not-found') ||
      lower.contains('wrong-password') ||
      lower.contains('invalid-credential')) {
    return 'E-posta veya şifreyi kontrol edip tekrar deneyin.';
  }
  if (lower.contains('email-already-in-use')) {
    return 'Bu e-posta ile bir hesap zaten var. Giriş yapmayı deneyin.';
  }
  if (lower.contains('weak-password')) {
    return 'Daha güçlü bir şifre seçin. En az 6 karakter kullanın.';
  }
  if (lower.contains('network-request-failed') ||
      lower.contains('unavailable')) {
    return 'Bağlantı kurulamadı. İnternetinizi kontrol edip tekrar deneyin.';
  }
  if (lower.contains('too-many-requests')) {
    return 'Kısa sürede çok deneme yapıldı. Biraz bekleyip tekrar deneyin.';
  }
  if (lower.contains('popup-closed') || lower.contains('canceled')) {
    return 'İşlem tamamlanmadı. Hazır olduğunuzda tekrar deneyebilirsiniz.';
  }
  for (final message in const [
    'Bu e-posta ile kayıtlı bir kullanıcı yok. Önce uygulamaya kayıt olmalı.',
    'Bu kullanıcı zaten başka bir aileye bağlı. Bir hesap yalnızca bir aileye eklenebilir.',
    'Bu kullanıcı zaten bu aileye eklenmiş.',
    'Bu kullanıcı için bekleyen bir davet zaten var.',
  ]) {
    if (raw.contains(message)) return message;
  }
  if (raw.startsWith('Invalid argument(s): ')) {
    return raw.replaceFirst('Invalid argument(s): ', '');
  }
  return raw.replaceFirst('Exception: ', '');
}

Future<void> showConfiguredLaterDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.l10n.t('appName')),
      content: Text(context.l10n.t('configuredLater')),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tamam'),
        ),
      ],
    ),
  );
}

Future<void> showPrivacyInfoDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Gizlilik ve veri paylaşımı'),
      content: const Text(
        'Bakım kayıtları önce bu cihazda saklanır. Oturum açıp aile paylaşımı kullanırsanız gerekli profil, bebek, kayıt, hatırlatıcı, aşı ve davet bilgileri Firebase ile senkronize edilir. Medikal notlar doktor değerlendirmesi yerine geçmez; hesabınızı silme ve oturumu kapatma işlemlerini Profil ekranından yönetebilirsiniz.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Anladım'),
        ),
      ],
    ),
  );
}
