/// How often a form must be filled. One response per user per period.
enum FormFrequency {
  once,
  daily,
  weekly,
  monthly,
  custom; // custom = every [intervalDays] days from the form start date

  static FormFrequency fromString(String? v) => FormFrequency.values
      .firstWhere((f) => f.name == v, orElse: () => FormFrequency.once);

  String get label => switch (this) {
    FormFrequency.once => 'Once only',
    FormFrequency.daily => 'Daily',
    FormFrequency.weekly => 'Weekly',
    FormFrequency.monthly => 'Monthly',
    FormFrequency.custom => 'Custom',
  };
}

class FrequencyRule {
  final FormFrequency frequency;
  final int intervalDays; // only for custom
  final DateTime? startDate; // anchor for custom

  const FrequencyRule({
    this.frequency = FormFrequency.once,
    this.intervalDays = 1,
    this.startDate,
  });

  factory FrequencyRule.fromJson(Map<String, dynamic>? j) => j == null
      ? const FrequencyRule()
      : FrequencyRule(
    frequency: FormFrequency.fromString(j['frequency']?.toString()),
    intervalDays: (j['interval_days'] as num?)?.toInt() ?? 1,
    startDate: DateTime.tryParse('${j['start_date']}'),
  );

  Map<String, dynamic> toJson() => {
    'frequency': frequency.name,
    'interval_days': intervalDays,
    'start_date': startDate?.toIso8601String(),
  };

  /// Key identifying the current period. A response with the same
  /// (form, user, periodKey) means the form is "done" for this period.
  /// Backend must compute the same key, so the server stays the source of truth.
  String periodKey(DateTime now) {
    final d = DateTime(now.year, now.month, now.day);
    String two(int n) => n.toString().padLeft(2, '0');
    switch (frequency) {
      case FormFrequency.once:
        return 'once';
      case FormFrequency.daily:
        return '${d.year}-${two(d.month)}-${two(d.day)}';
      case FormFrequency.weekly:
        final monday = d.subtract(Duration(days: d.weekday - 1));
        return 'W${monday.year}-${two(monday.month)}-${two(monday.day)}';
      case FormFrequency.monthly:
        return '${d.year}-${two(d.month)}';
      case FormFrequency.custom:
        final s = startDate ?? d;
        final base = DateTime(s.year, s.month, s.day);
        final n = d.difference(base).inDays ~/ (intervalDays < 1 ? 1 : intervalDays);
        return 'C$n';
    }
  }
}