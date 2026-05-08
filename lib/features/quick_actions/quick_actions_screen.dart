import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class QuickActionsScreen extends ConsumerWidget {
  const QuickActionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(appControllerProvider);
    final mode = ref.watch(appSnapshotProvider).mode;
    final actions = switch (mode) {
      CareMode.baby => [
        (RecordType.feeding, 'Beslenme ekle', Icons.restaurant_rounded),
        (
          RecordType.diaper,
          'Alt değiştirdim',
          Icons.baby_changing_station_rounded,
        ),
        (RecordType.sleep, 'Uyku rutini', Icons.nightlight_round),
        (RecordType.vitamin, 'Vitamin / ilaç', Icons.medication_liquid_rounded),
        (RecordType.health, 'Ateş / belirti', Icons.thermostat_rounded),
      ],
      CareMode.planning => [
        (RecordType.memory, 'Planlama notu', Icons.edit_note_rounded),
        (
          RecordType.appointment,
          'Randevu sorusu',
          Icons.event_available_rounded,
        ),
        (RecordType.water, 'Su kaydı', Icons.water_drop_outlined),
        (RecordType.health, 'Belirti notu', Icons.health_and_safety_outlined),
      ],
      CareMode.pregnancy => [
        (RecordType.water, 'Su içtim', Icons.water_drop_outlined),
        (RecordType.vitamin, 'Vitamin aldım', Icons.medication_liquid_rounded),
        (RecordType.appointment, 'Kontrol notu', Icons.event_available_rounded),
        (RecordType.health, 'Belirti notu', Icons.health_and_safety_outlined),
      ],
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Hızlı Onay')),
      body: AppScreen(
        bottomPadding: 32,
        children: [
          Image.asset(
            'assets/images/widget_mock.png',
            height: 260,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 18),
          AppCard(
            child: const Text(
              'Bu ekranda tek dokunuşla güvenli kayıt başlatabilirsiniz. Miktar veya belirti gereken durumlarda ayrıntı formu açılır.',
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final action in actions)
                ActionChip(
                  avatar: Icon(action.$3),
                  label: Text(action.$2),
                  onPressed: () async {
                    if (action.$1 == RecordType.sleep) {
                      context.push('/sleep');
                      return;
                    }
                    if (_needsDetail(action.$1)) {
                      context.push('/add/${action.$1.name}');
                      return;
                    }
                    await controller.addRecord(
                      type: action.$1,
                      title: action.$2,
                      value: action.$1 == RecordType.diaper ? 'Islak' : null,
                    );
                    if (context.mounted) {
                      showAppSnack(context, '${action.$2} kaydedildi.');
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _needsDetail(RecordType type) => switch (type) {
    RecordType.feeding ||
    RecordType.health ||
    RecordType.water ||
    RecordType.vitamin ||
    RecordType.appointment ||
    RecordType.memory => true,
    _ => false,
  };
}
