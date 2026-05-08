import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _noteController = TextEditingController();
  bool _saving = false;
  String _mood = 'Bugün';

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final note = _noteController.text.trim();
    if (note.isEmpty) {
      showAppSnack(context, 'Önce kısa bir not yazın.');
      return;
    }
    setState(() => _saving = true);
    final title = note.split('\n').first.trim();
    final datedNote = 'Etiket: $_mood\n$note';
    await ref
        .read(appControllerProvider)
        .addRecord(
          type: RecordType.memory,
          title: title.length > 42 ? '${title.substring(0, 42)}...' : title,
          note: datedNote,
        );
    _noteController.clear();
    if (mounted) {
      setState(() => _saving = false);
      showAppSnack(context, 'Günlük notu kaydedildi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(appSnapshotProvider);
    final isPregnancy = snapshot.mode == CareMode.pregnancy;
    final memories = snapshot.records
        .where((record) => record.type == RecordType.memory)
        .toList();
    return AppScreen(
      title: isPregnancy ? 'Gebelik Günlüğü' : 'Bebek Günlüğü',
      subtitle: isPregnancy
          ? 'Kendine, bedenine ve bebeğine dair notları sakla.'
          : 'Birlikte biriktirdiğimiz en güzel anlar.',
      children: [
        SectionHeader(
          title: isPregnancy ? 'Hazırlık Alanı' : 'İlk Anlar Galerisi',
          action: 'Tümünü Gör',
          onAction: () => context.push('/add/${RecordType.memory.name}'),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: _GalleryTile(
                label: isPregnancy ? 'Sakin an' : 'İlk Tanışma',
                image: isPregnancy
                    ? 'assets/images/yoga.png'
                    : 'assets/images/swaddled_baby.png',
                height: 150,
                onTap: () => context.push('/add/${RecordType.memory.name}'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  _GalleryTile(
                    label: isPregnancy ? 'Hazırlık' : 'Banyo Keyfi',
                    image: isPregnancy
                        ? 'assets/images/nursery.png'
                        : 'assets/images/baby_smile.png',
                    height: 70,
                    onTap: () => context.push('/add/${RecordType.memory.name}'),
                  ),
                  const SizedBox(height: 10),
                  _GalleryTile(
                    label: isPregnancy ? 'Nefes' : 'Derin Uyku',
                    image: isPregnancy
                        ? 'assets/images/room_plant.png'
                        : 'assets/images/sleeping_baby.png',
                    height: 70,
                    onTap: () => isPregnancy
                        ? context.push('/add/${RecordType.memory.name}')
                        : context.push('/sleep'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        AppCard(
          color: AppColors.softPink,
          borderColor: const Color(0xFFF7CADB),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SoftIcon(
                    icon: Icons.favorite_rounded,
                    color: Color(0xFFF2CBD8),
                    iconColor: Color(0xFF8B5F70),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isPregnancy ? 'Kendime Not' : 'Bebeğime Not',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final mood in [
                    'Bugün',
                    'Minik tekme',
                    'Kontrol günü',
                    'Tatlı telaş',
                    'İlkler',
                  ])
                    ChoiceChip(
                      selected: _mood == mood,
                      label: Text(mood),
                      onSelected: (_) => setState(() => _mood = mood),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                minLines: 4,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: isPregnancy
                      ? 'Bugün kendine ne söylemek istersin?'
                      : 'Bugün ona ne söylemek istersin?',
                  filled: true,
                  fillColor: Colors.white54,
                ),
                onSubmitted: (_) => _saveNote(),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _saving ? null : _saveNote,
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Kaydet'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'Anı Zaman Tüneli'),
        const SizedBox(height: 10),
        if (memories.isEmpty) ...[
          EmptyState(
            icon: Icons.edit_note_rounded,
            title: 'Henüz günlük notu yok',
            body: 'İlk notunuzu yazınca burada tarih sırasıyla görünecek.',
            actionLabel: 'Not Yaz',
            onAction: () {},
          ),
        ] else
          for (var i = 0; i < memories.length; i++)
            _TimelineEntry(
              title: memories[i].title,
              body: memories[i].note ?? '',
              date: memories[i].occurredAt,
              actor: _memoryActor(memories[i], snapshot.user),
              index: i,
              onTap: () => _showMemory(context, memories[i]),
            ),
      ],
    );
  }

  Future<void> _showMemory(BuildContext context, TrackerRecord memory) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              memory.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(memory.note ?? ''),
            const SizedBox(height: 12),
            Text(
              _memoryActor(
                memory,
                ref.read(appControllerProvider).snapshot.user,
              ),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${memory.occurredAt.day}.${memory.occurredAt.month}.${memory.occurredAt.year}',
              style: const TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }

  String _memoryActor(TrackerRecord memory, UserProfile? currentUser) {
    if (currentUser != null && memory.createdByUserId == currentUser.id) {
      return 'Siz tarafından eklendi';
    }
    final name = memory.createdByName?.trim();
    if (name != null && name.isNotEmpty) {
      return '$name tarafından eklendi';
    }
    return 'Partner tarafından eklendi';
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({
    required this.label,
    required this.image,
    required this.height,
    required this.onTap,
  });

  final String label;
  final String image;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.asset(
              image,
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: .35),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 8,
              child: Text(label, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.title,
    required this.body,
    required this.date,
    required this.actor,
    required this.index,
    required this.onTap,
  });

  final String title;
  final String body;
  final DateTime date;
  final String actor;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.softPink,
      const Color(0xFFFFF4C7),
      AppColors.softBlue,
      AppColors.softGreen,
    ];
    final color = colors[index % colors.length];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: .96, end: 1),
        duration: Duration(milliseconds: 260 + index.clamp(0, 6) * 35),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: Transform.rotate(
          angle: index.isEven ? -.012 : .012,
          child: AppCard(
            color: color,
            borderColor: color,
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text(
                      '${date.day}.${date.month}.${date.year}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.primaryDark),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.push_pin_outlined, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(actor, style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
