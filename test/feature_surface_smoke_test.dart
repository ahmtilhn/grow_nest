import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_nest/app/app.dart';
import 'package:grow_nest/app/app_controller.dart';
import 'package:grow_nest/data/local/app_database.dart';
import 'package:grow_nest/data/repositories/app_repository.dart';
import 'package:grow_nest/domain/entities/app_entities.dart';

Future<AppController> _babyController() async {
  final repository = AppRepository(AppDatabase.inMemory());
  await repository.seedContent();
  final controller = AppController(repository);
  await controller.load();
  await controller.loginLocal('zeynep@example.com', '123456');
  await controller.completeBabyOnboarding(
    parentName: 'Zeynep Yilmaz',
    babyName: 'Aylin Yilmaz',
    birthDate: DateTime.now().subtract(const Duration(days: 102)),
    weight: 7.2,
    height: 64,
  );
  return controller;
}

Future<void> _pumpApp(WidgetTester tester, AppController controller) async {
  await tester.binding.setSurfaceSize(const Size(430, 980));
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [appControllerProvider.overrideWith((ref) => controller)],
      child: const MiniAdimlarApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openRoute(
  WidgetTester tester,
  GoRouter router,
  String route, {
  bool push = false,
}) async {
  if (push) {
    router.push(route);
  } else {
    router.go(route);
  }
  await tester.pumpAndSettle();
  final exception = tester.takeException();
  expect(exception, isNull, reason: 'Route failed: $route');
  expect(
    find.byType(Overlay),
    findsWidgets,
    reason: 'Route disappeared: $route',
  );
  if (push && router.canPop()) {
    router.pop();
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('baby mode renders every primary feature route and record form', (
    tester,
  ) async {
    final controller = await _babyController();
    await _pumpApp(tester, controller);
    final router = GoRouter.of(tester.element(find.byType(Overlay).first));

    for (final route in const [
      '/growth',
      '/tracker',
      '/vaccines',
      '/education',
      '/family',
      '/insights',
      '/notifications',
      '/quick-actions',
      '/profile',
      '/journal',
      '/sleep',
      '/reminder/new',
      '/education/article/safe-sleep',
    ]) {
      await _openRoute(
        tester,
        router,
        route,
        push: route.startsWith('/education/'),
      );
    }

    for (final type in RecordType.values) {
      await _openRoute(tester, router, '/add/${type.name}', push: true);
    }

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
