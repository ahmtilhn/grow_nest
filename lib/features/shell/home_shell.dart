import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_theme.dart';
import '../../domain/entities/app_entities.dart';
import '../baby_dashboard/baby_dashboard.dart';
import '../pregnancy/pregnancy_dashboard.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(appSnapshotProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.softGreen,
              child: Text(
                (snapshot.user?.name ?? 'M').substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              context.l10n.t('appName'),
              style: const TextStyle(
                color: AppColors.brand,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Bildirimler',
            onPressed: () => context.push('/notifications'),
            icon: Badge.count(
              count: snapshot.notifications
                  .where((item) => item.status.name == 'unread')
                  .length,
              isLabelVisible: snapshot.notifications.any(
                (item) => item.status.name == 'unread',
              ),
              child: const Icon(Icons.notifications_none_rounded),
            ),
          ),
          IconButton(
            tooltip: 'Profil',
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: shell,
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('main_fab'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _openQuickMenu(context, snapshot.mode),
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Ana Sayfa',
          ),
          const NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics_rounded),
            label: 'Takip',
          ),
          const NavigationDestination(
            icon: Icon(Icons.vaccines_outlined),
            selectedIcon: Icon(Icons.vaccines_rounded),
            label: 'Aşılar',
          ),
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Makaleler',
          ),
          const NavigationDestination(
            icon: Icon(Icons.groups_2_outlined),
            selectedIcon: Icon(Icons.groups_2_rounded),
            label: 'Aile',
          ),
        ],
      ),
    );
  }

  Future<void> _openQuickMenu(BuildContext context, CareMode mode) {
    final actions = mode == CareMode.pregnancy
        ? [
            (RecordType.water, 'Su', Icons.water_drop_outlined),
            (RecordType.vitamin, 'Vitamin', Icons.medication_liquid_rounded),
            (RecordType.appointment, 'Kontrol', Icons.event_available_rounded),
            (RecordType.health, 'Belirti', Icons.health_and_safety_outlined),
            (RecordType.memory, 'Günlük', Icons.edit_note_rounded),
          ]
        : [
            (RecordType.feeding, 'Besle', Icons.restaurant_rounded),
            (
              RecordType.diaper,
              'Alt değiştir',
              Icons.baby_changing_station_rounded,
            ),
            (RecordType.sleep, 'Uyku', Icons.nightlight_round),
            (RecordType.growth, 'Ölçüm', Icons.straighten_rounded),
            (RecordType.health, 'Ateş', Icons.thermostat_rounded),
            (RecordType.memory, 'Anı', Icons.edit_note_rounded),
          ];
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mode == CareMode.baby ? 'Yeni kayıt' : 'Hızlı kayıt',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ortak aile profilinde paylaşılacak işlemi seçin.',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.9,
                children: [
                  for (final action in actions)
                    _QuickSheetAction(
                      icon: action.$3,
                      label: action.$2,
                      onTap: () {
                        Navigator.of(context).pop();
                        if (action.$1 == RecordType.sleep) {
                          context.push('/sleep');
                        } else {
                          context.push('/add/${action.$1.name}');
                        }
                      },
                    ),
                  _QuickSheetAction(
                    icon: Icons.alarm_add_rounded,
                    label: 'Hatırlatıcı',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/reminder/new');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickSheetAction extends StatelessWidget {
  const _QuickSheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.softBlue,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(icon, size: 19, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GrowthRootScreen extends ConsumerWidget {
  const GrowthRootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(appSnapshotProvider);
    if (snapshot.mode == CareMode.baby) return const BabyDashboardScreen();
    if (snapshot.mode == CareMode.planning) {
      return const PlanningDashboardScreen();
    }
    return const PregnancyDashboardScreen();
  }
}
