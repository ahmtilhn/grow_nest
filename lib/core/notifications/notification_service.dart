import 'dart:convert';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

enum ReminderFrequency { once, daily, weekly, customDays }

enum ReminderPlanType { once, hourly, dailyTimes, weeklyTimes, monthlyDates }

class ReminderPlan {
  const ReminderPlan({
    required this.type,
    this.times = const [],
    this.weekdays = const [],
    this.monthDays = const [],
    this.intervalHours = 1,
    this.startHour = 8,
    this.endHour = 22,
    this.goalLiters,
  });

  final ReminderPlanType type;
  final List<TimeOfDayValue> times;
  final List<int> weekdays;
  final List<int> monthDays;
  final int intervalHours;
  final int startHour;
  final int endHour;
  final double? goalLiters;

  String encode() => jsonEncode({
    'type': type.name,
    'times': times.map((time) => time.toJson()).toList(),
    'weekdays': weekdays,
    'monthDays': monthDays,
    'intervalHours': intervalHours,
    'startHour': startHour,
    'endHour': endHour,
    if (goalLiters != null) 'goalLiters': goalLiters,
  });

  static ReminderPlan? tryParse(String value) {
    if (!value.trim().startsWith('{')) return null;
    try {
      final json = jsonDecode(value) as Map<String, dynamic>;
      return ReminderPlan(
        type: ReminderPlanType.values.byName(json['type'] as String),
        times: ((json['times'] as List?) ?? const [])
            .map(
              (item) => TimeOfDayValue.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
        weekdays: ((json['weekdays'] as List?) ?? const [])
            .map((item) => (item as num).toInt())
            .toList(),
        monthDays: ((json['monthDays'] as List?) ?? const [])
            .map((item) => (item as num).toInt())
            .toList(),
        intervalHours: (json['intervalHours'] as num?)?.toInt() ?? 1,
        startHour: (json['startHour'] as num?)?.toInt() ?? 8,
        endHour: (json['endHour'] as num?)?.toInt() ?? 22,
        goalLiters: (json['goalLiters'] as num?)?.toDouble(),
      );
    } catch (_) {
      return null;
    }
  }
}

class TimeOfDayValue {
  const TimeOfDayValue(this.hour, this.minute);

  final int hour;
  final int minute;

  Map<String, int> toJson() => {'hour': hour, 'minute': minute};

  factory TimeOfDayValue.fromJson(Map<String, dynamic> json) {
    return TimeOfDayValue(
      (json['hour'] as num?)?.toInt() ?? 9,
      (json['minute'] as num?)?.toInt() ?? 0,
    );
  }
}

class ScheduledNotification {
  const ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledAt,
    this.sound = 'soft_chime',
  });

  final String id;
  final String title;
  final String body;
  final DateTime scheduledAt;
  final String sound;
}

abstract class NotificationService {
  Future<bool> requestPermission();
  Future<void> show(ScheduledNotification notification);
  Future<void> schedule(ScheduledNotification notification);
  Future<void> cancel(String id);
}

class InMemoryNotificationService implements NotificationService {
  final scheduled = <String, ScheduledNotification>{};
  final shown = <String, ScheduledNotification>{};
  bool permissionGranted = true;

  @override
  Future<void> cancel(String id) async {
    scheduled.remove(id);
  }

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<void> show(ScheduledNotification notification) async {
    if (!permissionGranted) return;
    shown[notification.id] = notification;
  }

  @override
  Future<void> schedule(ScheduledNotification notification) async {
    if (!permissionGranted) return;
    scheduled[notification.id] = notification;
  }
}

class LocalNotificationService implements NotificationService {
  LocalNotificationService._(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static Future<LocalNotificationService> create() async {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_stat_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    return LocalNotificationService._(plugin);
  }

  @override
  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final androidGranted =
        await android?.requestNotificationsPermission() ?? true;

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final iosGranted =
        await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
        true;
    return androidGranted && iosGranted;
  }

  @override
  Future<void> cancel(String id) {
    return _plugin.cancel(id: _intId(id));
  }

  @override
  Future<void> schedule(ScheduledNotification notification) {
    return _plugin.zonedSchedule(
      id: _intId(notification.id),
      title: notification.title,
      body: notification.body,
      scheduledDate: tz.TZDateTime.from(notification.scheduledAt, tz.local),
      notificationDetails: _details(notification.sound),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> show(ScheduledNotification notification) {
    return _plugin.show(
      id: _intId(notification.id),
      title: notification.title,
      body: notification.body,
      notificationDetails: _details(notification.sound),
    );
  }

  NotificationDetails _details(String sound) {
    final playSound = sound != 'silent';
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'mini_adimlar_$sound',
        _soundLabel(sound),
        channelDescription: 'MiniAdımlar hatırlatıcı ve aile bildirimleri',
        importance: Importance.high,
        priority: Priority.high,
        color: Color(0xFF28758A),
        playSound: playSound,
        silent: !playSound,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: playSound,
      ),
    );
  }

