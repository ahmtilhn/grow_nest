import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class TrackerScreen extends ConsumerStatefulWidget {
  const TrackerScreen({super.key});

  @override
  ConsumerState<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends ConsumerState<TrackerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(appControllerProvider).refreshRemoteFamilies(force: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(appSnapshotProvider);
    final records = snapshot.records;
    final latestHealth = _latest(records, RecordType.health);
    final weeklyFeedingMl = _feedingTotalsLast7Days(records);
    final maxFeedingMl = _maxOrDefault(weeklyFeedingMl, 120);
    if (snapshot.mode == CareMode.pregnancy ||
        snapshot.mode == CareMode.planning) {
      return _PregnancyTracker(
        records: records,
        currentUser: snapshot.user,
        mode: snapshot.mode,
      );
    }
    return AppScreen(
      children: [
        AppCard(
          color: const Color(0xFF6AAFC5),
          borderColor: const Color(0xFF6AAFC5),
          onTap: () => context.push('/education'),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  'KAYNAKLI REHBER\nBugün nasıl yardımcı olabiliriz?\nBebek gelişimi, beslenme ve güvenlik konularında kayıtlarınıza eşlik eden rehberleri açabilirsiniz.',
                  style: TextStyle(color: Colors.white, height: 1.45),
                ),
              ),
              Icon(Icons.bolt_rounded, color: Colors.white54, size: 76),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _NutritionCard(
                records: records,
                onTap: () => context.push('/add/${RecordType.feeding.name}'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SolidFoodCard(
                records: records,
                onTap: () => context.push('/add/${RecordType.solidFood.name}'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Text(
                'Sağlık & Belirtiler',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            if (latestHealth != null)
              Chip(label: Text(latestHealth.value ?? latestHealth.title)),
          ],
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          childAspectRatio: 1.18,
          children: [
            _SymptomButton(
              'Ateş',
              Icons.thermostat_rounded,
              () => context.push('/add/${RecordType.health.name}'),
            ),
            _SymptomButton(
              'Kabızlık',
              Icons.accessibility_new_rounded,
              () => context.push('/add/${RecordType.health.name}'),
            ),
            _SymptomButton(
              'Aşı',
              Icons.vaccines_rounded,
              () => context.push('/vaccines'),
            ),
            _SymptomButton(
              'İlaç',
              Icons.medication_rounded,
              () => context.push('/reminder/new'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: AppCard(
                color: AppColors.softGreen,
                onTap: () => context.push('/education'),
                child: const Text(
                  'Acil Durum Rehberi\nNefes alma güçlüğü, morarma veya boğulma şüphesinde beklemeden acil destek alın. OKU →',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppCard(
                color: AppColors.softPink,
                onTap: () => context.push('/education'),
                child: const Text(
                  'Beslenme İpuçları\nEk gıdaları hazır oluş işaretleriyle ve tek tek tanıtma rehberi. OKU →',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Haftalık Beslenme Miktarı'),
        const SizedBox(height: 8),
        AppCard(
          child: SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                maxY: maxFeedingMl * 1.2,
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
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: weeklyFeedingMl[i],
                        color: i == 6 ? AppColors.primary : AppColors.softBlue,
                        width: 30,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SectionHeader(
          title: 'Son kayıtlar',
          action: 'Yeni',
          onAction: () => context.push('/add/${RecordType.feeding.name}'),
        ),
        const SizedBox(height: 8),
        if (records.isEmpty)
          EmptyState(
            icon: Icons.playlist_add_rounded,
            title: 'Henüz kayıt yok',
            body: 'İlk beslenme, bez, uyku veya sağlık kaydını ekleyin.',
            actionLabel: 'Kayıt Ekle',
            onAction: () => context.push('/add/${RecordType.feeding.name}'),
          )
        else
          for (final record in records.take(5))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SoftIcon(icon: _icon(record.type)),
                  title: Text(record.title),
                  subtitle: Text(
                    _recordSubtitle(
                      record,
                      snapshot.user,
                      record.value ?? record.type.name,
                    ),
                  ),
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () => context.push(_editRecordRoute(record)),
                ),
              ),
            ),
      ],
    );
  }

  IconData _icon(RecordType type) => switch (type) {
    RecordType.feeding => Icons.restaurant_rounded,
    RecordType.diaper => Icons.baby_changing_station_rounded,
    RecordType.sleep => Icons.nightlight_round,
    RecordType.growth => Icons.straighten_rounded,
    RecordType.health => Icons.medical_services_outlined,
    _ => Icons.edit_note_rounded,
  };

  List<double> _feedingTotalsLast7Days(List<TrackerRecord> records) {
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));
    final totals = List<double>.filled(7, 0);
    for (final record in records) {
      if (record.type != RecordType.feeding) continue;
      final day = DateTime(
        record.occurredAt.year,
        record.occurredAt.month,
        record.occurredAt.day,
      );
      final index = day.difference(start).inDays;
      if (index < 0 || index >= totals.length) continue;
      totals[index] += _mlFromValue(record.value);
    }
    return totals;
  }

  double _mlFromValue(String? value) {
    if (value == null) return 0;
    final match = RegExp(r'(\d+(?:[,.]\d+)?)').firstMatch(value);
    if (match == null) return 0;
    return double.tryParse(match.group(1)!.replaceAll(',', '.')) ?? 0;
  }

  double _maxOrDefault(List<double> values, double fallback) {
    var max = 0.0;
    for (final value in values) {
      if (value > max) max = value;
    }
    return max <= 0 ? fallback : max;
  }

  String _dayLabel(int index) {
    final date = DateTime.now().subtract(Duration(days: 6 - index));
    return '${date.day}.${date.month}';
  }

  TrackerRecord? _latest(List<TrackerRecord> records, RecordType type) {
    final filtered = records.where((record) => record.type == type);
    return filtered.isEmpty ? null : filtered.first;
  }
}

String _recordSubtitle(
  TrackerRecord record,
  UserProfile? currentUser,
  String detail,
) {
  final actor = _recordActor(record, currentUser);
  final cleanDetail = detail.trim().isEmpty ? record.type.name : detail.trim();
  return '$actor • $cleanDetail • ${_recordTime(record.createdAt)}';
}

String _editRecordRoute(TrackerRecord record) {
  final id = Uri.encodeComponent(record.id);
  return '/add/${record.type.name}?id=$id';
}

String _recordActor(TrackerRecord record, UserProfile? currentUser) {
  if (currentUser != null && record.createdByUserId == currentUser.id) {
    return 'Siz';
  }
  final name = record.createdByName?.trim();
  if (name != null && name.isNotEmpty) return name;
  return 'Partner';
}

String _recordTime(DateTime time) {
  final local = time.toLocal();
  return '${local.day.toString().padLeft(2, '0')}.'
      '${local.month.toString().padLeft(2, '0')} '
      '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({required this.records, required this.onTap});

  final List<TrackerRecord> records;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final feedingCount = records
        .where((record) => record.type == RecordType.feeding)
        .length;
    final latest = records
        .where((record) => record.type == RecordType.feeding)
        .cast<TrackerRecord?>()
        .firstWhere((record) => record != null, orElse: () => null);
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SoftIcon(icon: Icons.restaurant_rounded),
          const SizedBox(height: 12),
          const Text('Beslenme'),
          Text(
            latest == null
                ? 'Henüz kayıt yok'
                : 'Son kayıt: ${latest.value ?? latest.title}',
          ),
          const SizedBox(height: 12),
          AppCard(
            color: AppColors.softBlue,
            child: Text('Bugünkü kayıt\n$feedingCount kez'),
          ),
        ],
      ),
    );
  }
}

class _SolidFoodCard extends StatelessWidget {
  const _SolidFoodCard({required this.records, required this.onTap});

  final List<TrackerRecord> records;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foods = records
        .where((record) => record.type == RecordType.solidFood)
        .take(2)
        .toList();
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Katı Gıda'),
          const SizedBox(height: 12),
          if (foods.isEmpty)
            const Text('İlk besini ekleyince burada görünür.')
          else
            for (final food in foods)
              Text(food.value ?? food.title, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          const Text('+ Yeni Besin Ekle'),
        ],
      ),
    );
  }
}

