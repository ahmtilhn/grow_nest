import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/utils/app_calculators.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class PregnancyDashboardScreen extends ConsumerWidget {
  const PregnancyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(appSnapshotProvider);
    final pregnancy = snapshot.pregnancy;
    final now = DateTime.now();
    final week = pregnancy == null
        ? 12
        : AgeUtils.pregnancyWeekFromDueDate(pregnancy.dueDate, now);
    final day = pregnancy == null
        ? 0
        : AgeUtils.pregnancyDayFromDueDate(pregnancy.dueDate, now);
    final dueDate = pregnancy?.dueDate ?? now.add(const Duration(days: 196));
    final guide = _PregnancyWeekGuide.forWeek(week);
    final waterMl = _waterMlToday(snapshot.records);
    final waterGoal = _waterGoalLiters(snapshot.reminders) ?? 2.0;
    final vitaminPlans = snapshot.reminders
        .where(
          (item) =>
              item.category == ReminderCategory.vitamin ||
              item.category == ReminderCategory.medicine,
        )
        .toList();
    return AppScreen(
      children: [
        _PregnancyHeroCard(
          week: week,
          day: day,
          dueDate: dueDate,
          guide: guide,
          onEducation: () => context.push('/education'),
        ),
        const SizedBox(height: 18),
        AppCard(
          color: AppColors.softGreen,
          borderColor: const Color(0xFFD3E3DC),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bugünün küçük rutini',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              Text('Gün $day: ${guide.emotionalPrompt}'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final routine in guide.routines)
                    ActionChip(
                      avatar: Icon(routine.icon),
                      label: Text(routine.label),
                      onPressed: () => context.push('/reminder/new'),
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.add_alert_outlined),
                    label: const Text('Rutin ekle'),
                    onPressed: () => context.push('/reminder/new'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _ProgressCard(
                icon: Icons.water_drop_outlined,
                title: 'Su Takibi',
                value:
                    '${(waterMl / 1000).toStringAsFixed(1)} / ${waterGoal.toStringAsFixed(1)} L',
                progress: (waterMl / (waterGoal * 1000)).clamp(0, 1),
                trailing: '${waterMl.round()} ml',
                onTap: () => context.push('/add/${RecordType.water.name}'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _ProgressCard(
                icon: Icons.medication_liquid_rounded,
                title: 'Vitaminler',
                value: vitaminPlans.isEmpty
                    ? 'Plan eklenmedi'
                    : '${vitaminPlans.length} aktif plan',
                progress: vitaminPlans.isEmpty ? 0 : 1,
                trailing: vitaminPlans.isEmpty ? '+' : '✓',
                color: AppColors.softPink,
                onTap: () => context.push('/reminder/new'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Su ve vitamin hedeflerinde doktorunuzun kişisel önerisi önceliklidir.',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'Bu hafta seni neler bekleyebilir?',
          action: 'Hepsini Gör',
          onAction: () => context.push('/education'),
        ),
        const SizedBox(height: 10),
        _AdviceTile(
          image: 'assets/images/snack.png',
          title: guide.expectations[0].title,
          body: guide.expectations[0].body,
          onTap: () => context.push('/education'),
        ),
        _AdviceTile(
          image: 'assets/images/yoga.png',
          title: guide.expectations[1].title,
          body: guide.expectations[1].body,
          onTap: () => context.push('/education'),
        ),
        _AdviceTile(
          image: 'assets/images/room_plant.png',
          title: 'Duygusal destek',
          body:
              'Kaygı artarsa bunu saklamak yerine bakım ekibine ve güvendiğin birine söyle.',
          onTap: () => context.push('/education'),
        ),
        const SizedBox(height: 12),
        AppCard(
          color: AppColors.softGreen,
          borderColor: const Color(0xFFD3E3DC),
          onTap: () => context.go('/family'),
          child: Text(
            'Aile desteğini ve doğum hazırlığını aynı yerde toparlayın. Tahmini doğum: ${dueDate.day}.${dueDate.month}.${dueDate.year}',
          ),
        ),
      ],
    );
  }

  double _waterMlToday(List<TrackerRecord> records) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var total = 0.0;
    for (final record in records) {
      if (record.type != RecordType.water ||
          record.occurredAt.isBefore(today)) {
        continue;
      }
      final value = record.value ?? '';
      final match = RegExp(r'([\d,.]+)').firstMatch(value);
      if (match == null) continue;
      total += double.tryParse(match.group(1)!.replaceAll(',', '.')) ?? 0;
    }
    return total;
  }

  double? _waterGoalLiters(List<ReminderItem> reminders) {
    for (final reminder in reminders) {
      if (reminder.category != ReminderCategory.water) continue;
      final plan = ReminderPlan.tryParse(reminder.frequency);
      if (plan?.goalLiters != null && plan!.goalLiters! > 0) {
        return plan.goalLiters;
      }
    }
    return null;
  }
}

class PlanningDashboardScreen extends ConsumerWidget {
  const PlanningDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(appSnapshotProvider);
    final recentNotes = snapshot.records
        .where(
          (record) =>
              record.type == RecordType.memory ||
              record.type == RecordType.appointment ||
              record.type == RecordType.health,
        )
        .take(3)
        .toList();
    return AppScreen(
      title: 'Planlama',
      subtitle:
          'Gebelik haftası varsaymadan; hazırlık, randevu ve duygusal notları sakin biçimde takip edin.',
      children: [
        AppCard(
          color: AppColors.softGreen,
          borderColor: const Color(0xFFD3E3DC),
          child: Row(
            children: [
              const SoftIcon(icon: Icons.favorite_border_rounded),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Bugünün odağı: tek bir hazırlık adımı seçin, sorularınızı not edin ve tıbbi kararları bakım ekibinizle birlikte verin.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _PlanningActionCard(
                icon: Icons.edit_note_rounded,
                title: 'Günlük not',
                body: 'Duygu, soru veya hazırlık notu ekle',
                onTap: () => context.push('/add/${RecordType.memory.name}'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PlanningActionCard(
                icon: Icons.event_available_rounded,
                title: 'Randevu',
                body: 'Kontrol sorularını sakla',
                onTap: () =>
                    context.push('/add/${RecordType.appointment.name}'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _PlanningActionCard(
          icon: Icons.alarm_add_rounded,
          title: 'Hazırlık hatırlatıcısı',
          body: 'Vitamin, su, randevu veya özel rutin için plan kur',
          onTap: () => context.push('/reminder/new'),
        ),
        const SizedBox(height: 22),
        SectionHeader(
          title: 'Son notlar',
          action: 'Yeni',
          onAction: () => context.push('/add/${RecordType.memory.name}'),
        ),
        const SizedBox(height: 10),
        if (recentNotes.isEmpty)
          EmptyState(
            icon: Icons.spa_outlined,
            title: 'Henüz planlama notu yok',
            body:
                'İlk notun randevuda sormak istediğin bir soru veya bugün iyi gelen küçük bir şey olabilir.',
            actionLabel: 'Not Ekle',
            onAction: () => context.push('/add/${RecordType.memory.name}'),
          )
        else
          for (final record in recentNotes)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SoftIcon(icon: _planningIcon(record.type)),
                  title: Text(record.title),
                  subtitle: Text(record.note ?? record.value ?? 'Not eklendi'),
                ),
              ),
            ),
      ],
    );
  }

  IconData _planningIcon(RecordType type) => switch (type) {
    RecordType.appointment => Icons.event_available_rounded,
    RecordType.health => Icons.health_and_safety_outlined,
    _ => Icons.edit_note_rounded,
  };
}

class _PlanningActionCard extends StatelessWidget {
  const _PlanningActionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
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
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _PregnancyHeroCard extends StatelessWidget {
  const _PregnancyHeroCard({
    required this.week,
    required this.day,
    required this.dueDate,
    required this.guide,
    required this.onEducation,
  });

  final int week;
  final int day;
  final DateTime dueDate;
  final _PregnancyWeekGuide guide;
  final VoidCallback onEducation;

  @override
  Widget build(BuildContext context) {
    final fruit = _FruitScaleItem.forWeek(week);
    return AppCard(
      color: const Color(0xFFEAF7F8),
      borderColor: const Color(0xFFD4ECEF),
      radius: AppRadius.xl,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$week. hafta, $day. gün',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bebeğiniz bu hafta ${fruit.name.toLowerCase()} kadar',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(guide.body),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _FruitOrb(item: fruit, size: 104),
            ],
          ),
          const SizedBox(height: 18),
          _FruitScale(currentWeek: week),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tahmini doğum: ${dueDate.day}.${dueDate.month}.${dueDate.year}',
                  style: const TextStyle(color: AppColors.muted),
                ),
              ),
              SizedBox(
                width: 178,
                child: FilledButton.tonal(
                  onPressed: onEducation,
                  child: const Text('Haftanın rehberleri'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FruitScale extends StatelessWidget {
  const _FruitScale({required this.currentWeek});

  final int currentWeek;

  @override
  Widget build(BuildContext context) {
    final items = _FruitScaleItem.items;
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final progress = ((currentWeek - 4) / 36).clamp(0.0, 1.0);
            return SizedBox(
              height: 74,
              child: Stack(
                children: [
                  Positioned(
                    left: 14,
                    right: 14,
                    top: 33,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 33,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 420),
                      width: (constraints.maxWidth - 28) * progress,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  for (var i = 0; i < items.length; i++)
                    Positioned(
                      left:
                          (constraints.maxWidth - 28) *
                              (i / (items.length - 1)) -
                          2,
                      top: 12,
                      child: _FruitOrb(
                        item: items[i],
                        size: items[i].week <= currentWeek ? 42 : 34,
                        muted: items[i].week > currentWeek,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final item in items)
              Expanded(
                child: Text(
                  '${item.week}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _FruitOrb extends StatelessWidget {
  const _FruitOrb({required this.item, required this.size, this.muted = false});

  final _FruitScaleItem item;
  final double size;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final color = muted ? const Color(0xFFE2E8F0) : item.color;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              if (!muted)
                BoxShadow(
                  color: item.color.withValues(alpha: .28),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: Center(
            child: Text(
              item.short,
              style: TextStyle(
                color: muted ? AppColors.muted : Colors.white,
                fontSize: size * .28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        if (size > 70) ...[
          const SizedBox(height: 8),
          Text(item.name, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ],
    );
  }
}

class _FruitScaleItem {
  const _FruitScaleItem({
    required this.week,
    required this.name,
    required this.short,
    required this.title,
    required this.color,
  });

  final int week;
  final String name;
  final String short;
  final String title;
  final Color color;

  static const items = [
    _FruitScaleItem(
      week: 4,
      name: 'Haşhaş',
      short: 'H',
      title: 'Bebeğiniz haşhaş tanesi kadar',
      color: Color(0xFF8E7DBE),
    ),
    _FruitScaleItem(
      week: 8,
      name: 'Ahududu',
      short: 'A',
      title: 'Bebeğiniz ahududu kadar',
      color: Color(0xFFD45B8C),
    ),
    _FruitScaleItem(
      week: 12,
      name: 'Limon',
      short: 'L',
      title: 'Bebeğiniz limon kadar',
      color: Color(0xFFE7B84E),
    ),
    _FruitScaleItem(
      week: 16,
      name: 'Avokado',
      short: 'Av',
      title: 'Bebeğiniz avokado kadar',
      color: Color(0xFF78A55A),
    ),
    _FruitScaleItem(
      week: 20,
      name: 'Muz',
      short: 'M',
      title: 'Bebeğiniz muz kadar',
      color: Color(0xFFE7C85B),
    ),
    _FruitScaleItem(
      week: 24,
      name: 'Mısır',
      short: 'Ms',
      title: 'Bebeğiniz mısır koçanı kadar',
      color: Color(0xFFD9A441),
    ),
    _FruitScaleItem(
      week: 28,
      name: 'Patlıcan',
      short: 'P',
      title: 'Bebeğiniz patlıcan kadar',
      color: Color(0xFF6E5C96),
    ),
    _FruitScaleItem(
      week: 32,
      name: 'Kabak',
      short: 'K',
      title: 'Bebeğiniz kabak kadar',
      color: Color(0xFF69A36F),
    ),
    _FruitScaleItem(
      week: 36,
      name: 'Papaya',
      short: 'Pa',
      title: 'Bebeğiniz papaya kadar',
      color: Color(0xFFE88959),
    ),
    _FruitScaleItem(
      week: 40,
      name: 'Karpuz',
      short: 'Ka',
      title: 'Bebeğiniz karpuz kadar',
      color: Color(0xFF4AA96C),
    ),
  ];

  static _FruitScaleItem forWeek(int week) {
    return items.lastWhere(
      (item) => item.week <= week,
      orElse: () => items.first,
    );
  }
}

class _PregnancyWeekGuide {
  const _PregnancyWeekGuide({
    required this.headline,
    required this.body,
    required this.emotionalPrompt,
    required this.routines,
    required this.expectations,
  });

  final String headline;
  final String body;
  final String emotionalPrompt;
  final List<_RoutineItem> routines;
  final List<_ExpectationItem> expectations;

  static _PregnancyWeekGuide forWeek(int week) {
    if (week <= 13) {
      return const _PregnancyWeekGuide(
        headline: 'İlk trimester: bedenin sessiz ama yoğun çalışıyor',
        body:
            'Yorgunluk, bulantı, hassasiyet ve duygu dalgalanmaları bu dönemde sık görülebilir.',
        emotionalPrompt:
            'Bugün kendine düşük tempolu bir alan aç; her şeyin kusursuz ilerlemesi gerekmiyor.',
        routines: [
          _RoutineItem('Su', Icons.water_drop_outlined),
          _RoutineItem('Kısa yürüyüş', Icons.directions_walk_rounded),
          _RoutineItem('Dinlenme', Icons.self_improvement_rounded),
        ],
        expectations: [
          _ExpectationItem(
            'Yorgunluk normal olabilir',
            'Kısa molalar ve küçük öğünler günü daha yönetilebilir kılabilir.',
          ),
          _ExpectationItem(
            'Soruları not al',
            'Bir sonraki kontrolde doktoruna sormak istediklerini burada biriktir.',
          ),
        ],
      );
    }
    if (week <= 27) {
      return const _PregnancyWeekGuide(
        headline: 'İkinci trimester: enerji ve hareket alanı artabilir',
        body:
            'Bazı kişiler bu dönemde daha dengeli hisseder; hareketleri fark etmek de başlayabilir.',
        emotionalPrompt:
            'Bebeğinle bağ kurmak için iki dakikalık sakin nefes molası ver.',
        routines: [
          _RoutineItem('Proteinli ara öğün', Icons.restaurant_rounded),
          _RoutineItem('Pelvik rahatlama', Icons.spa_outlined),
          _RoutineItem('Kontrol listesi', Icons.checklist_rounded),
        ],
        expectations: [
          _ExpectationItem(
            'Hafif hareket iyi gelebilir',
            'Doktorun aksi demediyse yürüyüş ve esneme rutinini küçük tut.',
          ),
          _ExpectationItem(
            'Duygular dalgalanabilir',
            'Keyifli hissetmediğin günlerde bile destek istemek bakımın parçasıdır.',
          ),
        ],
      );
    }
    return const _PregnancyWeekGuide(
      headline: 'Üçüncü trimester: hazırlığı küçük adımlara böl',
      body:
          'Uyku, bel ve nefes konforu zorlaşabilir; destek planı ve doğum çantası netleşebilir.',
      emotionalPrompt:
          'Bugün sadece bir hazırlık seç: çanta, uyku alanı ya da destek kişisi.',
      routines: [
        _RoutineItem('Uyku alanı', Icons.crib_rounded),
        _RoutineItem('Nefes molası', Icons.air_rounded),
        _RoutineItem('Destek mesajı', Icons.favorite_outline_rounded),
      ],
      expectations: [
        _ExpectationItem(
          'Dinlenme öncelik olabilir',
          'Bedenin daha fazla mola isteyebilir; bunu tembellik gibi okumamaya çalış.',
        ),
        _ExpectationItem(
          'İlk günleri planla',
          'Güvenli uyku alanı ve yardım edecek kişiler önceden konuşulabilir.',
        ),
      ],
    );
  }
}

class _RoutineItem {
  const _RoutineItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _ExpectationItem {
  const _ExpectationItem(this.title, this.body);

  final String title;
  final String body;
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.progress,
    required this.trailing,
    required this.onTap,
    this.color = AppColors.softBlue,
  });

  final IconData icon;
  final String title;
  final String value;
  final double progress;
  final String trailing;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SoftIcon(icon: icon, color: color),
              const Spacer(),
              Text(trailing, style: const TextStyle(color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          Text(value),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress),
        ],
      ),
    );
  }
}

class _AdviceTile extends StatelessWidget {
  const _AdviceTile({
    required this.image,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final String image;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                width: 62,
                height: 62,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(body, style: const TextStyle(color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