  int _intId(String id) => id.hashCode & 0x7fffffff;

  String _soundLabel(String sound) => switch (sound) {
    'gentle_bell' => 'Yumuşak zil',
    'silent' => 'Sessiz',
    _ => 'Sakin çan',
  };
}

class ReminderScheduler {
  const ReminderScheduler(this._notifications);

  final NotificationService _notifications;

  Future<bool> schedule({
    required String id,
    required String title,
    required String category,
    required DateTime time,
    String notes = '',
    ReminderFrequency frequency = ReminderFrequency.daily,
    ReminderPlan? plan,
    String sound = 'soft_chime',
  }) async {
    final allowed = await _notifications.requestPermission();
    if (!allowed) return false;
    if (plan != null) {
      return schedulePlan(
        id: id,
        title: title,
        category: category,
        notes: notes,
        plan: plan,
        sound: sound,
      );
    }
    final scheduledAt = nextAfter(
      now: DateTime.now(),
      time: time,
      frequency: frequency,
    );
    await _notifications.schedule(
      ScheduledNotification(
        id: id,
        title: title,
        body: notes.isEmpty ? category : notes,
        scheduledAt: scheduledAt,
        sound: sound,
      ),
    );
    return true;
  }

  Future<bool> schedulePlan({
    required String id,
    required String title,
    required String category,
    required String notes,
    required ReminderPlan plan,
    String sound = 'soft_chime',
  }) async {
    final allowed = await _notifications.requestPermission();
    if (!allowed) return false;
    final occurrences = upcomingOccurrences(plan, DateTime.now()).take(32);
    var index = 0;
    for (final occurrence in occurrences) {
      await _notifications.schedule(
        ScheduledNotification(
          id: '$id-$index',
          title: title,
          body: notes.isEmpty ? category : notes,
          scheduledAt: occurrence,
          sound: sound,
        ),
      );
      index++;
    }
    return index > 0;
  }

  static ReminderFrequency frequencyFromStoredValue(String value) {
    if (value.trim().startsWith('{')) return ReminderFrequency.daily;
    return ReminderFrequency.values.firstWhere(
      (item) => item.name == value,
      orElse: () => ReminderFrequency.daily,
    );
  }

  List<DateTime> upcomingOccurrences(ReminderPlan plan, DateTime now) {
    final result = <DateTime>[];
    final times = plan.times.isEmpty
        ? [TimeOfDayValue(now.hour, now.minute)]
        : plan.times;
    for (var offset = 0; offset <= 370 && result.length < 48; offset++) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(Duration(days: offset));
      switch (plan.type) {
        case ReminderPlanType.once:
          for (final time in times.take(1)) {
            final candidate = _at(day, time);
            if (candidate.isAfter(now)) result.add(candidate);
          }
          return result;
        case ReminderPlanType.hourly:
          final interval = plan.intervalHours.clamp(1, 12).toInt();
          for (
            var hour = plan.startHour;
            hour <= plan.endHour;
            hour += interval
          ) {
            final candidate = DateTime(day.year, day.month, day.day, hour);
            if (candidate.isAfter(now)) result.add(candidate);
          }
          break;
        case ReminderPlanType.dailyTimes:
          for (final time in times) {
            final candidate = _at(day, time);
            if (candidate.isAfter(now)) result.add(candidate);
          }
          break;
        case ReminderPlanType.weeklyTimes:
          if (!plan.weekdays.contains(day.weekday)) continue;
          for (final time in times) {
            final candidate = _at(day, time);
            if (candidate.isAfter(now)) result.add(candidate);
          }
          break;
        case ReminderPlanType.monthlyDates:
          if (!plan.monthDays.contains(day.day)) continue;
          for (final time in times) {
            final candidate = _at(day, time);
            if (candidate.isAfter(now)) result.add(candidate);
          }
          break;
      }
    }
    result.sort();
    return result;
  }

  DateTime nextAfter({
    required DateTime now,
    required DateTime time,
    required ReminderFrequency frequency,
    List<int> customDays = const [],
  }) {
    var candidate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (candidate.isAfter(now)) return candidate;
    return switch (frequency) {
      ReminderFrequency.once => time,
      ReminderFrequency.daily => candidate.add(const Duration(days: 1)),
      ReminderFrequency.weekly => candidate.add(const Duration(days: 7)),
      ReminderFrequency.customDays => _nextCustomDay(now, time, customDays),
    };
  }

  DateTime _nextCustomDay(DateTime now, DateTime time, List<int> customDays) {
    if (customDays.isEmpty) return now.add(const Duration(days: 1));
    for (var offset = 1; offset <= 7; offset++) {
      final day = now.add(Duration(days: offset));
      if (customDays.contains(day.weekday)) {
        return DateTime(day.year, day.month, day.day, time.hour, time.minute);
      }
    }
    return now.add(const Duration(days: 1));
  }

  DateTime _at(DateTime day, TimeOfDayValue time) {
    return DateTime(day.year, day.month, day.day, time.hour, time.minute);
  }
}
