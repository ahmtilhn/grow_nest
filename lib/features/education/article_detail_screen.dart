import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/url_actions.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class ArticleDetailScreen extends ConsumerWidget {
  const ArticleDetailScreen({super.key, required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appSnapshotProvider);
    final controller = ref.read(appControllerProvider);
    Article? article;
    for (final item in controller.snapshot.articles) {
      if (item.id == articleId) {
        article = item;
        break;
      }
    }
    if (article == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: const Text('Makale Detayı'),
        ),
        body: AppScreen(
          children: [
            EmptyState(
              icon: Icons.article_outlined,
              title: 'Makale bulunamadı',
              body:
                  'Bu rehber kaldırılmış veya henüz cihaza indirilmemiş olabilir.',
              actionLabel: 'Rehberlere Dön',
              onAction: () => context.go('/education'),
            ),
          ],
        ),
      );
    }
    final selectedArticle = article;
    final related = controller.snapshot.articles
        .where(
          (item) =>
              item.id != selectedArticle.id &&
              item.careMode == selectedArticle.careMode,
        )
        .take(3)
        .toList();
    final sections = selectedArticle.content
        .split(RegExp(r'(?<=\.)\s+'))
        .where((item) => item.trim().isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Makale Detayı'),
        actions: [
          IconButton(
            onPressed: () => controller.toggleSavedArticle(selectedArticle.id),
            icon: Icon(
              selectedArticle.isSaved
                  ? Icons.bookmark
                  : Icons.bookmark_border_rounded,
            ),
          ),
        ],
      ),
      body: AppScreen(
        maxWidth: 560,
        bottomPadding: 32,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Image.asset(
              _imageFor(selectedArticle),
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(label: Text(selectedArticle.category)),
          ),
          Text(
            selectedArticle.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          AppCard(
            color: AppColors.softBlue,
            borderColor: const Color(0xFFD7E8F8),
            child: Text(selectedArticle.summary),
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < sections.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(sections[i], style: const TextStyle(height: 1.55)),
            ),
          AppCard(
            color: AppColors.softPink,
            borderColor: const Color(0xFFFAD2E1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SoftIcon(
                  icon: Icons.psychology_alt_outlined,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedArticle.careMode == CareMode.pregnancy.name
                        ? 'Küçük yaklaşım: bugün bu metinden sadece bir öneriyi seç. Gebelikte destek istemek bakımın doğal bir parçasıdır.'
                        : 'Küçük yaklaşım: tek ölçüm veya tek gece düzeni çocuğun bütün gelişimini anlatmaz. Trendleri sakin takip edin.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kaynak',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  '${selectedArticle.sourceName} • ${selectedArticle.readingMinutes} dk',
                ),
                Text(
                  selectedArticle.sourceUrl,
                  style: const TextStyle(color: AppColors.muted),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final opened = await openExternalUrl(
                      selectedArticle.sourceUrl,
                    );
                    if (!opened && context.mounted) {
                      showAppSnack(context, 'Kaynak bağlantısı açılamadı.');
                    }
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Kaynağı Aç'),
                ),
                const SizedBox(height: 10),
                Text(
                  selectedArticle.medicalDisclaimer,
                  style: const TextStyle(color: AppColors.danger),
                ),
              ],
            ),
          ),
          if (related.isNotEmpty) ...[
            const SizedBox(height: 22),
            const SectionHeader(title: 'İlgini Çekebilecek Diğer Makaleler'),
            const SizedBox(height: 10),
            for (final item in related)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  onTap: () => context.push('/education/article/${item.id}'),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        _imageFor(item),
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(item.title),
                    subtitle: Text(item.summary),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              ),
          ],
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
}
