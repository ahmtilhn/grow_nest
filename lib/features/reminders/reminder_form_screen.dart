import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class ReminderFormScreen extends ConsumerStatefulWidget {
  const ReminderFormScreen({super.key, this.reminderId});

  final String? reminderId;

  @override
  ConsumerState<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  final _title = TextEditingController();
  final _notes = TextEditingController();
  final _dose = TextEditingController();
  final _goalLiters = TextEditingController(text: '2.0');
  ReminderCategory _category = ReminderCategory.water;
  ReminderPlanType _planType = ReminderPlanType.dailyTimes;
  final List<TimeOfDay> _times = [const TimeOfDay(hour: 9, minute: 0)];
  final Set<int> _weekdays = {1, 2, 3, 4, 5};
  final Set<int> _monthDays = {1};
  int _intervalHours = 2;
  int _startHour = 8;
  int _endHour = 22;
  bool _isActive = true;
  bool _saving = false;
  ReminderItem? _editingReminder;

  @override
  void initState() {
    super.initState();
    final reminderId = widget.reminderId;
    if (reminderId == null) return;
    final existing = ref
        .read(appControllerProvider)
        .snapshot
        .reminders
        .where((item) => item.id == reminderId)
        .cast<ReminderItem?>()
        .firstWhere((item) => item != null, orElse: () => null);
    if (existing == null) return;
    _editingReminder = existing;
    _title.text = existing.title;
    _category = existing.category;
    _isActive = existing.isActive;
    _seedPlan(existing);
    _seedNotes(existing.notes);
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    _dose.dispose();
    _goalLiters.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (_category == ReminderCategory.medicine && _dose.text.trim().isEmpty) {
      showAppSnack(context, 'İlaç için doktor talimatı veya doz notu girin.');
      return;
    }
    if (_category == ReminderCategory.water) {
      final goal = double.tryParse(_goalLiters.text.replaceAll(',', '.'));
      if (goal == null || goal < 0.5 || goal > 5) {
        showAppSnack(context, 'Su hedefi 0.5-5 L aralığında olmalı.');
        return;
      }
    }
    setState(() => _saving = true);
    final now = DateTime.now();
    final title = _title.text.trim().isEmpty
        ? _defaultTitle(_category)
        : _title.text.trim();
    final plan = _buildPlan();
    final first = plan.times.isEmpty
        ? DateTime(now.year, now.month, now.day, _startHour)
        : DateTime(
            now.year,
            now.month,
            now.day,
            plan.times.first.hour,
            plan.times.first.minute,
          );
    final controller = ref.read(appControllerProvider);
    try {
      if (_editingReminder != null) {
        await controller.updateReminder(
          _editingReminder!.copyWith(
            title: title,
            category: _category,
            time: first,
            frequency: plan.encode(),
            notes: _notesForSave(),
            isActive: _isActive,
          ),
        );
      } else {
        await controller.addReminder(
          category: _category,
          title: title,
          time: first,
          notes: _notesForSave(),
          frequency: plan.encode(),
        );
      }
      if (!mounted) return;
      showAppSnack(
        context,
        _editingReminder == null
            ? 'Hatırlatıcı planı kaydedildi.'
            : 'Hatırlatıcı planı güncellendi.',
      );
      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(appSnapshotProvider);
    final categories = _categories(snapshot.mode);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editingReminder == null
              ? 'Rutin ve Bildirim Planı'
              : 'Rutin Planını Düzenle',
        ),
      ),
      body: AppScreen(
        subtitle:
            'Saatlik, günlük çoklu saatli, haftalık veya aylık bildirim planı kur.',
        bottomPadding: 32,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kategori',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final category in categories)
                      ChoiceChip(
                        selected: _category == category,
                        avatar: Icon(_categoryIcon(category), size: 18),
                        label: Text(_categoryLabel(category)),
                        onSelected: (_) => setState(() {
                          _category = category;
                          _planType = category == ReminderCategory.water
                              ? ReminderPlanType.hourly
                              : ReminderPlanType.dailyTimes;
                          if (_title.text.trim().isEmpty) {
                            _title.text = _defaultTitle(category);
                          }
                        }),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Plan aktif'),
              subtitle: Text(
                _isActive
                    ? 'Bildirimler bu cihazda kurulacak ve ortak ailede aktif görünecek.'
                    : 'Plan saklanır ama bildirim gönderilmez.',
              ),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                AppTextField(
                  controller: _title,
                  label: 'Başlık',
                  hint: _defaultTitle(_category),
                ),
                if (_category == ReminderCategory.vitamin ||
                    _category == ReminderCategory.medicine) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.softPink,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFAD2E1)),
                    ),
                    child: const Text(
                      'İlaç ve vitamin hatırlatıcıları yalnızca doktorunuzun veya eczacınızın verdiği talimata göre kurulmalıdır.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _dose,
                    label: 'Doz / talimat',
                    hint: '1 tablet, 5 damla, yemek sonrası',
                  ),
                ],
                if (_category == ReminderCategory.water) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Doktorunuz farklı bir sıvı hedefi verdiyse burada onu kullanın.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _goalLiters,
                          label: 'Günlük hedef (L)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StepperCard(
                          title: 'Aralık',
                          value: '$_intervalHours sa',
                          onMinus: _intervalHours == 1
                              ? null
                              : () => setState(() => _intervalHours--),
                          onPlus: _intervalHours == 6
                              ? null
                              : () => setState(() => _intervalHours++),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bildirim düzeni',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _PlanChip(
                      type: ReminderPlanType.hourly,
                      selected: _planType,
                      label: 'Saatlik',
                      onTap: _setPlanType,
                    ),
                    _PlanChip(
                      type: ReminderPlanType.dailyTimes,
                      selected: _planType,
                      label: 'Günlük saatler',
                      onTap: _setPlanType,
                    ),
                    _PlanChip(
                      type: ReminderPlanType.weeklyTimes,
                      selected: _planType,
                      label: 'Haftalık',
                      onTap: _setPlanType,
                    ),
                    _PlanChip(
                      type: ReminderPlanType.monthlyDates,
                      selected: _planType,
                      label: 'Aylık',
                      onTap: _setPlanType,
                    ),
                    _PlanChip(
                      type: ReminderPlanType.once,
                      selected: _planType,
                      label: 'Tek sefer',
                      onTap: _setPlanType,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_planType == ReminderPlanType.hourly)
                  _HourlyWindow(
                    startHour: _startHour,
                    endHour: _endHour,
                    onStart: (value) => setState(() => _startHour = value),
                    onEnd: (value) => setState(() => _endHour = value),
                  )
                else ...[
                  _TimesEditor(
                    times: _times,
                    onAdd: _addTime,
                    onEdit: _editTime,
                    onRemove: _removeTime,
                  ),
                  if (_planType == ReminderPlanType.weeklyTimes) ...[
                    const SizedBox(height: 14),
                    _WeekdayPicker(
                      selected: _weekdays,
                      onToggle: (day) => setState(() {
                        _weekdays.contains(day)
                            ? _weekdays.remove(day)
                            : _weekdays.add(day);
                      }),
                    ),
                  ],
                  if (_planType == ReminderPlanType.monthlyDates) ...[
                    const SizedBox(height: 14),
                    _MonthDayPicker(
                      selected: _monthDays,
                      onToggle: (day) => setState(() {
                        _monthDays.contains(day)
                            ? _monthDays.remove(day)
                            : _monthDays.add(day);
                      }),
                    ),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _notes,
            label: 'Notlar',
            hint: 'Doz, hazırlık veya aileye görünecek küçük talimat...',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          AppCard(
            color: AppColors.softGreen,
            borderColor: const Color(0xFFD3E3DC),
            child: Text(_previewText()),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.notifications_active_outlined),
            label: Text(
              _editingReminder == null ? 'Planı Kaydet' : 'Planı Güncelle',
            ),
          ),
          if (_editingReminder != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _saving ? null : _delete,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.danger,
              ),
              label: const Text(
                'Planı Sil',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _setPlanType(ReminderPlanType type) => setState(() => _planType = type);

  Future<void> _addTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _times.isEmpty ? TimeOfDay.now() : _times.last,
    );
    if (picked == null) return;
    setState(() {
      _times.add(picked);
      _times.sort(
        (a, b) => a.hour == b.hour
            ? a.minute.compareTo(b.minute)
            : a.hour.compareTo(b.hour),
      );
    });
  }

  Future<void> _editTime(TimeOfDay current) async {
    final picked = await showTimePicker(context: context, initialTime: current);
    if (picked == null) return;
    final index = _times.indexWhere(
      (time) => time.hour == current.hour && time.minute == current.minute,
    );
    if (index < 0) return;
    setState(() {
      _times[index] = picked;
      _times.sort(
        (a, b) => a.hour == b.hour
            ? a.minute.compareTo(b.minute)
            : a.hour.compareTo(b.hour),
      );
    });
  }

  void _removeTime(TimeOfDay time) {
    if (_times.length == 1) return;
    setState(() => _times.remove(time));
  }

  Future<void> _delete() async {
    final reminder = _editingReminder;
    if (reminder == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Planı sil'),
        content: const Text(
          'Bu rutin ortak aile listesinden kaldırılacak. Bağlı hesaplarda da kaybolur.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(appControllerProvider).deleteReminder(reminder.id);
    if (!mounted) return;
    showAppSnack(context, 'Hatırlatıcı planı silindi.');
    Navigator.of(context).pop();
  }

  ReminderPlan _buildPlan() {
    return ReminderPlan(
      type: _planType,
      times: _times
          .map((time) => TimeOfDayValue(time.hour, time.minute))
          .toList(),
      weekdays: _weekdays.toList()..sort(),
      monthDays: _monthDays.toList()..sort(),
      intervalHours: _intervalHours,
      startHour: _startHour,
      endHour: _endHour,
      goalLiters: double.tryParse(_goalLiters.text.replaceAll(',', '.')),
    );
  }

  String _notesForSave() {
    final parts = <String>[
      if (_dose.text.trim().isNotEmpty) 'Talimat: ${_dose.text.trim()}',
      if (_notes.text.trim().isNotEmpty) _notes.text.trim(),
    ];
    return parts.join('\n');
  }

  void _seedPlan(ReminderItem reminder) {
    final plan = ReminderPlan.tryParse(reminder.frequency);
    if (plan != null) {
      _planType = plan.type;
      _times
        ..clear()
        ..addAll(
          plan.times.map(
            (time) => TimeOfDay(hour: time.hour, minute: time.minute),
          ),
        );
      if (_times.isEmpty) {
        _times.add(
          TimeOfDay(hour: reminder.time.hour, minute: reminder.time.minute),
        );
      }
      _weekdays
        ..clear()
        ..addAll(
          plan.weekdays.isEmpty ? {reminder.time.weekday} : plan.weekdays,
        );
      _monthDays
        ..clear()
        ..addAll(plan.monthDays.isEmpty ? {reminder.time.day} : plan.monthDays);
      _intervalHours = plan.intervalHours;
      _startHour = plan.startHour;
      _endHour = plan.endHour;
      if (plan.goalLiters != null) {
        _goalLiters.text = plan.goalLiters!.toString();
      }
      return;
    }
    _times
      ..clear()
      ..add(TimeOfDay(hour: reminder.time.hour, minute: reminder.time.minute));
    _planType = switch (reminder.frequency) {
      'once' => ReminderPlanType.once,
      'weekly' => ReminderPlanType.weeklyTimes,
      _ => ReminderPlanType.dailyTimes,
    };
    _weekdays
      ..clear()
      ..add(reminder.time.weekday);
    _monthDays
      ..clear()
      ..add(reminder.time.day);
  }

  void _seedNotes(String? rawNotes) {
    final raw = rawNotes?.trim() ?? '';
    if (raw.isEmpty) return;
    final lines = raw.split('\n');
    final first = lines.first.trim();
    if (first.startsWith('Talimat: ')) {
      _dose.text = first.substring('Talimat: '.length).trim();
      _notes.text = lines.skip(1).join('\n').trim();
      return;
    }
    _notes.text = raw;
  }

  String _previewText() {
    if (!_isActive) {
      return 'Plan kayıtlı kalır ama bildirim göndermez. İstediğiniz zaman yeniden aktif edebilirsiniz.';
    }
    final timeText = _times
        .map(
          (time) =>
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
        )
        .join(', ');
    return switch (_planType) {
      ReminderPlanType.hourly =>
        'Her $_intervalHours saatte bir, $_startHour:00-$_endHour:00 arasında bildirim gelir.',
      ReminderPlanType.dailyTimes => 'Her gün şu saatlerde: $timeText.',
      ReminderPlanType.weeklyTimes =>
        'Seçili haftanın günlerinde şu saatlerde: $timeText.',
      ReminderPlanType.monthlyDates =>
        'Her ay seçili tarihlerde şu saatlerde: $timeText.',
      ReminderPlanType.once => 'Tek seferlik bildirim: $timeText.',
    };
  }

  List<ReminderCategory> _categories(CareMode mode) {
    if (mode == CareMode.pregnancy || mode == CareMode.planning) {
      return const [
        ReminderCategory.water,
        ReminderCategory.vitamin,
        ReminderCategory.medicine,
        ReminderCategory.appointment,
        ReminderCategory.health,
        ReminderCategory.custom,
      ];
    }
    return const [
      ReminderCategory.feeding,
      ReminderCategory.sleep,
      ReminderCategory.diaper,
      ReminderCategory.vitamin,
      ReminderCategory.medicine,
      ReminderCategory.vaccine,
      ReminderCategory.appointment,
      ReminderCategory.water,
      ReminderCategory.custom,
    ];
  }

  String _defaultTitle(ReminderCategory category) => switch (category) {
    ReminderCategory.health => 'Sağlık kontrolü',
    ReminderCategory.water => 'Su içme hedefi',
    ReminderCategory.feeding => 'Beslenme zamanı',
    ReminderCategory.vaccine => 'Aşı randevusu',
    ReminderCategory.appointment => 'Randevu hatırlatması',
    ReminderCategory.vitamin => 'Vitamin zamanı',
    ReminderCategory.medicine => 'İlaç zamanı',
    ReminderCategory.sleep => 'Uyku rutini',
    ReminderCategory.diaper => 'Bez kontrolü',
    ReminderCategory.custom => 'Özel rutin',
  };

  String _categoryLabel(ReminderCategory category) => switch (category) {
    ReminderCategory.health => 'Sağlık',
    ReminderCategory.water => 'Su',
    ReminderCategory.feeding => 'Beslenme',
    ReminderCategory.vaccine => 'Aşı',
    ReminderCategory.appointment => 'Randevu',
    ReminderCategory.vitamin => 'Vitamin',
    ReminderCategory.medicine => 'İlaç',
    ReminderCategory.sleep => 'Uyku',
    ReminderCategory.diaper => 'Bez',
    ReminderCategory.custom => 'Özel',
  };

  IconData _categoryIcon(ReminderCategory category) => switch (category) {
    ReminderCategory.health => Icons.health_and_safety_outlined,
    ReminderCategory.water => Icons.water_drop_outlined,
    ReminderCategory.feeding => Icons.restaurant_rounded,
    ReminderCategory.vaccine => Icons.vaccines_rounded,
    ReminderCategory.appointment => Icons.event_available_rounded,
    ReminderCategory.vitamin => Icons.medication_liquid_rounded,
    ReminderCategory.medicine => Icons.medication_rounded,
    ReminderCategory.sleep => Icons.nightlight_round,
    ReminderCategory.diaper => Icons.baby_changing_station_rounded,
    ReminderCategory.custom => Icons.auto_awesome_rounded,
  };
}

class _PlanChip extends StatelessWidget {
  const _PlanChip({
    required this.type,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final ReminderPlanType type;
  final ReminderPlanType selected;
  final String label;
  final ValueChanged<ReminderPlanType> onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected == type,
      label: Text(label),
      onSelected: (_) => onTap(type),
    );
  }
}

class _TimesEditor extends StatelessWidget {
  const _TimesEditor({
    required this.times,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
  });

  final List<TimeOfDay> times;
  final VoidCallback onAdd;
  final ValueChanged<TimeOfDay> onEdit;
  final ValueChanged<TimeOfDay> onRemove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final time in times)
          InputChip(
            label: Text(time.format(context)),
            avatar: const Icon(Icons.schedule_rounded, size: 18),
            onPressed: () => onEdit(time),
            onDeleted: times.length == 1 ? null : () => onRemove(time),
          ),
        ActionChip(
          avatar: const Icon(Icons.add_rounded),
          label: const Text('Saat ekle'),
          onPressed: onAdd,
        ),
      ],
    );
  }
}

