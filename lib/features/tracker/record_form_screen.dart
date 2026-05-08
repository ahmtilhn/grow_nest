import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/ai/ai_analysis_service.dart';
import '../../core/utils/app_calculators.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class RecordFormScreen extends ConsumerStatefulWidget {
  const RecordFormScreen({super.key, this.typeName, this.recordId});

  final String? typeName;
  final String? recordId;

  @override
  ConsumerState<RecordFormScreen> createState() => _RecordFormScreenState();
}

class _RecordFormScreenState extends ConsumerState<RecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _value = TextEditingController();
  final _note = TextEditingController();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _head = TextEditingController();
  late RecordType _type;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  AiAnalysisResult? _analysis;
  bool _saving = false;
  TrackerRecord? _editingRecord;

  @override
  void initState() {
    super.initState();
    _type = RecordType.values.firstWhere(
      (type) => type.name == widget.typeName,
      orElse: () => RecordType.feeding,
    );
    _title.text = _defaultTitle(_type);
    final recordId = widget.recordId;
    if (recordId != null) {
      final existing = ref
          .read(appControllerProvider)
          .snapshot
          .records
          .where((item) => item.id == recordId)
          .cast<TrackerRecord?>()
          .firstWhere((item) => item != null, orElse: () => null);
      if (existing != null) {
        _editingRecord = existing;
        _type = existing.type;
        _title.text = existing.title;
        _note.text = existing.note ?? '';
        _date = existing.occurredAt;
        _time = TimeOfDay(
          hour: existing.occurredAt.hour,
          minute: existing.occurredAt.minute,
        );
        _seedValueFields(existing);
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _value.dispose();
    _note.dispose();
    _weight.dispose();
    _height.dispose();
    _head.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final controller = ref.read(appControllerProvider);
    try {
      final occurredAt = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      );
      if (_type == RecordType.growth) {
        final weight = ValidationUtils.positiveDouble(_weight.text);
        final height = ValidationUtils.positiveDouble(_height.text);
        final head = ValidationUtils.positiveDouble(_head.text);
        if (weight == null && height == null && head == null) {
          showAppSnack(context, 'En az bir ölçüm girin.');
          return;
        }
        if (_editingRecord != null) {
          await controller.updateRecord(
            _editingRecord!.copyWith(
              title: _title.text.trim(),
              value: _growthValueForSave(weight, height, head),
              note: _note.text.trim().isEmpty ? null : _note.text.trim(),
              occurredAt: occurredAt,
            ),
          );
        } else {
          await controller.addGrowthRecord(
            weightKg: weight,
            heightCm: height,
            headCm: head,
            occurredAt: occurredAt,
          );
        }
        if (!mounted) return;
        showAppSnack(
          context,
          _editingRecord == null ? 'Ölçüm kaydedildi.' : 'Ölçüm güncellendi.',
        );
        context.go('/growth');
        return;
      }
      AiAnalysisResult? healthAnalysis;
      final fever = ValidationUtils.positiveDouble(_value.text);
      if (_type == RecordType.health) {
        final rawAnalysis = await controller.ai.analyzeHealth(
          _note.text.isEmpty ? _title.text : _note.text,
          fever: fever,
        );
        healthAnalysis = _ageAdjustedHealthAnalysis(
          controller,
          rawAnalysis,
          fever,
        );
        _analysis = healthAnalysis;
        if (mounted) setState(() {});
      }
      final value = _valueForSave();
      if (_editingRecord != null) {
        await controller.updateRecord(
          _editingRecord!.copyWith(
            type: _type,
            title: _title.text.trim(),
            value: value,
            note: _note.text.trim().isEmpty ? null : _note.text.trim(),
            occurredAt: occurredAt,
          ),
        );
      } else {
        await controller.addRecord(
          type: _type,
          title: _title.text,
          value: value,
          note: _note.text,
          occurredAt: occurredAt,
        );
      }
      if (!mounted) return;
      if (healthAnalysis != null) {
        await _showHealthAnalysisDialog(healthAnalysis);
        if (!mounted) return;
      }
      showAppSnack(
        context,
        _editingRecord == null ? 'Kayıt kaydedildi.' : 'Kayıt güncellendi.',
      );
      final destination = switch (_type) {
        RecordType.growth => '/growth',
        RecordType.memory => '/journal',
        _ => '/tracker',
      };
      context.go(destination);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(appSnapshotProvider).mode;
    final availableTypes = _availableTypes(mode);
    if (!availableTypes.contains(_type)) {
      _type = availableTypes.first;
      _title.text = _defaultTitle(_type);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editingRecord == null
              ? '${_label(_type)} Ekle'
              : '${_label(_type)} Düzenle',
        ),
      ),
      body: AppScreen(
        bottomPadding: 32,
        children: [
          AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (widget.typeName == null)
                    DropdownButtonFormField<RecordType>(
                      initialValue: _type,
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      items: availableTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(_label(type)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _type = value ?? _type;
                          _title.text = _defaultTitle(_type);
                          _value.clear();
                        });
                      },
                    )
                  else
                    _SelectedCategoryHeader(type: _type),
                  const SizedBox(height: 12),
                  AppTextField(
                    key: const ValueKey('record_title'),
                    controller: _title,
                    label: 'Başlık',
                    validator: (value) =>
                        (value ?? '').trim().isEmpty ? 'Başlık girin.' : null,
                  ),
                  const SizedBox(height: 12),
                  if (_type == RecordType.growth)
                    _GrowthFields(weight: _weight, height: _height, head: _head)
                  else if (_type == RecordType.diaper)
                    _DiaperFields(
                      value: _value.text,
                      onChanged: (value) => _value.text = value,
                    )
                  else ...[
                    if (_showValueField(_type)) ...[
                      AppTextField(
                        key: const ValueKey('record_value'),
                        controller: _value,
                        label: _valueLabel(_type),
                        hint: _valueHint(_type),
                        keyboardType: _numericType(_type)
                            ? TextInputType.number
                            : TextInputType.text,
                        validator: (value) => _valueValidator(_type, value),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                  _DateTimePickerRow(
                    date: _date,
                    time: _time,
                    onPickDate: _pickDate,
                    onPickTime: _pickTime,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _note,
                    label: _noteLabel(_type),
                    maxLines: _type == RecordType.memory ? 5 : 3,
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    key: const ValueKey('record_save'),
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_editingRecord == null ? 'Kaydet' : 'Güncelle'),
                  ),
                  if (_editingRecord != null) ...[
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _saving ? null : _delete,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.danger,
                      ),
                      label: const Text(
                        'Kaydı Sil',
                        style: TextStyle(color: AppColors.danger),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_type == RecordType.health) ...[
            const SizedBox(height: 12),
            _analysis == null
                ? const MedicalWarningCard()
                : _HealthAnalysisCard(analysis: _analysis!),
          ],
        ],
      ),
    );
  }

  Future<void> _delete() async {
    final record = _editingRecord;
    if (record == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kaydı sil'),
        content: const Text(
          'Bu kayıt ortak aile görünümünden kaldırılacak. Diğer bağlı hesaplarda da kaybolur.',
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
    await ref.read(appControllerProvider).deleteRecord(record.id);
    if (!mounted) return;
    showAppSnack(context, 'Kayıt silindi.');
    context.go(record.type == RecordType.growth ? '/growth' : '/tracker');
  }

  String _defaultTitle(RecordType type) => switch (type) {
    RecordType.feeding => 'Beslenme',
    RecordType.diaper => 'Bez değişimi',
    RecordType.sleep => 'Uyku',
    RecordType.growth => 'Ölçüm',
    RecordType.health => 'Sağlık kaydı',
    RecordType.solidFood => 'Katı gıda',
    RecordType.memory => 'Anı',
    RecordType.water => 'Su takibi',
    RecordType.vitamin => 'Vitamin',
    RecordType.appointment => 'Randevu',
    RecordType.reminder => 'Hatırlatıcı',
    RecordType.milkStock => 'Süt stoğu',
  };

  String _label(RecordType type) => _defaultTitle(type);

  List<RecordType> _availableTypes(CareMode mode) {
    if (mode == CareMode.pregnancy) {
      return const [
        RecordType.water,
        RecordType.vitamin,
        RecordType.appointment,
        RecordType.health,
        RecordType.memory,
      ];
    }
    if (mode == CareMode.planning) {
      return const [
        RecordType.memory,
        RecordType.appointment,
        RecordType.health,
        RecordType.water,
        RecordType.vitamin,
      ];
    }
    return const [
      RecordType.feeding,
      RecordType.diaper,
      RecordType.sleep,
      RecordType.growth,
      RecordType.health,
      RecordType.solidFood,
      RecordType.milkStock,
      RecordType.vitamin,
      RecordType.appointment,
      RecordType.memory,
    ];
  }

  bool _showValueField(RecordType type) => switch (type) {
    RecordType.memory => false,
    RecordType.reminder => false,
    _ => true,
  };

  bool _numericType(RecordType type) => switch (type) {
    RecordType.water ||
    RecordType.health ||
    RecordType.feeding ||
    RecordType.sleep ||
    RecordType.milkStock => true,
    _ => false,
  };

  String _valueLabel(RecordType type) => switch (type) {
    RecordType.feeding => 'Miktar (ml)',
    RecordType.sleep => 'Süre (dk)',
    RecordType.health => 'Ateş / değer',
    RecordType.solidFood => 'Besin adı',
    RecordType.milkStock => 'Süt miktarı (ml)',
    RecordType.water => 'Miktar (ml)',
    RecordType.vitamin => 'Doz / miktar',
    RecordType.appointment => 'Doktor / kurum',
    _ => 'Değer',
  };

  String _valueHint(RecordType type) => switch (type) {
    RecordType.feeding => '90',
    RecordType.sleep => '45',
    RecordType.health => '37.2',
    RecordType.solidFood => 'Avokado püresi',
    RecordType.milkStock => '120',
    RecordType.water => '250',
    RecordType.vitamin => '1 tablet / 5 damla',
    RecordType.appointment => 'Kadın doğum kontrolü',
    _ => '',
  };

  String _noteLabel(RecordType type) => switch (type) {
    RecordType.appointment => 'Randevu detayları ve sorular',
    RecordType.memory => 'Günlük notu',
    RecordType.health => 'Belirti, süre ve ek gözlem',
    RecordType.water => 'Not',
    RecordType.vitamin => 'İlaç/vitamin adı ve talimat',
    _ => 'Not',
  };

  String? _valueValidator(RecordType type, String? value) {
    if ((value ?? '').trim().isEmpty) return null;
    return switch (type) {
      RecordType.health => _optionalNumberRange(
        value,
        label: 'Ateş',
        min: 34,
        max: 43,
        unit: '°C',
      ),
      RecordType.feeding || RecordType.milkStock => _optionalNumberRange(
        value,
        label: 'Miktar',
        min: 1,
        max: 500,
        unit: 'ml',
      ),
      RecordType.water => _optionalNumberRange(
        value,
        label: 'Su miktarı',
        min: 1,
        max: 5000,
        unit: 'ml',
      ),
      RecordType.sleep => _optionalNumberRange(
        value,
        label: 'Uyku süresi',
        min: 1,
        max: 1440,
        unit: 'dk',
      ),
      _ => null,
    };
  }

  String? _valueForSave() {
    final raw = _value.text.trim();
    if (_type == RecordType.diaper && raw.isEmpty) return 'Islak';
    if (raw.isEmpty) return null;
    return switch (_type) {
      RecordType.feeding => _withUnit(raw, 'ml'),
      RecordType.water => _withUnit(raw, 'ml'),
      RecordType.sleep => _withUnit(raw, 'dk'),
      RecordType.milkStock => _withUnit(raw, 'ml'),
      RecordType.health => raw.contains('°') ? raw : '$raw °C',
      _ => raw,
    };
  }

  String _growthValueForSave(double? weight, double? height, double? head) {
    final parts = <String>[
      if (weight != null) 'weightKg=$weight',
      if (height != null) 'heightCm=$height',
      if (head != null) 'headCm=$head',
    ];
    return parts.join(';');
  }

  void _seedValueFields(TrackerRecord record) {
    if (record.type == RecordType.growth) {
      final parts = (record.value ?? '').split(';');
      for (final part in parts) {
        final pieces = part.split('=');
        if (pieces.length != 2) continue;
        final key = pieces.first.trim();
        final value = pieces.last.trim();
        switch (key) {
          case 'weightKg':
            _weight.text = value;
            break;
          case 'heightCm':
            _height.text = value;
            break;
          case 'headCm':
            _head.text = value;
            break;
        }
      }
      return;
    }
    _value.text = (record.value ?? '')
        .replaceAll(' ml', '')
        .replaceAll(' dk', '')
        .replaceAll(' °C', '');
  }

  AiAnalysisResult _ageAdjustedHealthAnalysis(
    AppController controller,
    AiAnalysisResult analysis,
    double? fever,
  ) {
    final baby = controller.snapshot.baby;
    if (baby == null || fever == null || fever < 38.0) return analysis;
    final ageDays = DateTime.now().difference(baby.birthDate).inDays;
    if (ageDays >= 0 && ageDays < 90) {
      return const AiAnalysisResult(
        summary:
            '3 aydan küçük bebekte ateş acil değerlendirme gerektirebilir.',
        recommendation:
            '38.0 °C ve üzeri ateşte beklemeden çocuk doktoru, nöbetçi sağlık hattı veya acil destekle görüşün. Bu yorum tıbbi teşhis veya tedavi yerine geçmez.',
        riskLevel: AiRiskLevel.urgent,
      );
    }
    return analysis;
  }

  Future<void> _showHealthAnalysisDialog(AiAnalysisResult analysis) {
    final urgent = analysis.riskLevel == AiRiskLevel.urgent;
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          urgent ? 'Acil değerlendirme gerekebilir' : 'Sağlık kaydı özeti',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(analysis.summary),
            const SizedBox(height: 10),
            Text(analysis.recommendation),
          ],
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

  String _withUnit(String value, String unit) {
    return value.toLowerCase().contains(unit.toLowerCase())
        ? value
        : '$value $unit';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }
}

String? _optionalNumberRange(
  String? value, {
  required String label,
  required double min,
  required double max,
  required String unit,
}) {
  final raw = (value ?? '').trim();
  if (raw.isEmpty) return null;
  final match = RegExp(r'(\d+(?:[,.]\d+)?)').firstMatch(raw);
  final parsed = match == null
      ? null
      : double.tryParse(match.group(1)!.replaceAll(',', '.'));
  if (parsed == null) return '$label için sayı girin.';
  if (parsed < min || parsed > max) {
    return '$label $min-$max $unit aralığında olmalı.';
  }
  return null;
}

class _HealthAnalysisCard extends StatelessWidget {
  const _HealthAnalysisCard({required this.analysis});

  final AiAnalysisResult analysis;

  @override
  Widget build(BuildContext context) {
    final urgent = analysis.riskLevel == AiRiskLevel.urgent;
    return AppCard(
      color: urgent ? AppColors.warning : AppColors.softGreen,
      borderColor: urgent ? const Color(0xFFFFC9C9) : const Color(0xFFD3E3DC),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SoftIcon(
            icon: urgent
                ? Icons.local_hospital_outlined
                : Icons.health_and_safety_outlined,
            color: Colors.white,
            iconColor: urgent ? AppColors.danger : AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  analysis.summary,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(analysis.recommendation),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedCategoryHeader extends StatelessWidget {
  const _SelectedCategoryHeader({required this.type});

  final RecordType type;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.softBlue,
      borderColor: const Color(0xFFD7E8F8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          SoftIcon(icon: _icon(type), size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _label(type),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  String _label(RecordType type) => switch (type) {
    RecordType.feeding => 'Beslenme',
    RecordType.diaper => 'Bez değişimi',
    RecordType.sleep => 'Uyku',
    RecordType.growth => 'Ölçüm',
    RecordType.health => 'Sağlık kaydı',
    RecordType.solidFood => 'Katı gıda',
    RecordType.memory => 'Anı',
    RecordType.water => 'Su takibi',
    RecordType.vitamin => 'Vitamin',
    RecordType.appointment => 'Randevu',
    RecordType.reminder => 'Hatırlatıcı',
    RecordType.milkStock => 'Süt stoğu',
  };

  IconData _icon(RecordType type) => switch (type) {
    RecordType.feeding => Icons.restaurant_rounded,
    RecordType.diaper => Icons.baby_changing_station_rounded,
    RecordType.sleep => Icons.nightlight_round,
    RecordType.growth => Icons.straighten_rounded,
    RecordType.health => Icons.health_and_safety_outlined,
    RecordType.solidFood => Icons.egg_alt_outlined,
    RecordType.milkStock => Icons.inventory_2_outlined,
    RecordType.water => Icons.water_drop_outlined,
    RecordType.vitamin => Icons.medication_liquid_rounded,
    RecordType.appointment => Icons.event_available_rounded,
    RecordType.memory => Icons.edit_note_rounded,
    RecordType.reminder => Icons.alarm_rounded,
  };
}

class _DiaperFields extends StatelessWidget {
  const _DiaperFields({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final current = value.isEmpty ? 'Islak' : value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: current,
        decoration: const InputDecoration(labelText: 'Bez durumu'),
        items: const [
          DropdownMenuItem(value: 'Islak', child: Text('Islak')),
          DropdownMenuItem(value: 'Kirli', child: Text('Kirli')),
          DropdownMenuItem(
            value: 'Islak + kirli',
            child: Text('Islak + kirli'),
          ),
          DropdownMenuItem(value: 'Kuru', child: Text('Kuru')),
        ],
        onChanged: (value) => onChanged(value ?? current),
      ),
    );
  }
}

class _DateTimePickerRow extends StatelessWidget {
  const _DateTimePickerRow({
    required this.date,
    required this.time,
    required this.onPickDate,
    required this.onPickTime,
  });

  final DateTime date;
  final TimeOfDay time;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppCard(
            onTap: onPickDate,
            padding: const EdgeInsets.all(12),
            child: Text('Tarih\n${date.day}.${date.month}.${date.year}'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppCard(
            onTap: onPickTime,
            padding: const EdgeInsets.all(12),
            child: Text('Saat\n${time.format(context)}'),
          ),
        ),
      ],
    );
  }
}

class _GrowthFields extends StatelessWidget {
  const _GrowthFields({
    required this.weight,
    required this.height,
    required this.head,
  });

  final TextEditingController weight;
  final TextEditingController height;
  final TextEditingController head;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          key: const ValueKey('growth_weight'),
          controller: weight,
          label: 'Kilo (kg)',
          hint: '7.2',
          keyboardType: TextInputType.number,
          validator: (value) => _optionalNumberRange(
            value,
            label: 'Kilo',
            min: 0.5,
            max: 30,
            unit: 'kg',
          ),
        ),
        const SizedBox(height: 12),
        AppTextField(
          key: const ValueKey('growth_height'),
          controller: height,
          label: 'Boy / uzunluk (cm)',
          hint: '64',
          keyboardType: TextInputType.number,
          validator: (value) => _optionalNumberRange(
            value,
            label: 'Boy',
            min: 30,
            max: 120,
            unit: 'cm',
          ),
        ),
        const SizedBox(height: 12),
        AppTextField(
          key: const ValueKey('growth_head'),
          controller: head,
          label: 'Baş çevresi (cm)',
          hint: '41.5',
          keyboardType: TextInputType.number,
          validator: (value) => _optionalNumberRange(
            value,
            label: 'Baş çevresi',
            min: 20,
            max: 60,
            unit: 'cm',
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
