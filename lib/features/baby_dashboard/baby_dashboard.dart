import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/app_calculators.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class BabyDashboardScreen extends ConsumerWidget {
  const BabyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appSnapshotProvider);
    final controller = ref.read(appControllerProvider);
    final snapshot = controller.snapshot;
    final baby = snapshot.baby;
    final name = baby?.name ?? 'Bebek profili';
    final age = baby == null
        ? 'Bilgiler tamamlanınca yaş görünür'
        : AgeUtils.babyAge(baby.birthDate, DateTime.now());
    final feeding = _latest(snapshot.records, RecordType.feeding);
    final diaper = _latest(snapshot.records, RecordType.diaper);
    final sleep = _latest(snapshot.records, RecordType.sleep);
    final health = _latest(snapshot.records, RecordType.health);
    final growth = _latest(snapshot.records, RecordType.growth);
    final measurement = GrowthMeasurement.parse(growth?.value);
    final ageMonths = baby == null
        ? 0
        : DateTime.now().difference(baby.birthDate).inDays ~/ 30;
    final weight = measurement.weightKg ?? baby?.currentWeight;
    final height = measurement.heightCm ?? baby?.currentHeight;
    final head = measurement.headCm ?? baby?.currentHeadCircumference;
    final sleepMinutes = _sleepMinutesLastDay(snapshot.records);
    final feedingCount = snapshot.records
        .where((record) => record.type == RecordType.feeding)
        .length;
    final diaperCount = snapshot.records
        .where((record) => record.type == RecordType.diaper)
        .length;
    final nextVaccine = snapshot.vaccines
        .where((item) => item.status != VaccineStatus.completed)
        .cast<VaccineEvent?>()
        .firstWhere((item) => item != null, orElse: () => null);
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
            ],
          ),
        ),
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

  TrackerRecord? _latest(List<TrackerRecord> records, RecordType type) {
    final filtered = records.where((record) => record.type == type);
    return filtered.isEmpty ? null : filtered.first;
  }

  String _timeAgo(DateTime time) {
    final minutes = DateTime.now().difference(time).inMinutes.clamp(0, 9999);
    if (minutes < 60) return '$minutes dk önce';
    return '${minutes ~/ 60}:${(minutes % 60).toString().padLeft(2, '0')}';
  }

  int _sleepMinutesLastDay(List<TrackerRecord> records) {
    final since = DateTime.now().subtract(const Duration(hours: 24));
    var total = 0;
    for (final record in records) {
      if (record.type != RecordType.sleep ||
          record.occurredAt.isBefore(since)) {
        continue;
      }
      final value = record.value ?? '';
      final match = RegExp(r'(\d+)\s*dk').firstMatch(value);
      if (match != null) total += int.parse(match.group(1)!);
    }
    return total;
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
