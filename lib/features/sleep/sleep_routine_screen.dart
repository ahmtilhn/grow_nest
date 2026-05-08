import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/app_calculators.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class SleepRoutineScreen extends ConsumerStatefulWidget {
  const SleepRoutineScreen({super.key});

  @override
  ConsumerState<SleepRoutineScreen> createState() => _SleepRoutineScreenState();
}

class _SleepRoutineScreenState extends ConsumerState<SleepRoutineScreen> {
  Timer? _timer;
  bool _rain = false;
  bool _lullaby = false;
  bool _backPosition = false;
  bool _firmSurface = false;
  bool _emptySleepArea = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appSnapshotProvider);
    final controller = ref.read(appControllerProvider);
    final snapshot = controller.snapshot;
    final activeSleep = controller.activeSleepRecord;
    final baby = snapshot.baby;
    final ageMonths = baby == null
        ? 3
        : DateTime.now().difference(baby.birthDate).inDays ~/ 30;
    final elapsed = activeSleep == null
        ? Duration.zero
        : DateTime.now().difference(activeSleep.occurredAt);
    final allSleeps = snapshot.records
        .where((record) => record.type == RecordType.sleep)
        .toList();
    final latestSleeps = allSleeps.take(5).toList();
    final safeSleepReady = _backPosition && _firmSurface && _emptySleepArea;
    final stats = _SleepStats.fromRecords(
      allSleeps,
      babyBirthDate: baby?.birthDate,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Uyku Rutini')),
      body: AppScreen(
        children: [
          AppCard(
            color: const Color(0xFFE8F8F8),
            child: Column(
              children: [
                Chip(label: Text(activeSleep == null ? 'HAZIR' : 'UYKU AKTİF')),
                Text(
                  activeSleep == null ? 'Yeni uyku başlat' : 'Uyku sürüyor',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yaşa göre günlük hedef: ${SleepRoutineGuide.expectedRangeLabel(ageMonths)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 12),
                Text(
                  _formatDuration(elapsed),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                if (activeSleep == null) ...[
                  _SafeSleepChecklist(
                    backPosition: _backPosition,
                    firmSurface: _firmSurface,
                    emptySleepArea: _emptySleepArea,
                    onBackPosition: (value) =>
                        setState(() => _backPosition = value),
                    onFirmSurface: (value) =>
                        setState(() => _firmSurface = value),
                    onEmptySleepArea: (value) =>
                        setState(() => _emptySleepArea = value),
                  ),
                  const SizedBox(height: 12),
                ],
                FilledButton.icon(
                  onPressed: activeSleep == null
                      ? safeSleepReady
                            ? () => _startSleep(controller)
                            : null
                      : () => _finishSleep(controller, activeSleep),
                  icon: Icon(
                    activeSleep == null
                        ? Icons.play_circle_outline_rounded
                        : Icons.stop_circle_outlined,
                  ),
                  label: Text(activeSleep == null ? 'Uyku Başlat' : 'Uyandı'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SleepStatsPanel(stats: stats, ageMonths: ageMonths),
          const SizedBox(height: 18),
          SectionHeader(
            title: 'Uyku kayıtları',
            action: 'Yeni',
            onAction: () => _startSleep(controller),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _sleepProgress(allSleeps, ageMonths),
                ),
                const SizedBox(height: 16),
                if (latestSleeps.isEmpty)
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: SoftIcon(icon: Icons.nightlight_round),
                    title: Text('Henüz uyku kaydı yok'),
                    subtitle: Text('Başlat butonu ilk kaydı oluşturur.'),
                  )
                else
                  for (final record in latestSleeps)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SoftIcon(icon: _sleepIcon(record.occurredAt)),
                      title: Text(record.title),
                      subtitle: Text(_sleepSubtitle(record)),
                      trailing: Text(record.value ?? ''),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AppCard(
                  onTap: () => setState(() => _rain = !_rain),
                  child: _SoundToggle(
                    icon: Icons.water_drop_outlined,
                    title: 'Yağmur',
                    active: _rain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppCard(
                  onTap: () => setState(() => _lullaby = !_lullaby),
                  child: _SoundToggle(
                    icon: Icons.music_note_rounded,
                    title: 'Ninni',
                    active: _lullaby,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AppCard(
            color: AppColors.softGreen,
            borderColor: const Color(0xFFD3E3DC),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/crib.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'AAP güvenli uyku özeti: sırtüstü, düz ve sert yüzey, boş uyku alanı. Yatak paylaşımı yerine oda paylaşımı tercih edilir.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const MedicalWarningCard(),
        ],
      ),
    );
  }

  Future<void> _startSleep(AppController controller) async {
    if (!_backPosition || !_firmSurface || !_emptySleepArea) {
      showAppSnack(
        context,
        'Uyku başlatmadan önce güvenli uyku kontrolünü tamamlayın.',
      );
      return;
    }
    try {
      await controller.startSleep();
    } catch (error) {
      if (mounted) showAppSnack(context, userFacingErrorMessage(error));
      return;
    }
    if (mounted) showAppSnack(context, 'Uyku rutini başladı.');
  }

  Future<void> _finishSleep(
    AppController controller,
    TrackerRecord activeSleep,
  ) async {
    await controller.finishSleep(activeSleep);
    setState(() {
      _backPosition = false;
      _firmSurface = false;
      _emptySleepArea = false;
    });
    if (mounted) showAppSnack(context, 'Uyku kaydı tamamlandı.');
  }

  double _sleepProgress(List<TrackerRecord> records, int ageMonths) {
    final targetHours = ageMonths < 4
        ? 14
        : ageMonths < 12
        ? 12
        : 11;
    var minutes = 0;
    final since = DateTime.now().subtract(const Duration(hours: 24));
    for (final record in records) {
      if (record.occurredAt.isBefore(since)) continue;
      final match = RegExp(r'(\d+)\s*dk').firstMatch(record.value ?? '');
      if (match != null) minutes += int.parse(match.group(1)!);
    }
    return (minutes / (targetHours * 60)).clamp(0, 1);
  }

  String _sleepSubtitle(TrackerRecord record) {
    final time =
        '${record.occurredAt.hour.toString().padLeft(2, '0')}:${record.occurredAt.minute.toString().padLeft(2, '0')}';
    if (record.value == 'active') return '$time - devam ediyor';
    return record.note == null ? time : '$time - ${record.note}';
  }

  IconData _sleepIcon(DateTime time) {
    return time.hour >= 18 || time.hour < 7
        ? Icons.nightlight_round
        : Icons.wb_sunny_outlined;
  }

  String _formatDuration(Duration duration) {
    final safe = duration.isNegative ? Duration.zero : duration;
    return [
      safe.inHours.toString().padLeft(2, '0'),
      (safe.inMinutes % 60).toString().padLeft(2, '0'),
      (safe.inSeconds % 60).toString().padLeft(2, '0'),
    ].join(':');
  }
}

class _SleepStatsPanel extends StatelessWidget {
  const _SleepStatsPanel({required this.stats, required this.ageMonths});

  final _SleepStats stats;
  final int ageMonths;

  @override
  Widget build(BuildContext context) {
    final range = SleepRoutineGuide.expectedRangeLabel(ageMonths);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Uyku istatistikleri'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.25,
            children: [
              _MetricTile('Bugün', stats.todayLabel, Icons.today_outlined),
              _MetricTile('Gece', stats.nightLabel, Icons.dark_mode_outlined),
              _MetricTile('Gündüz', stats.dayLabel, Icons.wb_sunny_outlined),
              _MetricTile(
                '7 gün ort.',
                stats.sevenDayAverageLabel,
                Icons.timeline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SleepTrendRow(label: 'Son 7 gün', value: stats.sevenDayComparison),
          _SleepTrendRow(label: 'Son 30 gün', value: stats.thirtyDayComparison),
          _SleepTrendRow(label: 'Başlama saati', value: stats.startWindowLabel),
          _SleepTrendRow(label: 'Uyanma saati', value: stats.wakeWindowLabel),
          const SizedBox(height: 12),
          AppCard(
            padding: const EdgeInsets.all(12),
            color: AppColors.softGreen,
            borderColor: const Color(0xFFD3E3DC),
            child: Text(
              'Yaş grubu için önerilen uyku aralığı: $range. ${stats.guidance(ageMonths)} Bu bilgi yalnızca takip amaçlıdır; endişeniz varsa doktorunuza danışın.',
              style: const TextStyle(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile(this.title, this.value, this.icon);

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD7E8F8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SleepTrendRow extends StatelessWidget {
  const _SleepTrendRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
          const SizedBox(width: 10),
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

class _SleepStats {
  const _SleepStats({
    required this.todayMinutes,
    required this.nightMinutes,
    required this.dayMinutes,
    required this.sevenDayAverageMinutes,
    required this.previousSevenDayAverageMinutes,
    required this.thirtyDayAverageMinutes,
    required this.startMinutes,
    required this.wakeMinutes,
    required this.startSpreadMinutes,
  });

  final int todayMinutes;
  final int nightMinutes;
  final int dayMinutes;
  final int sevenDayAverageMinutes;
  final int previousSevenDayAverageMinutes;
  final int thirtyDayAverageMinutes;
  final int? startMinutes;
  final int? wakeMinutes;
  final int startSpreadMinutes;

  String get todayLabel => _durationLabel(todayMinutes);
  String get nightLabel => _durationLabel(nightMinutes);
  String get dayLabel => _durationLabel(dayMinutes);
  String get sevenDayAverageLabel => _durationLabel(sevenDayAverageMinutes);
  String get sevenDayComparison =>
      _comparisonLabel(sevenDayAverageMinutes, previousSevenDayAverageMinutes);
  String get thirtyDayComparison =>
      '30 gün ortalaması ${_durationLabel(thirtyDayAverageMinutes)}';
  String get startWindowLabel =>
      startMinutes == null ? 'Veri yok' : '${_timeLabel(startMinutes!)} civarı';
  String get wakeWindowLabel =>
      wakeMinutes == null ? 'Veri yok' : '${_timeLabel(wakeMinutes!)} civarı';

  factory _SleepStats.fromRecords(
    List<TrackerRecord> records, {
    DateTime? babyBirthDate,
  }) {
    final now = DateTime.now();
    final completed = records
        .where((record) => record.value != 'active')
        .map(_SleepSegment.tryParse)
        .whereType<_SleepSegment>()
        .toList();
    int sumWhere(bool Function(_SleepSegment segment) test) =>
        completed.where(test).fold(0, (sum, item) => sum + item.minutes);
    final todayStart = DateTime(now.year, now.month, now.day);
    final sevenStart = todayStart.subtract(const Duration(days: 6));
    final previousSevenStart = sevenStart.subtract(const Duration(days: 7));
    final thirtyStart = todayStart.subtract(const Duration(days: 29));
    final lastSeven = completed
        .where((item) => !item.start.isBefore(sevenStart))
        .toList();
    final previousSeven = completed
        .where(
          (item) =>
              !item.start.isBefore(previousSevenStart) &&
              item.start.isBefore(sevenStart),
        )
        .toList();
    final lastThirty = completed
        .where((item) => !item.start.isBefore(thirtyStart))
        .toList();
    final startMinutes = _averageClockMinute(lastSeven.map((e) => e.start));
    final wakeMinutes = _averageClockMinute(lastSeven.map((e) => e.end));
    return _SleepStats(
      todayMinutes: sumWhere((item) => !item.start.isBefore(todayStart)),
      nightMinutes: sumWhere(
        (item) => !item.start.isBefore(todayStart) && item.isNight,
      ),
      dayMinutes: sumWhere(
        (item) => !item.start.isBefore(todayStart) && !item.isNight,
      ),
      sevenDayAverageMinutes: _dailyAverage(lastSeven, 7),
      previousSevenDayAverageMinutes: _dailyAverage(previousSeven, 7),
      thirtyDayAverageMinutes: _dailyAverage(lastThirty, 30),
      startMinutes: startMinutes,
      wakeMinutes: wakeMinutes,
      startSpreadMinutes: _clockSpread(lastSeven.map((e) => e.start)),
    );
  }

  String guidance(int ageMonths) {
    final recommended = _recommendedMinutes(ageMonths);
    if (sevenDayAverageMinutes == 0) {
      return 'Yeterli veri oluşunca düzen analizi burada görünür.';
    }
    if (sevenDayAverageMinutes < recommended.$1) {
      return 'Son 7 günlük ortalama, önerilen aralığın biraz altında görünüyor.';
    }
    if (sevenDayAverageMinutes > recommended.$2) {
      return 'Son 7 günlük ortalama, önerilen aralığın üzerinde görünüyor.';
    }
    if (startSpreadMinutes > 90) {
      return 'Toplam süre aralıkta, ancak uykuya başlama saatleri değişken görünüyor.';
    }
    return 'Son 7 günlük ortalama önerilen aralıkta ve düzen görece stabil görünüyor.';
  }

  static int _dailyAverage(List<_SleepSegment> items, int days) {
    if (items.isEmpty) return 0;
    final total = items.fold(0, (sum, item) => sum + item.minutes);
    return (total / days).round();
  }

  static int? _averageClockMinute(Iterable<DateTime> times) {
    final values = times.map((time) => time.hour * 60 + time.minute).toList();
    if (values.isEmpty) return null;
    return (values.reduce((a, b) => a + b) / values.length).round();
  }

  static int _clockSpread(Iterable<DateTime> times) {
    final values = times.map((time) => time.hour * 60 + time.minute).toList();
    if (values.length < 2) return 0;
    values.sort();
    return values.last - values.first;
  }

  static (int, int) _recommendedMinutes(int ageMonths) {
    if (ageMonths < 4) return (14 * 60, 17 * 60);
    if (ageMonths < 12) return (12 * 60, 16 * 60);
    if (ageMonths < 24) return (11 * 60, 14 * 60);
    return (10 * 60, 13 * 60);
  }

  static String _comparisonLabel(int current, int previous) {
    if (current == 0) return 'Veri yok';
    if (previous == 0) return 'Önceki hafta verisi yok';
    final diff = current - previous;
    if (diff.abs() < 20) return 'Önceki haftaya benzer';
    final prefix = diff > 0 ? '+' : '-';
    return '$prefix${_durationLabel(diff.abs())} / önceki hafta';
  }

  static String _durationLabel(int minutes) {
    if (minutes <= 0) return '0 dk';
    return '${minutes ~/ 60}s ${minutes % 60}dk';
  }

  static String _timeLabel(int minutes) {
    final safe = minutes % (24 * 60);
    return '${(safe ~/ 60).toString().padLeft(2, '0')}:${(safe % 60).toString().padLeft(2, '0')}';
  }
}

class _SleepSegment {
  const _SleepSegment({
    required this.start,
    required this.end,
    required this.minutes,
  });

  final DateTime start;
  final DateTime end;
  final int minutes;

  bool get isNight => start.hour >= 18 || start.hour < 7;

  static _SleepSegment? tryParse(TrackerRecord record) {
    final match = RegExp(r'(\d+)\s*dk').firstMatch(record.value ?? '');
    if (match == null) return null;
    final minutes = int.tryParse(match.group(1)!);
    if (minutes == null || minutes <= 0) return null;
    return _SleepSegment(
      start: record.occurredAt,
      end: record.occurredAt.add(Duration(minutes: minutes)),
      minutes: minutes,
    );
  }
}

class _SafeSleepChecklist extends StatelessWidget {
  const _SafeSleepChecklist({
    required this.backPosition,
    required this.firmSurface,
    required this.emptySleepArea,
    required this.onBackPosition,
    required this.onFirmSurface,
    required this.onEmptySleepArea,
  });

  final bool backPosition;
  final bool firmSurface;
  final bool emptySleepArea;
  final ValueChanged<bool> onBackPosition;
  final ValueChanged<bool> onFirmSurface;
  final ValueChanged<bool> onEmptySleepArea;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          value: backPosition,
          dense: true,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => onBackPosition(value ?? false),
          title: const Text('Sırtüstü yatırıldı'),
        ),
        CheckboxListTile(
          value: firmSurface,
          dense: true,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => onFirmSurface(value ?? false),
          title: const Text('Düz ve sert uyku yüzeyi hazır'),
        ),
        CheckboxListTile(
          value: emptySleepArea,
          dense: true,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => onEmptySleepArea(value ?? false),
          title: const Text('Yastık, oyuncak ve gevşek örtü yok'),
        ),
      ],
    );
  }
}

class _SoundToggle extends StatelessWidget {
  const _SoundToggle({
    required this.icon,
    required this.title,
    required this.active,
  });

  final IconData icon;
  final String title;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SoftIcon(
          icon: icon,
          color: active ? AppColors.softGreen : AppColors.softBlue,
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        Text(
          active ? 'Ortam notu açık' : 'Ses çalmaz',
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }
}
