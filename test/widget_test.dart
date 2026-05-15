import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grow_nest/app/app.dart';
import 'package:grow_nest/app/app_controller.dart';
import 'package:grow_nest/data/local/app_database.dart';
import 'package:grow_nest/data/repositories/app_repository.dart';

Future<AppController> _controller() async {
  final repository = AppRepository(AppDatabase.inMemory());
  await repository.seedContent();
  final controller = AppController(repository);
  await controller.load();
  return controller;
}

void main() {
  testWidgets('watched app controller provider rebuilds on notifyListeners', (
    tester,
  ) async {
    final controller = await _controller();

    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [appControllerProvider.overrideWith((ref) => controller)],
        child: Consumer(
          builder: (context, ref, _) {
            final snapshot = ref.watch(appSnapshotProvider);
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Text(snapshot.localeCode),
            );
          },
        ),
      ),
    );

    expect(find.text('tr'), findsOneWidget);
    controller.snapshot = controller.snapshot.copyWith(localeCode: 'en');
    controller.notifyListeners();
    await tester.pumpAndSettle();

    expect(find.text('en'), findsOneWidget);
  });

  testWidgets('controller revision rebuilds on time-only notifications', (
    tester,
  ) async {
    final controller = await _controller();

    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [appControllerProvider.overrideWith((ref) => controller)],
        child: Consumer(
          builder: (context, ref, _) {
            final revision = ref.watch(appControllerRevisionProvider);
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Text('revision:$revision'),
            );
          },
        ),
      ),
    );

    expect(find.text('revision:0'), findsOneWidget);
    controller.refreshTimeSensitiveViews();
    await tester.pump();

    expect(find.text('revision:1'), findsOneWidget);
  });

  testWidgets('login and pregnancy onboarding opens figma-style dashboard', (
    tester,
  ) async {
    final controller = await _controller();

    await tester.binding.setSurfaceSize(const Size(430, 980));
    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [appControllerProvider.overrideWith((ref) => controller)],
        child: const MiniAdimlarApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MiniAdımlar'), findsWidgets);
    await tester.enterText(
      find.byKey(const ValueKey('login_email')),
      'zeynep@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login_password')),
      '123456',
    );
    await tester.tap(find.byKey(const ValueKey('login_button')));
    await tester.pumpAndSettle();

    expect(find.text('Başlangıcı seç'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('onboarding_continue')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Medikal uyarıyı okudum ve kabul ediyorum.'));
    await tester.tap(
      find.text('Gizlilik ve kullanım koşullarını kabul ediyorum.'),
    );
    await tester.tap(find.byKey(const ValueKey('onboarding_continue')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('onboarding_continue')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Bebeğiniz bu hafta'), findsOneWidget);
    expect(find.text('Ana Sayfa'), findsWidgets);
    expect(find.text('Takip'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
