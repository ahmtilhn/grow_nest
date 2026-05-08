import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grow_nest/app/app.dart';
import 'package:grow_nest/app/app_controller.dart';
import 'package:grow_nest/data/local/app_database.dart';
import 'package:grow_nest/data/repositories/app_repository.dart';
import 'package:grow_nest/domain/entities/app_entities.dart';

Future<AppController> _controller() async {
  final repository = AppRepository(AppDatabase.inMemory());
  await repository.seedContent();
  final controller = AppController(repository);
  await controller.load();
  return controller;
}

void main() {
  testWidgets('vaccine checkbox marks item completed', (tester) async {
    final controller = await _controller();
    await controller.loginLocal('zeynep@example.com', '123456');
    await controller.completeBabyOnboarding(
      parentName: 'Zeynep Yılmaz',
      babyName: 'Aylin Yılmaz',
      birthDate: DateTime.now().subtract(const Duration(days: 102)),
      weight: 7.2,
      height: 64,
    );

    final vaccineId = controller.snapshot.vaccines.first.id;

    await tester.binding.setSurfaceSize(const Size(430, 980));
    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [appControllerProvider.overrideWith((ref) => controller)],
        child: const MiniAdimlarApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Aşılar'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    await tester.pumpAndSettle();

    final updated = controller.snapshot.vaccines.firstWhere(
      (item) => item.id == vaccineId,
    );
    expect(updated.status, VaccineStatus.completed);
  });
}
