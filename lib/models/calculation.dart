/// import 'dart:convert';

enum AdditionFrequency { annually, quarterly, monthly, weekly, daily }

class Calculation {
  final String name;
  final double initialInvestment;
  final double annualReturn;
  final int duration;
  final double addition;
  final AdditionFrequency frequency;
  final DateTime timestamp;

  Calculation({
    required this.name,
    required this.initialInvestment,
    required this.annualReturn,
    required this.duration,
    required this.addition,
    required this.frequency,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'initialInvestment': initialInvestment,
        'annualReturn': annualReturn,
        'duration': duration,
        'addition': addition,
        'frequency': frequency.index,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Calculation.fromJson(Map<String, dynamic> json) {
    print('fromJson: $json');
    int freqIndex = 0;
    if (json['frequency'] is int &&
        json['frequency'] >= 0 &&
        json['frequency'] < AdditionFrequency.values.length) {
      freqIndex = json['frequency'];
    }

    double parseDouble(dynamic v, double fallback) {
      if (v is int) return v.toDouble();
      if (v is double) return v;
      if (v is String) return double.tryParse(v) ?? fallback;
      return fallback;
    }

    int parseInt(dynamic v, int fallback) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? fallback;
      return fallback;
    }

    DateTime safeTimestamp;
    try {
      safeTimestamp = DateTime.parse(json['timestamp'] ?? '');
    } catch (_) {
      safeTimestamp = DateTime.now();
    }

    return Calculation(
      name: json['name'] ?? '',
      initialInvestment: parseDouble(json['initialInvestment'], 1000),
      annualReturn: parseDouble(json['annualReturn'], 7),
      duration: parseInt(json['duration'], 10),
      addition: parseDouble(json['addition'], 0),
      frequency: AdditionFrequency.values[freqIndex],
      timestamp: safeTimestamp,
    );
  }
}
