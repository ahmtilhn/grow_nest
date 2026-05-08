enum TimingStatus { early, normal, late }

class AgeUtils {
  const AgeUtils._();

  static String babyAge(DateTime birthDate, DateTime now) {
    final days = now.difference(birthDate).inDays;
    if (days < 0) throw ArgumentError('Birth date cannot be in the future.');
    if (days < 30) return '$days günlük';
    final months = days ~/ 30;
    final remaining = days % 30;
    return '$months ay $remaining günlük';
  }

  static int pregnancyWeekFromDueDate(DateTime dueDate, DateTime now) {
    final daysUntilDue = dueDate.difference(now).inDays;
    final week = 40 - (daysUntilDue ~/ 7);
    return week.clamp(0, 42);
  }

  static int pregnancyDayFromDueDate(DateTime dueDate, DateTime now) {
    final daysUntilDue = dueDate.difference(now).inDays;
    return (280 - daysUntilDue).clamp(0, 294) % 7;
  }
}

class FeedingScheduleResult {
  const FeedingScheduleResult({
    required this.status,
    required this.nextSuggestedAt,
    required this.minutesDelta,
  });

  final TimingStatus status;
  final DateTime nextSuggestedAt;
  final int minutesDelta;
}

class FeedingScheduleCalculator {
  const FeedingScheduleCalculator({
    this.defaultInterval = const Duration(hours: 3),
    this.tolerance = const Duration(minutes: 30),
  });

  final Duration defaultInterval;
  final Duration tolerance;

  FeedingScheduleResult calculate({
    required DateTime previousFeedingAt,
    required DateTime currentFeedingAt,
    double? amountMl,
    Duration? preferredInterval,
  }) {
    final interval = preferredInterval ?? defaultInterval;
    final expected = previousFeedingAt.add(interval);
    final delta = currentFeedingAt.difference(expected);
    final lowAmountAdjustment =
        amountMl != null && amountMl > 0 && amountMl < 60
        ? const Duration(minutes: -30)
        : Duration.zero;
    final next = currentFeedingAt.add(interval).add(lowAmountAdjustment);

    if (delta < -tolerance) {
      return FeedingScheduleResult(
        status: TimingStatus.early,
        nextSuggestedAt: next,
        minutesDelta: delta.inMinutes,
      );
    }
    if (delta > tolerance) {
      return FeedingScheduleResult(
        status: TimingStatus.late,
        nextSuggestedAt: next,
        minutesDelta: delta.inMinutes,
      );
    }
    return FeedingScheduleResult(
      status: TimingStatus.normal,
      nextSuggestedAt: next,
      minutesDelta: delta.inMinutes,
    );
  }
}

class ValidationUtils {
  const ValidationUtils._();

  static bool validEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
  }

  static double? positiveDouble(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null || parsed < 0) return null;
    return parsed;
  }
}

enum GrowthMetric { weight, height, headCircumference }

enum GrowthComparisonStatus { belowBand, inBand, aboveBand, missing }

class GrowthBand {
  const GrowthBand({
    required this.p3,
    required this.p50,
    required this.p97,
    required this.unit,
  });

  final double p3;
  final double p50;
  final double p97;
  final String unit;

  GrowthComparisonStatus compare(double? value) {
    if (value == null || value <= 0) return GrowthComparisonStatus.missing;
    if (value < p3) return GrowthComparisonStatus.belowBand;
    if (value > p97) return GrowthComparisonStatus.aboveBand;
    return GrowthComparisonStatus.inBand;
  }
}

class GrowthReference {
  const GrowthReference._();

  static const sourceName = 'WHO/CDC/AAP';
  static const sourceUrl =
      'https://www.cdc.gov/growth-chart-training/hcp/using-growth-charts/who-summary.html';

  static GrowthBand bandFor({
    required int ageMonths,
    required GrowthMetric metric,
  }) {
    final points = switch (metric) {
      GrowthMetric.weight => _weightKg,
      GrowthMetric.height => _lengthCm,
      GrowthMetric.headCircumference => _headCm,
    };
    final unit = switch (metric) {
      GrowthMetric.weight => 'kg',
      GrowthMetric.height => 'cm',
      GrowthMetric.headCircumference => 'cm',
    };
    final month = ageMonths.clamp(0, 24);
    if (points.containsKey(month)) {
      final values = points[month]!;
      return GrowthBand(
        p3: values[0],
        p50: values[1],
        p97: values[2],
        unit: unit,
      );
    }

    final lower = points.keys
        .where((key) => key < month)
        .reduce((a, b) => a > b ? a : b);
    final upper = points.keys
        .where((key) => key > month)
        .reduce((a, b) => a < b ? a : b);
    final ratio = (month - lower) / (upper - lower);
    final lowValues = points[lower]!;
    final highValues = points[upper]!;
    double lerp(int index) =>
        lowValues[index] + (highValues[index] - lowValues[index]) * ratio;
    return GrowthBand(p3: lerp(0), p50: lerp(1), p97: lerp(2), unit: unit);
  }

