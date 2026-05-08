import 'package:flutter_test/flutter_test.dart';
import 'package:grow_nest/core/ai/ai_analysis_service.dart';
import 'package:grow_nest/core/notifications/notification_service.dart';
import 'package:grow_nest/core/sync/sync_queue.dart';
import 'package:grow_nest/core/utils/app_calculators.dart';

void main() {
  group('AgeUtils', () {
    test('calculates pregnancy week from due date', () {
      final now = DateTime(2026, 5, 4);
      final due = now.add(const Duration(days: 196));

      expect(AgeUtils.pregnancyWeekFromDueDate(due, now), 12);
    });

    test('rejects future baby birth date', () {
      expect(
        () => AgeUtils.babyAge(DateTime(2026, 5, 5), DateTime(2026, 5, 4)),
        throwsArgumentError,
      );
    });
  });

  group('FeedingScheduleCalculator', () {
    test(
      'marks early feeding and pulls next suggestion forward for low amount',
      () {
        final calculator = const FeedingScheduleCalculator();
        final previous = DateTime(2026, 5, 4, 8);
        final current = DateTime(2026, 5, 4, 10);

        final result = calculator.calculate(
          previousFeedingAt: previous,
          currentFeedingAt: current,
          amountMl: 40,
        );

        expect(result.status, TimingStatus.early);
        expect(result.minutesDelta, -60);
        expect(result.nextSuggestedAt, DateTime(2026, 5, 4, 12, 30));
      },
    );

    test('marks late feeding when tolerance is exceeded', () {
      final result = const FeedingScheduleCalculator().calculate(
        previousFeedingAt: DateTime(2026, 5, 4, 8),
        currentFeedingAt: DateTime(2026, 5, 4, 12),
      );

      expect(result.status, TimingStatus.late);
      expect(result.minutesDelta, 60);
    });
  });

  group('ReminderScheduler', () {
    test('does not schedule duplicate notification ids', () async {
      final notifications = InMemoryNotificationService();
      final scheduler = ReminderScheduler(notifications);

      await scheduler.schedule(
        id: 'vitamin-morning',
        title: 'Vitamin',
        category: 'Vitamin',
        time: DateTime(2026, 5, 4, 9),
      );
      await scheduler.schedule(
        id: 'vitamin-morning',
        title: 'Vitamin',
        category: 'Vitamin',
        time: DateTime(2026, 5, 4, 9),
      );

      expect(notifications.scheduled.length, 1);
    });

    test('returns false when permission is denied', () async {
      final notifications = InMemoryNotificationService()
        ..permissionGranted = false;

      final didSchedule = await ReminderScheduler(notifications).schedule(
        id: 'water',
        title: 'Su',
        category: 'Su',
        time: DateTime(2026, 5, 4, 10),
      );

      expect(didSchedule, isFalse);
      expect(notifications.scheduled, isEmpty);
    });
  });

  group('Medical and AI safety', () {
    test('routes urgent symptoms away from diagnosis-only guidance', () async {
      final result = await MockAiAnalysisService().analyzeHealth(
        'nefes alma sorunu',
      );

      expect(result.riskLevel, AiRiskLevel.urgent);
      expect(result.recommendation, contains('acil'));
      expect(result.recommendation, contains('tıbbi teşhis'));
    });

    test('detects duplicate partner actions in the same minute', () {
      expect(
        const ConflictResolver().isDuplicate(
          type: 'feeding',
          first: DateTime(2026, 5, 4, 12),
          second: DateTime(2026, 5, 4, 12, 0, 40),
        ),
        isTrue,
      );
    });
  });
}
