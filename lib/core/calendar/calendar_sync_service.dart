import 'package:device_calendar/device_calendar.dart' as device_calendar;

import '../../domain/entities/app_entities.dart';
import '../notifications/notification_service.dart';

abstract class CalendarSyncService {
  Future<bool> requestAccess();

  Future<List<String>> replaceReminderEvents(
    ReminderItem reminder, {
    required Iterable<String> existingEventIds,
  });

  Future<void> deleteReminderEvents(Iterable<String> eventIds);
}

class NoopCalendarSyncService implements CalendarSyncService {
  const NoopCalendarSyncService();

  @override
  Future<bool> requestAccess() async => false;

  @override
  Future<List<String>> replaceReminderEvents(
    ReminderItem reminder, {
    required Iterable<String> existingEventIds,
  }) async {
    return const [];
  }

  @override
  Future<void> deleteReminderEvents(Iterable<String> eventIds) async {}
}

class DeviceCalendarSyncService implements CalendarSyncService {
  DeviceCalendarSyncService({device_calendar.DeviceCalendarPlugin? plugin})
    : _plugin = plugin ?? device_calendar.DeviceCalendarPlugin();

  static const _eventDuration = Duration(minutes: 15);
  static const _maxEventsPerReminder = 32;
  static const _storedIdSeparator = '|';

  final device_calendar.DeviceCalendarPlugin _plugin;

  @override
  Future<bool> requestAccess() async {
    final current = await _plugin.hasPermissions();
    if (current.isSuccess && current.data == true) return true;
    final requested = await _plugin.requestPermissions();
    return requested.isSuccess && requested.data == true;
  }

  @override
  Future<List<String>> replaceReminderEvents(
    ReminderItem reminder, {
    required Iterable<String> existingEventIds,
  }) async {
    await deleteReminderEvents(existingEventIds);
    if (!reminder.isActive) return const [];

    final calendarId = await _writableCalendarId();
    final storedIds = <String>[];
    for (final draft in _draftsFor(reminder).take(_maxEventsPerReminder)) {
      final start = _calendarDateTime(draft.start);
      final event = device_calendar.Event(
        calendarId,
        title: draft.title,
        description: draft.description,
        start: start,
        end: start.add(_eventDuration),
        recurrenceRule: draft.recurrenceRule,
        reminders: [device_calendar.Reminder(minutes: 0)],
        availability: device_calendar.Availability.Free,
      );
      final result = await _plugin.createOrUpdateEvent(event);
      final eventId = result?.data?.trim();
      if (result == null ||
          !result.isSuccess ||
          eventId == null ||
          eventId.isEmpty) {
        throw CalendarSyncException(
          _errorMessage(result?.errors) ??
              'Telefon takvimine etkinlik eklenemedi.',
        );
      }
      storedIds.add(_encodeStoredEventId(calendarId, eventId));
    }
    return storedIds;
  }

  @override
  Future<void> deleteReminderEvents(Iterable<String> eventIds) async {
    for (final storedId in eventIds.toSet()) {
      final parsed = _decodeStoredEventId(storedId);
      if (parsed == null) continue;
      final result = await _plugin.deleteEvent(
        parsed.calendarId,
        parsed.eventId,
      );
      if (result.hasErrors) {
        throw CalendarSyncException(
          _errorMessage(result.errors) ??
              'Telefon takvimindeki etkinlik silinemedi.',
        );
      }
    }
  }

  Future<String> _writableCalendarId() async {
    final allowed = await requestAccess();
    if (!allowed) {
      throw const CalendarSyncException('Telefon takvimi izni alınamadı.');
    }

    final calendarsResult = await _plugin.retrieveCalendars();
    if (!calendarsResult.isSuccess || calendarsResult.data == null) {
      throw CalendarSyncException(
        _errorMessage(calendarsResult.errors) ??
            'Telefon takvimleri okunamadı.',
      );
    }

    final writableCalendars = calendarsResult.data!
        .where(
          (calendar) =>
              calendar.isReadOnly != true &&
              calendar.id != null &&
              calendar.id!.trim().isNotEmpty,
        )
        .toList();
    final selected =
        _firstMatching(
          writableCalendars,
          (calendar) => calendar.isDefault == true,
        ) ??
        _firstMatching(writableCalendars, _looksLikeGoogleCalendar) ??
        (writableCalendars.isEmpty ? null : writableCalendars.first);
    final selectedId = selected?.id?.trim();
    if (selectedId != null && selectedId.isNotEmpty) return selectedId;

    final created = await _plugin.createCalendar(
      'MiniAdımlar',
      localAccountName: 'MiniAdımlar',
    );
    final createdId = created.data?.trim();
    if (created.isSuccess && createdId != null && createdId.isNotEmpty) {
      return createdId;
    }
    throw CalendarSyncException(
      _errorMessage(created.errors) ??
          'Yazılabilir telefon takvimi bulunamadı.',
    );
  }