  static String message(GrowthComparisonStatus status) => switch (status) {
    GrowthComparisonStatus.belowBand =>
      'WHO aralığının altında görünüyor; ölçümü tekrar edip çocuk doktoruyla paylaşın.',
    GrowthComparisonStatus.inBand =>
      'WHO referans aralığında. Trend aynı yönde sakin ilerliyorsa iyi bir işaret.',
    GrowthComparisonStatus.aboveBand =>
      'WHO aralığının üstünde görünüyor; tek ölçüm yerine trendi doktorla birlikte değerlendirin.',
    GrowthComparisonStatus.missing => 'Ölçüm ekleyince karşılaştırma yapılır.',
  };

  static const Map<int, List<double>> _weightKg = {
    0: [2.5, 3.3, 4.4],
    1: [3.4, 4.5, 5.8],
    2: [4.3, 5.6, 7.1],
    3: [5.0, 6.4, 8.0],
    4: [5.6, 7.0, 8.7],
    5: [6.0, 7.5, 9.3],
    6: [6.4, 7.9, 9.8],
    9: [7.1, 8.9, 11.0],
    12: [7.7, 9.6, 12.0],
    18: [8.7, 10.9, 13.7],
    24: [9.7, 12.2, 15.3],
  };

  static const Map<int, List<double>> _lengthCm = {
    0: [45.5, 49.9, 54.7],
    1: [50.0, 54.7, 59.5],
    2: [53.2, 58.4, 63.2],
    3: [56.0, 61.4, 66.4],
    4: [58.2, 63.9, 69.0],
    5: [60.0, 65.9, 71.0],
    6: [61.5, 67.6, 72.9],
    9: [65.4, 72.0, 78.4],
    12: [68.9, 76.1, 82.9],
    18: [74.2, 82.3, 89.4],
    24: [80.0, 88.0, 96.0],
  };

  static const Map<int, List<double>> _headCm = {
    0: [32.0, 34.5, 37.0],
    1: [34.5, 37.3, 40.0],
    2: [36.2, 39.1, 42.0],
    3: [37.5, 40.5, 43.3],
    4: [38.5, 41.6, 44.4],
    5: [39.3, 42.6, 45.3],
    6: [40.0, 43.3, 46.0],
    9: [41.4, 45.0, 47.8],
    12: [42.5, 46.1, 49.0],
    18: [44.0, 47.5, 50.5],
    24: [45.0, 48.5, 51.5],
  };
}

class GrowthMeasurement {
  const GrowthMeasurement({this.weightKg, this.heightCm, this.headCm});

  final double? weightKg;
  final double? heightCm;
  final double? headCm;

  static GrowthMeasurement parse(String? value) {
    if (value == null || value.trim().isEmpty) return const GrowthMeasurement();
    final map = <String, double>{};
    for (final part in value.split(';')) {
      final pieces = part.split('=');
      if (pieces.length != 2) continue;
      final parsed = ValidationUtils.positiveDouble(pieces.last);
      if (parsed != null) map[pieces.first.trim()] = parsed;
    }
    return GrowthMeasurement(
      weightKg: map['weightKg'],
      heightCm: map['heightCm'],
      headCm: map['headCm'],
    );
  }
}

class SleepRoutineGuide {
  const SleepRoutineGuide._();

  static String expectedRangeLabel(int ageMonths) {
    if (ageMonths < 4) return '14-17 saat / gün';
    if (ageMonths < 12) return '12-16 saat / gün';
    if (ageMonths < 24) return '11-14 saat / gün';
    return '10-13 saat / gün';
  }

  static Duration suggestedWakeWindow(int ageMonths) {
    if (ageMonths < 4) return const Duration(minutes: 75);
    if (ageMonths < 6) return const Duration(hours: 2);
    if (ageMonths < 12) return const Duration(hours: 3);
    return const Duration(hours: 4);
  }
}
