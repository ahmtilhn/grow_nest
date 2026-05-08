import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class EducationScreen extends ConsumerStatefulWidget {
  const EducationScreen({super.key});

  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
  final _search = TextEditingController();
  String? _category;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appSnapshotProvider);
    final controller = ref.read(appControllerProvider);
    final mode = controller.snapshot.mode;
    final allArticles = controller.snapshot.articles
        .where((article) => article.careMode == mode.name)
        .toList();
    final query = _search.text.trim();
    final articles = _rankedArticles(allArticles, query)
        .where((article) => _category == null || article.category == _category)
        .toList();
    final saved = articles.where((article) => article.isSaved).toList();
    final categories = allArticles.map((article) => article.category).toSet();
    final bestMatch = query.isEmpty || articles.isEmpty ? null : articles.first;
    return Scaffold(
      appBar: AppBar(title: const Text('Eğitim ve Rehber')),
      body: AppScreen(
        subtitle: switch (mode) {
          CareMode.pregnancy =>
            'Gebelik haftana uygun psikolojik destek ve hazırlık rehberleri.',
          CareMode.planning =>
            'Planlama döneminde güvenlik, destek ve randevu hazırlığı rehberleri.',
          CareMode.baby =>
            'Bebeğinizin sağlıklı gelişimi için güvenilir bakım rehberleri.',
        },
        bottomPadding: 32,
        children: [
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: 'Sağlık konularında arama yapın...',
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => setState(_search.clear),
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 18),
          const SectionHeader(title: 'Kategoriler', action: 'TÜMÜ'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              ChoiceChip(
                selected: _category == null,
                label: const Text('Tümü'),
                onSelected: (_) => setState(() => _category = null),
              ),
              for (final category in categories)
                ChoiceChip(
                  selected: _category == category,
                  label: Text(category),
                  onSelected: (_) => setState(() => _category = category),
                ),
            ],
          ),
          if (bestMatch != null) ...[
            const SizedBox(height: 18),
            AppCard(
              color: AppColors.softGreen,
              borderColor: const Color(0xFFD3E3DC),
              onTap: () => context.push('/education/article/${bestMatch.id}'),
              child: Row(
                children: [
                  const SoftIcon(icon: Icons.manage_search_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'En yakın sonuç\n${bestMatch.title}\n${bestMatch.summary}',
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 22),
          const SectionHeader(title: 'Öne Çıkan Rehberler'),
          const SizedBox(height: 10),
          for (final article in articles)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                onTap: () => context.push('/education/article/${article.id}'),
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg),
                      ),
                      child: Image.asset(
                        _imageFor(article),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(label: Text('${article.sourceName} ÖNERİSİ')),
                          Text(
                            article.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          Text(article.summary),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => context.push(
                                  '/education/article/${article.id}',
                                ),
                                child: const Text('Okumaya Başla →'),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () =>
                                    controller.toggleSavedArticle(article.id),
                                icon: Icon(
                                  article.isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border_rounded,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SectionHeader(title: 'Kaydettiklerim'),
          const SizedBox(height: 10),
          saved.isEmpty
              ? EmptyState(
                  icon: Icons.library_add_outlined,
                  title: 'Henüz makale kaydetmediniz',
                  body:
                      'İlginizi çeken rehberleri daha sonra okumak için kaydedebilirsiniz.',
                  actionLabel: 'Rehberlere Dön',
                  onAction: () {},
                )
              : Column(
                  children: [
                    for (final article in saved)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(article.title),
                        subtitle: Text(article.sourceName),
                        onTap: () =>
                            context.push('/education/article/${article.id}'),
                        trailing: IconButton(
                          tooltip: 'Kaydedilenlerden çıkar',
                          onPressed: () =>
                              controller.toggleSavedArticle(article.id),
                          icon: const Icon(Icons.bookmark_remove_outlined),
                        ),
                      ),
                  ],
                ),
        ],
      ),
    );
  }

  String _imageFor(Article article) {
    if (article.careMode == CareMode.pregnancy.name ||
        article.careMode == CareMode.planning.name) {
      return switch (article.category) {
        'Ruh Sağlığı' => 'assets/images/room_plant.png',
        'Hazırlık' => 'assets/images/nursery.png',
        _ => 'assets/images/yoga.png',
      };
    }
    return switch (article.category) {
      'Beslenme' => 'assets/images/nutrition.png',
      'Gelişim' => 'assets/images/baby_smile.png',
      'Ağız Sağlığı' => 'assets/images/first_tooth.png',
      'Güvenlik' => 'assets/images/first_aid.png',
      'Medya' => 'assets/images/room_plant.png',
      'Ruh Sağlığı' => 'assets/images/room_plant.png',
      _ => 'assets/images/sleeping_baby.png',
    };
  }

  List<Article> _rankedArticles(List<Article> articles, String query) {
    if (query.trim().isEmpty) return articles;
    final tokens = query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((token) => token.length > 1)
        .toList();
    final scored = [
      for (final article in articles)
        (
          article,
          tokens.fold<int>(0, (score, token) {
            final title = article.title.toLowerCase();
            final category = article.category.toLowerCase();
            final summary = article.summary.toLowerCase();
            final content = article.content.toLowerCase();
            return score +
                (title.contains(token) ? 6 : 0) +
                (category.contains(token) ? 4 : 0) +
                (summary.contains(token) ? 3 : 0) +
                (content.contains(token) ? 1 : 0);
          }),
        ),
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    return scored.where((item) => item.$2 > 0).map((item) => item.$1).toList();
  }
}
