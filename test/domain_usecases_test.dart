import 'package:flutter_test/flutter_test.dart';
import 'package:grow_nest/core/ai/ai_analysis_service.dart';
import 'package:grow_nest/core/insights/care_insights.dart';
import 'package:grow_nest/core/notifications/notification_service.dart';
import 'package:grow_nest/core/sync/sync_queue.dart';
import 'package:grow_nest/core/utils/app_calculators.dart';
import 'package:grow_nest/domain/entities/app_entities.dart';

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

  group('CareRecordInsights', () {
    test('counts only today for daily feeding and diaper stats', () {
      final now = DateTime(2026, 5, 4, 14);
      final insights = CareRecordInsights(
        now: now,
        records: [
          _record(
            id: 'feeding-today',
            type: RecordType.feeding,
            value: '90 ml',
            occurredAt: DateTime(2026, 5, 4, 9),
          ),
          _record(
            id: 'feeding-yesterday',
            type: RecordType.feeding,
            value: '120 ml',
            occurredAt: DateTime(2026, 5, 3, 21),
          ),
          _record(
            id: 'diaper-today',
            type: RecordType.diaper,
            value: 'Islak',
            occurredAt: DateTime(2026, 5, 4, 10),
          ),
        ],
      );

      expect(insights.countToday(RecordType.feeding), 1);
      expect(insights.totalMlToday(RecordType.feeding), 90);
      expect(insights.countToday(RecordType.diaper), 1);
    });

    test('builds seven day feeding totals by calendar day', () {
      final insights = CareRecordInsights(
        now: DateTime(2026, 5, 7, 18),
        records: [
          _record(
            id: 'day-0',
            type: RecordType.feeding,
            value: '60 ml',
            occurredAt: DateTime(2026, 5, 1, 8),
          ),
          _record(
            id: 'today-a',
            type: RecordType.feeding,
            value: '90 ml',
            occurredAt: DateTime(2026, 5, 7, 9),
          ),
          _record(
            id: 'today-b',
            type: RecordType.feeding,
            value: '30 ml',
            occurredAt: DateTime(2026, 5, 7, 11),
          ),
        ],
      );

      expect(insights.feedingTotalsLast7Days(), [60, 0, 0, 0, 0, 0, 120]);
    });
  });
}

TrackerRecord _record({
  required String id,
  required RecordType type,
  required String value,
  required DateTime occurredAt,
}) {
  return TrackerRecord(
    id: id,
    type: type,
    title: id,
    value: value,
    occurredAt: occurredAt,
    createdAt: occurredAt,
    updatedAt: occurredAt,
    syncStatus: SyncStatus.synced,
  );
}
