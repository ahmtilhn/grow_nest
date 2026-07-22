import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/insights/care_insights.dart';
import '../../core/utils/app_calculators.dart';
import '../../core/widgets/baby_status_widget_service.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class BabyDashboardScreen extends ConsumerWidget {
  const BabyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appControllerRevisionProvider);
    final snapshot = ref.watch(appSnapshotProvider);
    final baby = snapshot.baby;
    final insights = CareRecordInsights(records: snapshot.records);
    final name = baby?.name ?? 'Bebek profili';
    final age = baby == null
        ? 'Bilgiler tamamlanınca yaş görünür'
        : AgeUtils.babyAge(baby.birthDate, DateTime.now());
    final feeding = insights.latest(RecordType.feeding);
    final diaper = insights.latest(RecordType.diaper);
    final sleep = insights.latest(RecordType.sleep);
    final health = insights.latest(RecordType.health);
    final measurement = insights.latestGrowthMeasurement(baby);
    final ageMonths = baby == null
        ? 0
        : DateTime.now().difference(baby.birthDate).inDays ~/ 30;
    final weight = measurement.weightKg;
    final height = measurement.heightCm;
    final head = measurement.headCm;
    final sleepMinutes = insights.sleepMinutesLast24Hours();
    final feedingCount = insights.countToday(RecordType.feeding);
    final diaperCount = insights.countToday(RecordType.diaper);
    final nextVaccine = insights.nextVaccine(snapshot.vaccines);
    return AppScreen(
      bottomPadding: 120,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(age, style: const TextStyle(color: AppColors.muted)),
                ],
              ),
            ),
            const Chip(label: Text('BUGÜNKÜ ÖZET')),
          ],
        ),
        const SizedBox(height: 18),
        AppCard(
          child: Row(
            children: [
              const SoftIcon(
                icon: Icons.insights_rounded,
                color: AppColors.accent,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  _dailySummaryText(
                    feedingCount: feedingCount,
                    diaperCount: diaperCount,
                    sleepMinutes: sleepMinutes,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Detaylı bakım özeti',
                onPressed: () => context.push('/insights'),
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _WidgetToolbar(),
        if (health != null) ...[
          const SizedBox(height: 12),
          const MedicalWarningCard(),
        ],
        if (nextVaccine != null) ...[
          const SizedBox(height: 12),
          AppCard(
            color: AppColors.softBlue,
            borderColor: const Color(0xFFD7E8F8),
            onTap: () => context.push('/vaccines'),
            child: Row(
              children: [
                const SoftIcon(
                  icon: Icons.vaccines_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sıradaki aşı: ${nextVaccine.title}\n${nextVaccine.dueDate.day}.${nextVaccine.dueDate.month}.${nextVaccine.dueDate.year}',
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _LastCard(
                icon: Icons.restaurant_rounded,
                title: 'SON BESLENME',
                value: feeding == null ? '--:--' : _timeAgo(feeding.occurredAt),
                color: AppColors.softBlue,
                onTap: () => context.push('/add/${RecordType.feeding.name}'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _LastCard(
                icon: Icons.baby_changing_station_rounded,
                title: 'SON BEZ',
                value: diaper == null ? '--:--' : _timeAgo(diaper.occurredAt),
                color: AppColors.softPink,
                onTap: () => context.push('/add/${RecordType.diaper.name}'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _LastCard(
          icon: Icons.nightlight_round,
          title: 'SON UYKU',
          value: sleep == null ? '--:--' : _timeAgo(sleep.occurredAt),
          color: AppColors.softGreen,
          onTap: () => context.push('/sleep'),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _GrowthMetricCard(
                title: 'Kilo',
                value: weight,
                ageMonths: ageMonths,
                metric: GrowthMetric.weight,
                icon: Icons.monitor_weight_outlined,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _GrowthMetricCard(
                title: 'Boy',
                value: height,
                ageMonths: ageMonths,
                metric: GrowthMetric.height,
                icon: Icons.height_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _GrowthMetricCard(
          title: 'Baş çevresi',
          value: head,
          ageMonths: ageMonths,
          metric: GrowthMetric.headCircumference,
          icon: Icons.face_retouching_natural_rounded,
          wide: true,
        ),
        const SizedBox(height: 18),
        const SectionHeader(title: 'Hızlı Kayıt'),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          childAspectRatio: 1.35,
          children: [
            _QuickButton('BESLE', Icons.restaurant_rounded, () {
              context.push('/add/${RecordType.feeding.name}');
            }),
            _QuickButton('ALT DEĞİŞ', Icons.baby_changing_station_rounded, () {
              context.push('/add/${RecordType.diaper.name}');
            }),
            _QuickButton(
              'UYKU',
              Icons.nightlight_round,
              () => context.push('/sleep'),
            ),
            _QuickButton('ÖLÇÜM', Icons.straighten_rounded, () {
              context.push('/add/${RecordType.growth.name}');
            }),
          ],
        ),
        const SizedBox(height: 18),
        AppCard(
          color: AppColors.primary,
          borderColor: AppColors.primary,
          onTap: () => context.push('/sleep'),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'UYKU RİTMİ\nBugünkü uyku: ${sleepMinutes ~/ 60}s ${sleepMinutes % 60}dk\nYaşa göre hedef: ${SleepRoutineGuide.expectedRangeLabel(ageMonths)}',
                  style: const TextStyle(color: Colors.white, height: 1.4),
                ),
              ),
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.nightlight_round, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          color: AppColors.softPink,
          borderColor: const Color(0xFFFAD2E1),
          onTap: () => context.push('/education'),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/crib.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  '"Tummy Time" boyun kaslarını güçlendirebilir. Her bebek farklıdır; doktor önerisi önceliklidir.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _timeAgo(DateTime time) {
    final minutes = DateTime.now().difference(time).inMinutes.clamp(0, 9999);
    if (minutes < 60) return '$minutes dk önce';
    return '${minutes ~/ 60}:${(minutes % 60).toString().padLeft(2, '0')}';
  }

  String _dailySummaryText({
    required int feedingCount,
    required int diaperCount,
    required int sleepMinutes,
  }) {
    if (feedingCount == 0 && diaperCount == 0 && sleepMinutes == 0) {
      return 'Kayıt özeti beslenme, bez ve uyku bilgileri geldikçe güncellenecek.';
    }
    final sleepText = sleepMinutes <= 0
        ? 'uyku kaydı yok'
        : '${sleepMinutes ~/ 60}s ${sleepMinutes % 60}dk uyku';
    return 'Bugünkü özet: $feedingCount beslenme, $diaperCount bez, $sleepText. Tek gün değil, sakin trend takibi önemlidir.';
  }
}

class _LastCard extends StatelessWidget {
  const _LastCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: color,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SoftIcon(icon: icon, color: Colors.white, size: 34),
              const Spacer(),
              const Icon(Icons.add_circle_outline_rounded),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _WidgetToolbar extends ConsumerWidget {
  const _WidgetToolbar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appControllerRevisionProvider);
    final controller = ref.read(appControllerProvider);
    final mlOptions = controller.widgetFeedingMlOptions;
    return AppCard(
      color: const Color(0xFFEAF7FA),
      borderColor: const Color(0xFFCFEAF0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SoftIcon(icon: Icons.widgets_rounded),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Widgetlar\nAna ekran bakım kumandası ve kilit ekranı özeti.',
                ),
              ),
              IconButton(
                tooltip: 'Ana ekrana ekle',
                onPressed: () => _requestWidget(context),
                icon: const Icon(Icons.add_to_home_screen_rounded),
              ),
              IconButton(
                tooltip: controller.lockScreenSummaryEnabled
                    ? 'Kilit ekranı özetini kapat'
                    : 'Kilit ekranında göster',
                onPressed: () => _toggleLockScreenSummary(context, controller),
                icon: Icon(
                  controller.lockScreenSummaryEnabled
                      ? Icons.lock_open_rounded
                      : Icons.lock_clock_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .74),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: const Color(0xFFCFEAF0)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Beslenme ml seçenekleri',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                for (final amount in mlOptions) ...[
                  _MlPill(amount),
                  const SizedBox(width: 6),
                ],
                IconButton(
                  tooltip: 'Ml seçeneklerini düzenle',
                  onPressed: () => _editFeedingOptions(context, controller),
                  icon: const Icon(Icons.tune_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editFeedingOptions(
    BuildContext context,
    AppController controller,
  ) async {
    final controllers = [
      for (final amount in controller.widgetFeedingMlOptions)
        TextEditingController(text: '$amount'),
    ];
    while (controllers.length < 3) {
      controllers.add(TextEditingController());
    }
    String? errorText;
    try {
      final saved = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Widget beslenme seçenekleri'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ana ekran widgetında görünecek 3 hızlı ml değerini seçin.',
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    for (var index = 0; index < 3; index++) ...[
                      Expanded(
                        child: TextField(
                          controller: controllers[index],
                          keyboardType: TextInputType.number,
                          textInputAction: index == 2
                              ? TextInputAction.done
                              : TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: InputDecoration(
                            labelText: '${index + 1}. ml',
                          ),
                        ),
                      ),
                      if (index < 2) const SizedBox(width: 10),
                    ],
                  ],
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    errorText!,
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Vazgeç'),
              ),
              FilledButton(
                onPressed: () {
                  final values = controllers
                      .map((item) => int.tryParse(item.text.trim()))
                      .whereType<int>()
                      .toList();
                  if (values.length != 3 ||
                      values.any((item) => item < 10 || item > 300)) {
                    setState(
                      () => errorText =
                          '3 değer girin. Her biri 10-300 ml aralığında olmalı.',
                    );
                    return;
                  }
                  if (values.toSet().length != 3) {
                    setState(
                      () => errorText = 'Seçenekler birbirinden farklı olmalı.',
                    );
                    return;
                  }
                  Navigator.pop(context, true);
                },
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      );
      if (saved != true) return;
      final values = controllers
          .map((item) => int.parse(item.text.trim()))
          .toList();
      await controller.setWidgetFeedingMlOptions(values);
      if (context.mounted) {
        showAppSnack(context, 'Widget ml seçenekleri güncellendi.');
      }
    } finally {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
  }

  Future<void> _requestWidget(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await BabyStatusWidgetService.requestHomeWidgetPin();
    if (!context.mounted) return;
    final message = switch (result) {
      WidgetPinResult.requested => 'Ana ekran widget ekleme penceresi açıldı.',
      WidgetPinResult.unsupported =>
        'Bu cihaz otomatik widget eklemeyi desteklemiyor. Widget listesinden MiniAdımlar’ı ekleyin.',
      WidgetPinResult.iosManual =>
        'iOS widget eklemeyi uygulama içinden otomatik başlatmıyor. Ana ekrandan MiniAdımlar widget’ını seçin.',
    };
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _toggleLockScreenSummary(
    BuildContext context,
    AppController controller,
  ) async {
    final next = !controller.lockScreenSummaryEnabled;
    try {
      await controller.setLockScreenSummaryEnabled(next);
      if (!context.mounted) return;
      showAppSnack(
        context,
        next
            ? 'Kilit ekranı özeti açıldı. Bildirim olarak kilit ekranında görünecek.'
            : 'Kilit ekranı özeti kapatıldı.',
      );
    } catch (error) {
      if (!context.mounted) return;
      showAppSnack(context, userFacingErrorMessage(error));
    }
  }
}

class _MlPill extends StatelessWidget {
  const _MlPill(this.amount);

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: const Color(0xFFCFEAF0)),
      ),
      child: Text(
        '$amount',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _GrowthMetricCard extends StatelessWidget {
  const _GrowthMetricCard({
    required this.title,
    required this.value,
    required this.ageMonths,
    required this.metric,
    required this.icon,
    this.wide = false,
  });

  final String title;
  final double? value;
  final int ageMonths;
  final GrowthMetric metric;
  final IconData icon;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final band = GrowthReference.bandFor(ageMonths: ageMonths, metric: metric);
    final status = band.compare(value);
    final displayValue = value == null
        ? '--'
        : '${value!.toStringAsFixed(metric == GrowthMetric.weight ? 1 : 0)} ${band.unit}';
    final point = value == null
        ? 0.0
        : ((value! - band.p3) / (band.p97 - band.p3)).clamp(0.0, 1.0);
    return AppCard(
      onTap: () => GoRouter.of(context).push('/add/${RecordType.growth.name}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SoftIcon(icon: icon, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                displayValue,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PercentileRail(
            point: point,
            band: band,
            metric: metric,
            value: value,
            wide: wide,
          ),
          Text(
            GrowthReference.message(status),
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _PercentileRail extends StatelessWidget {
  const _PercentileRail({
    required this.point,
    required this.band,
    required this.metric,
    required this.value,
    required this.wide,
  });

  final double point;
  final GrowthBand band;
  final GrowthMetric metric;
  final double? value;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final decimals = metric == GrowthMetric.weight ? 1 : 0;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: point),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, animatedPoint, _) {
        return SizedBox(
          height: wide ? 120 : 112,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _BandLabel('P3', band.p3, band.unit, decimals),
                  ),
                  Expanded(
                    child: _BandLabel('P50', band.p50, band.unit, decimals),
                  ),
                  Expanded(
                    child: _BandLabel('P97', band.p97, band.unit, decimals),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final markerLeft =
                      (constraints.maxWidth - 28) * animatedPoint;
                  return SizedBox(
                    height: 34,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 14,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: const LinearProgressIndicator(
                              value: 1,
                              minHeight: 10,
                              backgroundColor: AppColors.softPink,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.softGreen,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: constraints.maxWidth * .48,
                          top: 7,
                          child: Container(
                            width: 3,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: .45),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        Positioned(
                          left: markerLeft,
                          top: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: value == null
                                  ? AppColors.muted
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .12),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Alt',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Medyan',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Üst',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BandLabel extends StatelessWidget {
  const _BandLabel(this.label, this.value, this.unit, this.decimals);

  final String label;
  final double value;
  final String unit;
  final int decimals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          '${value.toStringAsFixed(decimals)}$unit',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 9),
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget {
  const _QuickButton(this.label, this.icon, this.onTap);

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.softBlue,
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9.5, height: 1.05),
          ),
        ],
      ),
    );
  }
}