class _SymptomButton extends StatelessWidget {
  const _SymptomButton(this.label, this.icon, this.onTap);

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
          Icon(icon, size: 18),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, height: 1.05),
          ),
        ],
      ),
    );
  }
}

class _PregnancyTracker extends StatelessWidget {
  const _PregnancyTracker({
    required this.records,
    required this.currentUser,
    required this.mode,
  });

  final List<TrackerRecord> records;
  final UserProfile? currentUser;
  final CareMode mode;

  @override
  Widget build(BuildContext context) {
    final isPlanning = mode == CareMode.planning;
    final waterCount = records
        .where((record) => record.type == RecordType.water)
        .length;
    final vitaminCount = records
        .where((record) => record.type == RecordType.vitamin)
        .length;
    final pregnancyRecords = records
        .where(
          (record) =>
              record.type == RecordType.water ||
              record.type == RecordType.vitamin ||
              record.type == RecordType.health ||
              record.type == RecordType.appointment ||
              record.type == RecordType.memory,
        )
        .toList();
    return AppScreen(
      title: isPlanning ? 'Planlama Takibi' : 'Gebelik Takibi',
      subtitle: isPlanning
          ? 'Hazırlık, randevu ve günlük notlarını gebelik haftası varsaymadan tut.'
          : 'Bugünkü beden, duygu ve kontrol notlarını sakin biçimde tut.',
      children: [
        AppCard(
          color: AppColors.softGreen,
          borderColor: const Color(0xFFD3E3DC),
          child: Row(
            children: [
              const SoftIcon(icon: Icons.self_improvement_rounded),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  isPlanning
                      ? 'Bugün $waterCount su notu, $vitaminCount rutin kaydı var. Notlarınız randevuda sormak istediğiniz soruları netleştirir.'
                      : 'Bugün ${waterCount.clamp(0, 10)}/10 su notu, $vitaminCount vitamin kaydı var. Kayıtlar bakım ekibine sorulacak soruları netleştirir.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _PregnancyActionCard(
                title: 'Su',
                value: '$waterCount kayıt',
                icon: Icons.water_drop_outlined,
                onTap: () => context.push('/add/${RecordType.water.name}'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PregnancyActionCard(
                title: 'Vitamin',
                value: '$vitaminCount kayıt',
                icon: Icons.medication_liquid_rounded,
                onTap: () => context.push('/add/${RecordType.vitamin.name}'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          childAspectRatio: 1.18,
          children: [
            _SymptomButton(
              'Belirti',
              Icons.health_and_safety_outlined,
              () => context.push('/add/${RecordType.health.name}'),
            ),
            _SymptomButton(
              'Kontrol',
              Icons.event_available_rounded,
              () => context.push('/add/${RecordType.appointment.name}'),
            ),
            _SymptomButton(
              'Günlük',
              Icons.edit_note_rounded,
              () => context.push('/journal'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AppCard(
          color: AppColors.softPink,
          borderColor: const Color(0xFFF7CADB),
          onTap: () => context.push('/education'),
          child: Text(
            isPlanning
                ? 'Duygusal destek\nBekleyiş, belirsizlik veya yorgunluk belirginleşirse bunu yalnız taşımayın; bakım ekibinizle konuşmak hazırlığın parçasıdır.'
                : 'Duygusal destek\nKaygı, ağlama isteği veya uykusuzluk belirginleşirse bunu yalnız taşımayın; doktorunuzla konuşmak bakımın parçasıdır.',
          ),
        ),
        const SizedBox(height: 20),
        SectionHeader(
          title: isPlanning
              ? 'Son planlama kayıtları'
              : 'Son gebelik kayıtları',
          action: 'Yeni',
          onAction: () => context.push('/add/${RecordType.water.name}'),
        ),
        const SizedBox(height: 8),
        if (pregnancyRecords.isEmpty)
          EmptyState(
            icon: Icons.playlist_add_rounded,
            title: isPlanning
                ? 'Henüz planlama kaydı yok'
                : 'Henüz gebelik kaydı yok',
            body: isPlanning
                ? 'Günlük not, randevu sorusu veya hazırlık hatırlatıcısı ekleyin.'
                : 'Su, vitamin, belirti veya kontrol notu ekleyin.',
            actionLabel: 'Kayıt Ekle',
            onAction: () => context.push('/add/${RecordType.water.name}'),
          )
        else
          for (final record in pregnancyRecords.take(6))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SoftIcon(icon: _pregnancyIcon(record.type)),
                  title: Text(record.title),
                  subtitle: Text(
                    _recordSubtitle(
                      record,
                      currentUser,
                      record.value ?? record.note ?? record.type.name,
                    ),
                  ),
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () => context.push(_editRecordRoute(record)),
                ),
              ),
            ),
      ],
    );
  }

  IconData _pregnancyIcon(RecordType type) => switch (type) {
    RecordType.water => Icons.water_drop_outlined,
    RecordType.vitamin => Icons.medication_liquid_rounded,
    RecordType.appointment => Icons.event_available_rounded,
    RecordType.health => Icons.health_and_safety_outlined,
    _ => Icons.edit_note_rounded,
  };
}

class _PregnancyActionCard extends StatelessWidget {
  const _PregnancyActionCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SoftIcon(icon: icon),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          Text(value, style: const TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}
