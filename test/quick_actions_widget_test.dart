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
  testWidgets('quick feeding record updates tracker list', (tester) async {
    final controller = await _controller();
    await controller.loginLocal('zeynep@example.com', '123456');
    await controller.completeBabyOnboarding(
      parentName: 'Zeynep Yılmaz',
      babyName: 'Aylin Yılmaz',
      birthDate: DateTime.now().subtract(const Duration(days: 102)),
      weight: 7.2,
      height: 64,
    );

    await tester.binding.setSurfaceSize(const Size(430, 980));
    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [appControllerProvider.overrideWith((ref) => controller)],
        child: const MiniAdimlarApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('main_fab')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Besle'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('record_value')), '90 ml');
    await tester.tap(find.byKey(const ValueKey('record_save')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Takip'));
    await tester.pumpAndSettle();

    expect(find.text('Beslenme'), findsWidgets);
    expect(find.textContaining('Siz • 90 ml'), findsOneWidget);
  });
}