  device_calendar.Calendar? _firstMatching(
    List<device_calendar.Calendar> calendars,
    bool Function(device_calendar.Calendar calendar) test,
  ) {
    for (final calendar in calendars) {
      if (test(calendar)) return calendar;
    }
    return null;
  }

  bool _looksLikeGoogleCalendar(device_calendar.Calendar calendar) {
    final account = [
      calendar.accountName,
      calendar.accountType,
      calendar.name,
    ].whereType<String>().join(' ').toLowerCase();
    return account.contains('google') || account.contains('gmail');
  }

  device_calendar.TZDateTime _calendarDateTime(DateTime value) {
    return device_calendar.TZDateTime.from(value, device_calendar.local);
  }

  List<_DeviceCalendarEventDraft> _draftsFor(ReminderItem reminder) {
    final plan = ReminderPlan.tryParse(reminder.frequency);
    if (plan == null) return _legacyDraftsFor(reminder);

    return switch (plan.type) {
      ReminderPlanType.once => _onceDrafts(reminder, plan),
      ReminderPlanType.hourly => _hourlyDrafts(reminder, plan),
      ReminderPlanType.dailyTimes => _dailyDrafts(reminder, plan),
      ReminderPlanType.weeklyTimes => _weeklyDrafts(reminder, plan),
      ReminderPlanType.monthlyDates => _monthlyDrafts(reminder, plan),
    };
  }

  List<_DeviceCalendarEventDraft> _legacyDraftsFor(ReminderItem reminder) {
    final time = TimeOfDayValue(reminder.time.hour, reminder.time.minute);
    final start = _nextMatchingDateTime(time: time);
    final recurrenceRule = switch (reminder.frequency) {
      'once' => null,
      'weekly' => device_calendar.RecurrenceRule(
        device_calendar.RecurrenceFrequency.Weekly,
        daysOfWeek: [_weekday(reminder.time.weekday)],
      ),
      _ => device_calendar.RecurrenceRule(
        device_calendar.RecurrenceFrequency.Daily,
      ),
    };
    if (reminder.frequency == 'once' && start.isBefore(DateTime.now())) {
      return const [];
    }
    return [_draft(reminder, start: start, recurrenceRule: recurrenceRule)];
  }

  List<_DeviceCalendarEventDraft> _onceDrafts(
    ReminderItem reminder,
    ReminderPlan plan,
  ) {
    final times = _timesFor(plan, reminder).take(1);
    return [
      for (final time in times)
        if (_nextMatchingDateTime(time: time).isAfter(DateTime.now()))
          _draft(reminder, start: _nextMatchingDateTime(time: time)),
    ];
  }

  List<_DeviceCalendarEventDraft> _hourlyDrafts(
    ReminderItem reminder,
    ReminderPlan plan,
  ) {
    final interval = plan.intervalHours.clamp(1, 12).toInt();
    final startHour = plan.startHour.clamp(0, 23).toInt();
    final endHour = plan.endHour.clamp(startHour, 23).toInt();
    return [
      for (var hour = startHour; hour <= endHour; hour += interval)
        _draft(
          reminder,
          start: _nextMatchingDateTime(time: TimeOfDayValue(hour, 0)),
          recurrenceRule: device_calendar.RecurrenceRule(
            device_calendar.RecurrenceFrequency.Daily,
          ),
        ),
    ];
  }

  List<_DeviceCalendarEventDraft> _dailyDrafts(
    ReminderItem reminder,
    ReminderPlan plan,
  ) {
    return [
      for (final time in _timesFor(plan, reminder))
        _draft(
          reminder,
          start: _nextMatchingDateTime(time: time),
          recurrenceRule: device_calendar.RecurrenceRule(
            device_calendar.RecurrenceFrequency.Daily,
          ),
        ),
    ];
  }

  List<_DeviceCalendarEventDraft> _weeklyDrafts(
    ReminderItem reminder,
    ReminderPlan plan,
  ) {
    final weekdays =
        (plan.weekdays.isEmpty ? [reminder.time.weekday] : plan.weekdays)
            .map((day) => day.clamp(1, 7).toInt())
            .toSet()
            .toList()
          ..sort();
    final recurrenceRule = device_calendar.RecurrenceRule(
      device_calendar.RecurrenceFrequency.Weekly,
      daysOfWeek: weekdays.map(_weekday).toList(),
    );
    return [
      for (final time in _timesFor(plan, reminder))
        _draft(
          reminder,
          start: _nextMatchingDateTime(time: time, weekdays: weekdays),
          recurrenceRule: recurrenceRule,
        ),
    ];
  }

  List<_DeviceCalendarEventDraft> _monthlyDrafts(
    ReminderItem reminder,
    ReminderPlan plan,
  ) {
    final monthDays =
        (plan.monthDays.isEmpty ? [reminder.time.day] : plan.monthDays)
            .map((day) => day.clamp(1, 31).toInt())
            .toSet()
            .toList()
          ..sort();
    return [
      for (final time in _timesFor(plan, reminder))
        for (final monthDay in monthDays)
          _draft(
            reminder,
            start: _nextMatchingDateTime(time: time, monthDays: [monthDay]),
            recurrenceRule: device_calendar.RecurrenceRule(
              device_calendar.RecurrenceFrequency.Monthly,
              dayOfMonth: monthDay,
            ),
          ),
    ];
  }

