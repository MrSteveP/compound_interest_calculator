import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/formulas.dart';

class BarChartWidget extends StatelessWidget {
  final CompoundInterestResult result;
  const BarChartWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < result.yearlyTotals.length; i++) {
      final contribution = result.yearlyContributions[i];
      final profit = result.yearlyProfits[i];
      barGroups.add(
        BarChartGroupData(
          x: i + 1,
          barRods: [
            BarChartRodData(
              toY: contribution + profit,
              width: 18,
              borderRadius: BorderRadius.zero,
              rodStackItems: [
                BarChartRodStackItem(0, contribution, Colors.blue),
                BarChartRodStackItem(
                    contribution, contribution + profit, Colors.green),
              ],
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          groupsSpace: 20,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Text(formatNumberAbbreviated(value),
                        style: const TextStyle(fontSize: 11));
                  },
                  showTitles: true,
                  reservedSize: 32),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text(
                  'Year',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
                ),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text('${(value - 1).toInt()}',
                      style: const TextStyle(fontSize: 11));
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barTouchData: BarTouchData(enabled: true),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
