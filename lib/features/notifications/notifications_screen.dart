import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(appControllerProvider);
      await controller.refreshFamilyInvites();
      await controller.refreshRemoteFamilies();
      await controller.markAllNotificationsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appSnapshotProvider);
    final controller = ref.read(appControllerProvider);
    final items = controller.snapshot.notifications
        .where((item) => _filter == 'all' || item.category == _filter)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Bildirimler'),
      ),
      body: AppScreen(
        title: 'Bildirimler',
        subtitle: 'Minik adımlardan gelen güncellemeler ve hatırlatıcılar.',
        bottomPadding: 32,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip('all', 'Tümü', _filter, _setFilter),
              _FilterChip('system', 'Sistem', _filter, _setFilter),
              _FilterChip('family', 'Aile', _filter, _setFilter),
              _FilterChip('health', 'Sağlık', _filter, _setFilter),
            ],
          ),
          const SizedBox(height: 22),
          if (items.isEmpty)
            EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'Şimdilik bildirim yok',
              body:
                  'Aile davetleri, aşı yaklaşımı ve hatırlatıcılar burada görünecek.',
              actionLabel: 'Hatırlatıcı Ekle',
              onAction: () => context.push('/reminder/new'),
            )
          else ...[
            for (final group in _groups(items)) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 4),
                child: Text(
                  group.$1,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              for (final item in group.$2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _NotificationCard(
                    notification: item,
                    invite: _inviteFor(controller.snapshot.invites, item),
                    onRead: () => controller.markNotificationRead(item.id),
                    onAccept: () => _respondToInvite(
                      controller,
                      item.payload,
                      accept: true,
                    ),
                    onDecline: () => _respondToInvite(
                      controller,
                      item.payload,
                      accept: false,
                    ),
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }

  void _setFilter(String filter) => setState(() => _filter = filter);

  Future<void> _respondToInvite(
    AppController controller,
    String? inviteId, {
    required bool accept,
  }) async {
    if (inviteId == null) return;
    try {
      if (accept) {
        await controller.acceptFamilyInvite(inviteId);
      } else {
        await controller.declineFamilyInvite(inviteId);
      }
      if (!mounted) return;
      showAppSnack(
        context,
        accept ? 'Davet kabul edildi.' : 'Davet reddedildi.',
      );
    } catch (error) {
      if (!mounted) return;
      showAppSnack(context, userFacingErrorMessage(error));
    }
  }

  List<(String, List<AppNotification>)> _groups(List<AppNotification> items) {
    final today = <AppNotification>[];
    final yesterday = <AppNotification>[];
    final older = <AppNotification>[];
    final now = DateTime.now();
    for (final item in items) {
      final days = DateTime(now.year, now.month, now.day)
          .difference(
            DateTime(
              item.createdAt.year,
              item.createdAt.month,
              item.createdAt.day,
            ),
          )
          .inDays;
      if (days == 0) {
        today.add(item);
      } else if (days == 1) {
        yesterday.add(item);
      } else {
        older.add(item);
      }
    }
    return [
      if (today.isNotEmpty) ('BUGÜN', today),
      if (yesterday.isNotEmpty) ('DÜN', yesterday),
      if (older.isNotEmpty) ('DAHA ÖNCE', older),
    ];
  }

  FamilyInvite? _inviteFor(
    List<FamilyInvite> invites,
    AppNotification notification,
  ) {
    final inviteId = notification.payload;
    if (inviteId == null) return null;
    for (final invite in invites) {
      if (invite.id == inviteId) return invite;
    }
    return null;
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(this.value, this.label, this.selected, this.onTap);

  final String value;
  final String label;
  final String selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: value == selected,
      label: Text(label),
      onSelected: (_) => onTap(value),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.invite,
    required this.onRead,
    required this.onAccept,
    required this.onDecline,
  });

  final AppNotification notification;
  final FamilyInvite? invite;
  final VoidCallback onRead;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final unread = notification.status == AppNotificationStatus.unread;
    final actionableInvite =
        notification.type == 'family_invite' &&
        invite?.status == FamilyInviteStatus.pending;
    return AppCard(
      onTap: unread ? onRead : null,
      borderColor: unread ? const Color(0xFFBDE8F7) : AppColors.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SoftIcon(icon: _icon(notification.category), color: _color()),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        Text(
                          _time(notification.createdAt),
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (actionableInvite) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecline,
                    child: const Text('Reddet'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: onAccept,
                    child: const Text('Onayla'),
                  ),
                ),
              ],
            ),
          ],
          if (invite != null && !actionableInvite) ...[
            const SizedBox(height: 10),
            Chip(label: Text('Davet: ${invite!.status.name}')),
          ],
        ],
      ),
    );
  }

  Color _color() => switch (notification.category) {
    'family' => AppColors.softPink,
    'health' => AppColors.softGreen,
    _ => AppColors.softBlue,
  };

  IconData _icon(String category) => switch (category) {
    'family' => Icons.group_add_rounded,
    'health' => Icons.health_and_safety_outlined,
    _ => Icons.notifications_none_rounded,
  };

  String _time(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