  List<TimeOfDayValue> _timesFor(ReminderPlan plan, ReminderItem reminder) {
    final raw = plan.times.isEmpty
        ? [TimeOfDayValue(reminder.time.hour, reminder.time.minute)]
        : plan.times;
    final unique = <String, TimeOfDayValue>{};
    for (final time in raw) {
      final hour = time.hour.clamp(0, 23).toInt();
      final minute = time.minute.clamp(0, 59).toInt();
      unique['$hour:$minute'] = TimeOfDayValue(hour, minute);
    }
    final times = unique.values.toList()
      ..sort((a, b) {
        final hourComparison = a.hour.compareTo(b.hour);
        if (hourComparison != 0) return hourComparison;
        return a.minute.compareTo(b.minute);
      });
    return times.take(_maxEventsPerReminder).toList();
  }

  DateTime _nextMatchingDateTime({
    required TimeOfDayValue time,
    List<int>? weekdays,
    List<int>? monthDays,
  }) {
    final now = DateTime.now();
    for (var offset = 0; offset <= 400; offset++) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(Duration(days: offset));
      if (weekdays != null && !weekdays.contains(day.weekday)) continue;
      if (monthDays != null && !monthDays.contains(day.day)) continue;
      final candidate = DateTime(
        day.year,
        day.month,
        day.day,
        time.hour,
        time.minute,
      );
      if (candidate.isAfter(now)) return candidate;
    }
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  _DeviceCalendarEventDraft _draft(
    ReminderItem reminder, {
    required DateTime start,
    device_calendar.RecurrenceRule? recurrenceRule,
  }) {
    return _DeviceCalendarEventDraft(
      title: 'MiniAdımlar: ${reminder.title}',
      description: _descriptionFor(reminder),
      start: start,
      recurrenceRule: recurrenceRule,
    );
  }

  String _descriptionFor(ReminderItem reminder) {
    final notes = reminder.notes?.trim();
    return [
      'MiniAdımlar hatırlatıcısı',
      'Kategori: ${_categoryLabel(reminder.category)}',
      if (notes != null && notes.isNotEmpty) notes,
    ].join('\n');
  }

  String _categoryLabel(ReminderCategory category) {
    return switch (category) {
      ReminderCategory.health => 'Sağlık',
      ReminderCategory.water => 'Su',
      ReminderCategory.feeding => 'Beslenme',
      ReminderCategory.vaccine => 'Aşı',
      ReminderCategory.appointment => 'Randevu',
      ReminderCategory.vitamin => 'Vitamin',
      ReminderCategory.medicine => 'İlaç',
      ReminderCategory.sleep => 'Uyku',
      ReminderCategory.diaper => 'Bez',
      ReminderCategory.custom => 'Hatırlatıcı',
    };
  }

  device_calendar.DayOfWeek _weekday(int weekday) {
    return switch (weekday) {
      DateTime.monday => device_calendar.DayOfWeek.Monday,
      DateTime.tuesday => device_calendar.DayOfWeek.Tuesday,
      DateTime.wednesday => device_calendar.DayOfWeek.Wednesday,
      DateTime.thursday => device_calendar.DayOfWeek.Thursday,
      DateTime.friday => device_calendar.DayOfWeek.Friday,
      DateTime.saturday => device_calendar.DayOfWeek.Saturday,
      DateTime.sunday => device_calendar.DayOfWeek.Sunday,
      _ => device_calendar.DayOfWeek.Monday,
    };
  }

  String _encodeStoredEventId(String calendarId, String eventId) {
    return '$calendarId$_storedIdSeparator$eventId';
  }

  _StoredCalendarEventId? _decodeStoredEventId(String value) {
    final separatorIndex = value.indexOf(_storedIdSeparator);
    if (separatorIndex <= 0 || separatorIndex == value.length - 1) return null;
    return _StoredCalendarEventId(
      calendarId: value.substring(0, separatorIndex),
      eventId: value.substring(separatorIndex + 1),
    );
  }

  String? _errorMessage(List<device_calendar.ResultError>? errors) {
    if (errors == null || errors.isEmpty) return null;
    return errors.map((error) => error.errorMessage).join(' ');
  }
}

class _DeviceCalendarEventDraft {
  const _DeviceCalendarEventDraft({
    required this.title,
    required this.description,
    required this.start,
    this.recurrenceRule,
  });

  final String title;
  final String description;
  final DateTime start;
  final device_calendar.RecurrenceRule? recurrenceRule;
}

class _StoredCalendarEventId {
  const _StoredCalendarEventId({
    required this.calendarId,
    required this.eventId,
  });

  final String calendarId;
  final String eventId;
}

class CalendarSyncException implements Exception {
  const CalendarSyncException(this.message);

  final String message;

  @override
  String toString() => message;
}