class _WeekdayPicker extends StatelessWidget {
  const _WeekdayPicker({required this.selected, required this.onToggle});

  final Set<int> selected;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    const labels = {
      1: 'Pzt',
      2: 'Sal',
      3: 'Çar',
      4: 'Per',
      5: 'Cum',
      6: 'Cmt',
      7: 'Paz',
    };
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final entry in labels.entries)
          FilterChip(
            selected: selected.contains(entry.key),
            label: Text(entry.value),
            onSelected: (_) => onToggle(entry.key),
          ),
      ],
    );
  }
}

class _MonthDayPicker extends StatelessWidget {
  const _MonthDayPicker({required this.selected, required this.onToggle});

  final Set<int> selected;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    const days = [1, 5, 10, 15, 20, 25, 28, 30];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final day in days)
          FilterChip(
            selected: selected.contains(day),
            label: Text('$day. gün'),
            onSelected: (_) => onToggle(day),
          ),
      ],
    );
  }
}

class _HourlyWindow extends StatelessWidget {
  const _HourlyWindow({
    required this.startHour,
    required this.endHour,
    required this.onStart,
    required this.onEnd,
  });

  final int startHour;
  final int endHour;
  final ValueChanged<int> onStart;
  final ValueChanged<int> onEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HourDropdown(
            label: 'Başlangıç',
            value: startHour,
            onChanged: onStart,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _HourDropdown(
            label: 'Bitiş',
            value: endHour,
            onChanged: onEnd,
          ),
        ),
      ],
    );
  }
}

class _HourDropdown extends StatelessWidget {
  const _HourDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        for (var hour = 0; hour < 24; hour++)
          DropdownMenuItem(
            value: hour,
            child: Text('${hour.toString().padLeft(2, '0')}:00'),
          ),
      ],
      onChanged: (value) => onChanged(value ?? this.value),
    );
  }
}

class _StepperCard extends StatelessWidget {
  const _StepperCard({
    required this.title,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final String title;
  final String value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onMinus,
            icon: const Icon(Icons.remove_rounded),
            tooltip: 'Azalt',
          ),
          Expanded(
            child: Column(
              children: [
                Text(title, style: const TextStyle(fontSize: 11)),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onPlus,
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Artır',
          ),
        ],
      ),
    );
  }
}
