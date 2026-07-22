import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/insights/care_insights.dart';
import '../../core/utils/app_calculators.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class CareInsightsScreen extends ConsumerWidget {
  const CareInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(appSnapshotProvider);
    final insights = CareRecordInsights(records: snapshot.records);
    final baby = snapshot.baby;
    final ageMonths = baby == null
        ? 0
        : DateTime.now().difference(baby.birthDate).inDays ~/ 30;
    final growth = insights.latestGrowthMeasurement(baby);
    final feedingTotals = insights.feedingTotalsLast7Days();
    final maxFeeding = _maxOrDefault(feedingTotals, 120);
    final nextVaccine = insights.nextVaccine(snapshot.vaccines);
    final sleepMinutes = insights.sleepMinutesLast24Hours();

    return Scaffold(
      appBar: AppBar(title: const Text('Bakım Özeti')),
      body: AppScreen(
        bottomPadding: 32,
        title: 'Bakım Özeti',
        subtitle:
            'Bugün, son 24 saat ve son 7 gün için karar almayı kolaylaştıran kısa tablo.',
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Beslenme',
                  value: '${insights.countToday(RecordType.feeding)} kayıt',
                  detail:
                      '${insights.totalMlToday(RecordType.feeding).round()} ml bugün',
                  icon: Icons.restaurant_rounded,
                  onTap: () => context.push('/add/${RecordType.feeding.name}'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  title: 'Bez',
                  value: '${insights.countToday(RecordType.diaper)} kayıt',
                  detail: _latestLabel(insights.latest(RecordType.diaper)),
                  icon: Icons.baby_changing_station_rounded,
                  color: AppColors.softPink,
                  onTap: () => context.push('/add/${RecordType.diaper.name}'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Uyku',
                  value: compactDurationLabel(sleepMinutes),
                  detail:
                      'Hedef: ${SleepRoutineGuide.expectedRangeLabel(ageMonths)}',
                  icon: Icons.nightlight_round,
                  color: AppColors.softGreen,
                  onTap: () => context.push('/sleep'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  title: '7 gün',
                  value: '${insights.recordsLast7Days()} kayıt',
                  detail: 'Aile görünürlüğüne göre',
                  icon: Icons.timeline_rounded,
                  onTap: () => context.push('/tracker'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Haftalık Beslenme'),
          const SizedBox(height: 8),
          AppCard(
            child: SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  maxY: maxFeeding * 1.2,
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 26,
                        getTitlesWidget: (value, meta) => Text(
                          _dayLabel(value.toInt()),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  barGroups: List.generate(
                    7,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: feedingTotals[index],
                          color: index == 6
                              ? AppColors.primary
                              : AppColors.accent,
                          width: 24,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Büyüme ve Aşı'),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              children: [
                _InfoRow(
                  label: 'Kilo',
                  value: growth.weightKg == null
                      ? 'Eksik'
                      : '${growth.weightKg!.toStringAsFixed(1)} kg',
                ),
                _InfoRow(
                  label: 'Boy',
                  value: growth.heightCm == null
                      ? 'Eksik'
                      : '${growth.heightCm!.toStringAsFixed(0)} cm',
                ),
                _InfoRow(
                  label: 'Baş çevresi',
                  value: growth.headCm == null
                      ? 'Eksik'
                      : '${growth.headCm!.toStringAsFixed(0)} cm',
                ),
                const Divider(),
                _InfoRow(
                  label: 'Sıradaki aşı',
                  value: nextVaccine == null
                      ? 'Tamamlanan açık kalem yok'
                      : '${nextVaccine.title} - ${_dateLabel(nextVaccine.dueDate)}',
                ),
                _InfoRow(
                  label: 'Geciken aşı',
                  value: '${insights.overdueVaccines(snapshot.vaccines)}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            color: AppColors.warning,
            borderColor: const Color(0xFFFFC9C9),
            child: const Text(
              'Bu özet tıbbi karar yerine geçmez. Ölçüm ve belirti trendlerini doktor görüşmesine hazırlık için kullanın.',
            ),
          ),
        ],
      ),
    );
  }

  static double _maxOrDefault(List<double> values, double fallback) {
    var max = 0.0;
    for (final value in values) {
      if (value > max) max = value;
    }
    return max <= 0 ? fallback : max;
  }

  static String _dayLabel(int index) {
    final date = DateTime.now().subtract(Duration(days: 6 - index));
    return '${date.day}.${date.month}';
  }

  static String _dateLabel(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  static String _latestLabel(TrackerRecord? record) {
    if (record == null) return 'Henüz kayıt yok';
    final minutes = DateTime.now().difference(record.occurredAt).inMinutes;
    if (minutes < 60) return '$minutes dk önce';
    return '${minutes ~/ 60}s önce';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    required this.onTap,
    this.color = AppColors.softBlue,
  });

  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SoftIcon(icon: icon, color: color),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            detail,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
