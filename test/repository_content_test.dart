import 'package:flutter_test/flutter_test.dart';
import 'package:grow_nest/data/local/app_database.dart';
import 'package:grow_nest/data/repositories/app_repository.dart';

void main() {
  test('seed content includes expanded AAP guidance topics', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);

    await repository.seedContent();
    final snapshot = await repository.loadSnapshot();

    expect(
      snapshot.articles.map((article) => article.id),
      containsAll([
        'oral-health-first-tooth',
        'screen-time-baby',
        'choking-prevention',
        'rear-facing-car-seat',
        'crying-safe-break',
        'postpartum-mood-support',
        'planning-newborn-safety',
      ]),
    );
  });

  test(
    'vaccine schedule uses calendar months instead of fixed 30-day offsets',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);

      await repository.seedContent();
      await repository.loginLocal('calendar@example.com', '123456');
      await repository.completeBabyOnboarding(
        parentName: 'Calendar Parent',
        babyName: 'Aylin',
        birthDate: DateTime(2026, 1, 31),
      );

      final snapshot = await repository.loadSnapshot();
      final secondHepB = snapshot.vaccines.singleWhere(
        (vaccine) => vaccine.id.endsWith('hepb-1m'),
      );

      expect(secondHepB.dueDate, DateTime(2026, 2, 28));
    },
  );
}
