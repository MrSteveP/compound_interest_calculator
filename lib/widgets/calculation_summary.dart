import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/formulas.dart';

class CalculationSummary extends StatelessWidget {
  final CompoundInterestResult result;
  const CalculationSummary({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Total Value: \$${formatter.format(result.total)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Total Contribution: \$${formatter.format(result.contribution)}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Total Profit: \$${formatter.format(result.profit)}',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}