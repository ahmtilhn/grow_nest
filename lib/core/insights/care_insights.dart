import '../../domain/entities/app_entities.dart';
import '../utils/app_calculators.dart';

class CareRecordInsights {
  CareRecordInsights({required List<TrackerRecord> records, DateTime? now})
    : _records = records,
      now = now ?? DateTime.now();

  final List<TrackerRecord> _records;
  final DateTime now;

  DateTime get todayStart => DateTime(now.year, now.month, now.day);
  DateTime get tomorrowStart => todayStart.add(const Duration(days: 1));

  Iterable<TrackerRecord> recordsToday([RecordType? type]) {
    return _records.where((record) {
      if (type != null && record.type != type) return false;
      return !record.occurredAt.isBefore(todayStart) &&
          record.occurredAt.isBefore(tomorrowStart);
    });
  }

  int countToday(RecordType type) => recordsToday(type).length;

  TrackerRecord? latest(RecordType type) {
    final filtered = _records.where((record) => record.type == type);
    return filtered.isEmpty ? null : filtered.first;
  }

  double totalMlToday(RecordType type) {
    return recordsToday(
      type,
    ).fold<double>(0, (sum, record) => sum + mlFromValue(record.value));
  }

  List<double> feedingTotalsLast7Days() {
    final start = todayStart.subtract(const Duration(days: 6));
    final totals = List<double>.filled(7, 0);
    for (final record in _records) {
      if (record.type != RecordType.feeding) continue;
      final day = DateTime(
        record.occurredAt.year,
        record.occurredAt.month,
        record.occurredAt.day,
      );
      final index = day.difference(start).inDays;
      if (index < 0 || index >= totals.length) continue;
      totals[index] += mlFromValue(record.value);
    }
    return totals;
  }

  int sleepMinutesLast24Hours() {
    final since = now.subtract(const Duration(hours: 24));
    return _records.fold<int>(0, (sum, record) {
      if (record.type != RecordType.sleep ||
          record.occurredAt.isBefore(since)) {
        return sum;
      }
      return sum + minutesFromValue(record.value);
    });
  }

  int sleepMinutesToday() {
    return recordsToday(
      RecordType.sleep,
    ).fold<int>(0, (sum, record) => sum + minutesFromValue(record.value));
  }

  int recordsLast7Days() {
    final start = todayStart.subtract(const Duration(days: 6));
    return _records
        .where((record) => !record.occurredAt.isBefore(start))
        .length;
  }

  GrowthMeasurement latestGrowthMeasurement(BabyProfile? baby) {
    final measurement = GrowthMeasurement.parse(
      latest(RecordType.growth)?.value,
    );
    return GrowthMeasurement(
      weightKg: measurement.weightKg ?? baby?.currentWeight,
      heightCm: measurement.heightCm ?? baby?.currentHeight,
      headCm: measurement.headCm ?? baby?.currentHeadCircumference,
    );
  }

  VaccineEvent? nextVaccine(List<VaccineEvent> vaccines) {
    final open =
        vaccines
            .where((item) => item.status != VaccineStatus.completed)
            .toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return open.isEmpty ? null : open.first;
  }

  int overdueVaccines(List<VaccineEvent> vaccines) {
    return vaccines
        .where((item) => item.status == VaccineStatus.overdue)
        .length;
  }

  static double mlFromValue(String? value) {
    if (value == null) return 0;
    final match = RegExp(r'(\d+(?:[,.]\d+)?)').firstMatch(value);
    if (match == null) return 0;
    return double.tryParse(match.group(1)!.replaceAll(',', '.')) ?? 0;
  }

  static int minutesFromValue(String? value) {
    if (value == null || value == 'active') return 0;
    final match = RegExp(r'(\d+)\s*dk').firstMatch(value);
    if (match == null) return 0;
    return int.tryParse(match.group(1)!) ?? 0;
  }
}

String compactDurationLabel(int minutes) {
  if (minutes <= 0) return '0 dk';
  return '${minutes ~/ 60}s ${minutes % 60}dk';
}
