import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class VaccineCalendarScreen extends ConsumerStatefulWidget {
  const VaccineCalendarScreen({super.key});

  @override
  ConsumerState<VaccineCalendarScreen> createState() =>
      _VaccineCalendarScreenState();
}

class _VaccineCalendarScreenState extends ConsumerState<VaccineCalendarScreen> {
  final Set<String> _pendingIds = <String>{};

  Future<void> _toggleVaccine(
    AppController controller,
    VaccineEvent vaccine,
    bool completed,
  ) async {
    if (_pendingIds.contains(vaccine.id)) return;
    setState(() => _pendingIds.add(vaccine.id));
    try {
      await controller.completeVaccine(vaccine.id, completed);
    } catch (error) {
      if (!mounted) return;
      showAppSnack(context, userFacingErrorMessage(error));
    } finally {
      if (mounted) {
        setState(() => _pendingIds.remove(vaccine.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appSnapshotProvider);
    final controller = ref.read(appControllerProvider);
    final baby = controller.snapshot.baby;
    final vaccines = controller.snapshot.vaccines;
    final next = vaccines
        .where((item) => item.status != VaccineStatus.completed)
        .cast<VaccineEvent?>()
        .firstWhere((item) => item != null, orElse: () => null);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Aşı Takvimi'),
      ),
      body: AppScreen(
        title: 'Aşı Takvimi',
        subtitle:
            'AAP 2026 ve CDC/ACIP takvimine göre yaklaşan kontrolleri sakin biçimde takip edin.',
        bottomPadding: 32,
        children: [
          if (baby == null)
            EmptyState(
              icon: Icons.child_care_rounded,
              title: 'Bebek profili gerekli',
              body:
                  'Aşı takvimi doğum tarihine göre hesaplanır. Bebek bilgilerini ekleyince liste açılır.',
              actionLabel: 'Profile Git',
              onAction: () => context.push('/profile'),
            )
          else ...[
            AppCard(
              color: AppColors.softBlue,
              borderColor: const Color(0xFFD7E8F8),
              child: Row(
                children: [
                  const SoftIcon(
                    icon: Icons.event_available_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      next == null
                          ? 'Tüm kayıtlı aşılar tamamlandı görünüyor.'
                          : 'Sıradaki randevu\n${next.title} • ${_date(next.dueDate)}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/reminder/new'),
                    child: const Text('Randevu ekle'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Aşı Programı'),
            const SizedBox(height: 10),
            for (final vaccine in vaccines)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _VaccineTile(
                  vaccine: vaccine,
                  busy: _pendingIds.contains(vaccine.id),
                  onChanged: (value) =>
                      _toggleVaccine(controller, vaccine, value),
                ),
              ),
            const SizedBox(height: 12),
            const AppCard(
              color: AppColors.softGreen,
              borderColor: Color(0xFFD3E3DC),
              child: Text(
                'Kaynak: AAP 2026 çocuk ve ergen aşı takvimi. Yerel ülke takvimi, stok, önceki doz ve sağlık durumuna göre doktorunuzun planı önceliklidir.',
              ),
            ),
            const SizedBox(height: 12),
            const MedicalWarningCard(),
          ],
        ],
      ),
    );
  }

  String _date(DateTime date) => '${date.day}.${date.month}.${date.year}';
}

class _VaccineTile extends StatelessWidget {
  const _VaccineTile({
    required this.vaccine,
    required this.onChanged,
    required this.busy,
  });

  final VaccineEvent vaccine;
  final ValueChanged<bool> onChanged;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final completed = vaccine.status == VaccineStatus.completed;
    final overdue = vaccine.status == VaccineStatus.overdue;
    return AppCard(
      onTap: busy ? null : () => onChanged(!completed),
      borderColor: overdue ? const Color(0xFFFFC9C9) : AppColors.border,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          busy
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Checkbox(
                  value: completed,
                  onChanged: (value) => onChanged(value ?? false),
                ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        vaccine.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          decoration: completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(
                        completed
                            ? 'TAMAMLANDI'
                            : overdue
                            ? 'GECİKTİ'
                            : 'YAKLAŞAN',
                      ),
                    ),
                  ],
                ),
                Text(vaccine.dose),
                const SizedBox(height: 6),
                Text(
                  'Tahmini tarih: ${vaccine.dueDate.day}.${vaccine.dueDate.month}.${vaccine.dueDate.year}',
                  style: const TextStyle(color: AppColors.muted),
                ),
                if (vaccine.notes != null) ...[
                  const SizedBox(height: 6),
                  Text(vaccine.notes!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
