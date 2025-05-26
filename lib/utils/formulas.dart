import '../models/calculation.dart';

class CompoundInterestResult {
  final double total;
  final double contribution;
  final double profit;
  final List<double> yearlyTotals;
  final List<double> yearlyContributions;
  final List<double> yearlyProfits;

  CompoundInterestResult({
    required this.total,
    required this.contribution,
    required this.profit,
    required this.yearlyTotals,
    required this.yearlyContributions,
    required this.yearlyProfits,
  });
}

int getFrequencyValue(AdditionFrequency freq) {
  switch (freq) {
    case AdditionFrequency.annually:
      return 1;
    case AdditionFrequency.quarterly:
      return 4;
    case AdditionFrequency.monthly:
      return 12;
    case AdditionFrequency.weekly:
      return 52;
    case AdditionFrequency.daily:
      return 365;
  }
}

CompoundInterestResult calculateCompoundInterest({
  required double principal,
  required double rate,
  required int years,
  required double addition,
  required AdditionFrequency frequency,
}) {
  final n = getFrequencyValue(frequency);
  final r = rate / 100;
  double total = principal;
  double totalContribution = principal;

  // Add Year 0 values
  List<double> yearlyTotals = [principal];
  List<double> yearlyContributions = [principal];
  List<double> yearlyProfits = [0];

  for (int year = 1; year <= years; year++) {
    for (int period = 0; period < n; period++) {
      total *= (1 + r / n);
      total += addition;
      totalContribution += addition;
    }
    yearlyTotals.add(total);
    yearlyContributions.add(totalContribution);
    yearlyProfits.add(total - totalContribution);
  }

  return CompoundInterestResult(
    total: total,
    contribution: totalContribution,
    profit: total - totalContribution,
    yearlyTotals: yearlyTotals,
    yearlyContributions: yearlyContributions,
    yearlyProfits: yearlyProfits,
  );
}

/// Formats a number with K/M/B abbreviations and a non-breaking space before the suffix.
/// Example: 12345 -> "12.3 K"
String formatNumberAbbreviated(num value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(0)}B';
  } else if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(0)}M';
  } else if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(0)}K';
  } else {
    return value.toStringAsFixed(0);
  }
}