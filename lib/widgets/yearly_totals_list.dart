import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
import '../utils/formulas.dart';

class YearlyTotalsList extends StatelessWidget {
  final CompoundInterestResult result;
  const YearlyTotalsList({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          const ListTile(
            title: Text('Yearly Totals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...List.generate(result.yearlyTotals.length, (i) {
            return ListTile(
              leading: Text('Year $i', style: TextStyle(fontSize: 12)),
              title: Text('Total: \$${formatter.format(result.yearlyTotals[i])}'),
              subtitle: Text(
                'Contribution: \$${formatter.format(result.yearlyContributions[i])} | Profit: \$${formatter.format(result.yearlyProfits[i])}',
              ),
            );
          }),
        ],
      ),
    );
  }
}