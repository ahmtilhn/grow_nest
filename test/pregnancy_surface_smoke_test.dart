import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_nest/app/app.dart';
import 'package:grow_nest/app/app_controller.dart';
import 'package:grow_nest/data/local/app_database.dart';
import 'package:grow_nest/data/repositories/app_repository.dart';
import 'package:grow_nest/domain/entities/app_entities.dart';

Future<AppController> _pregnancyController() async {
  final repository = AppRepository(AppDatabase.inMemory());
  await repository.seedContent();
  final controller = AppController(repository);
  await controller.load();
  await controller.loginLocal('elif@example.com', '123456');
  await controller.completePregnancyOnboarding(
    parentName: 'Elif Yilmaz',
    dueDate: DateTime.now().add(const Duration(days: 140)),
  );
  return controller;
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
  testWidgets('pregnancy mode renders core planning and tracking routes', (
    tester,
  ) async {
    final controller = await _pregnancyController();
    await tester.binding.setSurfaceSize(const Size(430, 980));
    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [appControllerProvider.overrideWith((ref) => controller)],
        child: const MiniAdimlarApp(),
      ),
    );
    await tester.pumpAndSettle();

    final router = GoRouter.of(tester.element(find.byType(Overlay).first));

    for (final route in const [
      '/growth',
      '/tracker',
      '/education',
      '/family',
      '/quick-actions',
      '/profile',
      '/journal',
      '/reminder/new',
    ]) {
      await _openRoute(tester, router, route);
    }

    for (final type in const [
      RecordType.water,
      RecordType.vitamin,
      RecordType.appointment,
      RecordType.health,
      RecordType.memory,
    ]) {
      await _openRoute(tester, router, '/add/${type.name}', push: true);
    }

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
