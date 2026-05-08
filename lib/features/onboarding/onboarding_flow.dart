import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_controller.dart';
import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/app_calculators.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final _pageController = PageController();
  late final TextEditingController _nameController;
  final _babyNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _headController = TextEditingController();
  CareMode _mode = CareMode.pregnancy;
  DateTime _date = DateTime.now().add(const Duration(days: 196));
  bool _acceptedMedical = false;
  bool _acceptedPrivacy = false;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    final userName = ref.read(appControllerProvider).snapshot.user?.name.trim();
    _nameController = TextEditingController(
      text: userName == null || userName.isEmpty ? '' : userName,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _babyNameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _headController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_index == 1 && (!_acceptedMedical || !_acceptedPrivacy)) {
      showAppSnack(
        context,
        'Devam etmek için güvenlik onaylarını işaretleyin.',
      );
      return;
    }
    if (_index < 2) {
      setState(() => _index++);
      await _pageController.animateToPage(
        _index,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
      return;
    }
    final controller = ref.read(appControllerProvider);
    if (_mode == CareMode.baby) {
      await controller.completeBabyOnboarding(
        parentName: _nameController.text,
        babyName: _babyNameController.text,
        birthDate: _date,
        weight: ValidationUtils.positiveDouble(_weightController.text),
        height: ValidationUtils.positiveDouble(_heightController.text),
        headCircumference: ValidationUtils.positiveDouble(_headController.text),
      );
    } else if (_mode == CareMode.planning) {
      await controller.completePlanningOnboarding(
        parentName: _nameController.text,
      );
    } else {
      await controller.completePregnancyOnboarding(
        parentName: _nameController.text,
        dueDate: _date,
      );
    }
    if (mounted) showAppSnack(context, 'Kurulum tamamlandı.');
  }

  Future<void> _back() async {
    if (_index == 0) return;
    setState(() => _index--);
    await _pageController.animateToPage(
      _index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: _index == 0
            ? null
            : IconButton(
                tooltip: 'Geri',
                onPressed: _back,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
        title: Text(l10n.t('appName')),
        actions: [
          TextButton(
            onPressed: () => ref
                .read(appControllerProvider)
                .setLocale(
                  ref.read(appControllerProvider).snapshot.localeCode == 'tr'
                      ? 'en'
                      : 'tr',
                ),
            child: Text(
              ref.watch(appSnapshotProvider).localeCode == 'tr'
                  ? 'EN'
                  : 'TR',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _PurposeStep(
                    mode: _mode,
                    onChanged: (mode) {
                      setState(() {
                        _mode = mode;
                        _date = mode == CareMode.baby
                            ? DateTime.now().subtract(const Duration(days: 102))
                            : DateTime.now().add(const Duration(days: 196));
                      });
                    },
                  ),
                  _ConsentStep(
                    acceptedMedical: _acceptedMedical,
                    acceptedPrivacy: _acceptedPrivacy,
                    onMedical: (value) =>
                        setState(() => _acceptedMedical = value),
                    onPrivacy: (value) =>
                        setState(() => _acceptedPrivacy = value),
                  ),
                  _ProfileStep(
                    mode: _mode,
                    date: _date,
                    nameController: _nameController,
                    babyNameController: _babyNameController,
                    weightController: _weightController,
                    heightController: _heightController,
                    headController: _headController,
                    onPickDate: _pickDate,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Row(
                children: [
                  if (_index > 0) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _back,
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('Geri'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      key: const ValueKey('onboarding_continue'),
                      onPressed: _next,
                      child: Text(
                        _index == 2 ? l10n.t('save') : l10n.t('continue'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: now.subtract(const Duration(days: 3650)),
      lastDate: now.add(const Duration(days: 320)),
    );
    if (picked != null) setState(() => _date = picked);
  }
}

class _PurposeStep extends StatelessWidget {
  const _PurposeStep({required this.mode, required this.onChanged});

  final CareMode mode;
  final ValueChanged<CareMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: context.l10n.t('onboardingTitle'),
      subtitle: 'MiniAdımlar hangi yolculuğu takip edeceğini bilsin.',
      bottomPadding: 16,
      children: [
        for (final option in [
          (
            CareMode.pregnancy,
            context.l10n.t('purposePregnancy'),
            Icons.pregnant_woman_rounded,
          ),
          (
            CareMode.baby,
            context.l10n.t('purposeBaby'),
            Icons.child_care_rounded,
          ),
          (
            CareMode.planning,
            context.l10n.t('purposePlanning'),
            Icons.favorite_border_rounded,
          ),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              color: mode == option.$1 ? AppColors.softBlue : Colors.white,
              onTap: () => onChanged(option.$1),
              child: Row(
                children: [
                  SoftIcon(icon: option.$3),
                  const SizedBox(width: 14),
                  Expanded(child: Text(option.$2)),
                  Icon(
                    mode == option.$1
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: mode == option.$1
                        ? AppColors.primary
                        : AppColors.muted,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ConsentStep extends StatelessWidget {
  const _ConsentStep({
    required this.acceptedMedical,
    required this.acceptedPrivacy,
    required this.onMedical,
    required this.onPrivacy,
  });

  final bool acceptedMedical;
  final bool acceptedPrivacy;
  final ValueChanged<bool> onMedical;
  final ValueChanged<bool> onPrivacy;

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Güvenli kullanım',
      subtitle: 'Sağlık verileri hassastır; uygulama doktor yerine geçmez.',
      bottomPadding: 16,
      children: [
        const MedicalWarningCard(),
        const SizedBox(height: 12),
        CheckboxListTile(
          value: acceptedMedical,
          onChanged: (value) => onMedical(value ?? false),
          title: const Text('Medikal uyarıyı okudum ve kabul ediyorum.'),
        ),
        CheckboxListTile(
          value: acceptedPrivacy,
          onChanged: (value) => onPrivacy(value ?? false),
          title: const Text('Gizlilik ve kullanım koşullarını kabul ediyorum.'),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => showPrivacyInfoDialog(context),
            icon: const Icon(Icons.privacy_tip_outlined),
            label: const Text('Veri paylaşımı özetini oku'),
          ),
        ),
      ],
    );
  }
}

class _ProfileStep extends StatelessWidget {
  const _ProfileStep({
    required this.mode,
    required this.date,
    required this.nameController,
    required this.babyNameController,
    required this.weightController,
    required this.heightController,
    required this.headController,
    required this.onPickDate,
  });

  final CareMode mode;
  final DateTime date;
  final TextEditingController nameController;
  final TextEditingController babyNameController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController headController;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Profil bilgileri',
      subtitle: mode == CareMode.baby
          ? 'Bebek takip panelini kişiselleştirelim.'
          : mode == CareMode.planning
          ? 'Planlama döneminde sakin rutinler ve notlar hazırlayalım.'
          : 'Gebelik haftasını ve önerileri hazırlayalım.',
      bottomPadding: 16,
      children: [
        AppTextField(controller: nameController, label: 'Ebeveyn adı'),
        const SizedBox(height: 12),
        if (mode == CareMode.baby) ...[
          AppTextField(controller: babyNameController, label: 'Bebek adı'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: weightController,
                  label: 'Kilo',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(controller: heightController, label: 'Boy'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: headController,
            label: 'Baş çevresi',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
        ],
        if (mode == CareMode.planning)
          const AppCard(
            color: AppColors.softGreen,
            borderColor: Color(0xFFD3E3DC),
            child: Text(
              'Planlama modunda gebelik haftası varsayımı yapılmaz. İstersen günlük not, randevu ve hazırlık hatırlatıcılarıyla başlayabilirsin.',
            ),
          )
        else
          AppCard(
            onTap: onPickDate,
            child: Row(
              children: [
                SoftIcon(
                  icon: mode == CareMode.baby
                      ? Icons.cake_rounded
                      : Icons.event_rounded,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    mode == CareMode.baby
                        ? 'Doğum tarihi: ${date.day}.${date.month}.${date.year}'
                        : 'Tahmini doğum: ${date.day}.${date.month}.${date.year}',
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
      ],
    );
  }
}
