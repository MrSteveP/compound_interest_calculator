import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation.dart';
import '../widgets/app_popup_menu.dart';
import '../widgets/bar_chart.dart';
import '../widgets/calculation_summary.dart';
import '../widgets/disclaimer_dialog.dart';
import '../widgets/input_form.dart';
import '../widgets/yearly_totals_list.dart';
import '../utils/disclaimer_prefs.dart';
import '../utils/formulas.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Calculation? _currentCalculation;
  CompoundInterestResult? _result;
  Calculation? _lastInput;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkDisclaimer();
    _loadLastInput();
  }

  void _checkDisclaimer() async {
    if (!await DisclaimerPrefs.hasAgreed()) {
      await Future.delayed(Duration.zero); // Ensure context is ready
      final agreed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => DisclaimerDialog(),
      );
      if (agreed != true) {
        Future.delayed(const Duration(milliseconds: 300), () {
          exit(0); // Force quit the app
        });
      }
    }
  }

  Future<void> _saveLastInput(Calculation calc) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('last_name', calc.name);
    prefs.setDouble('last_initial', calc.initialInvestment);
    prefs.setDouble('last_return', calc.annualReturn);
    prefs.setInt('last_duration', calc.duration);
    prefs.setDouble('last_addition', calc.addition);
    prefs.setInt('last_frequency', calc.frequency.index);
  }

  Future<void> _loadLastInput() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('last_initial')) {
      _lastInput = Calculation(
        name: prefs.getString('last_name') ?? 'My Investment Strategy',
        initialInvestment: prefs.getDouble('last_initial') ?? 5000,
        annualReturn: prefs.getDouble('last_return') ?? 7,
        duration: prefs.getInt('last_duration') ?? 20,
        addition: prefs.getDouble('last_addition') ?? 300,
        frequency: AdditionFrequency.values[
            prefs.getInt('last_frequency') ?? AdditionFrequency.monthly.index],
        timestamp: DateTime.now(),
      );
    }
    setState(() {
      _loading = false;
    });
  }

  void _onCalculate(Calculation calc) {
    setState(() {
      _currentCalculation = calc;
      _result = calculateCompoundInterest(
        principal: calc.initialInvestment,
        rate: calc.annualReturn,
        years: calc.duration,
        addition: calc.addition,
        frequency: calc.frequency,
      );
    });
  }

  void _onInputChanged(Calculation calc) {
    _saveLastInput(calc);
    // Do not setState or update _currentCalculation here!
  }

  void _onSave() async {
    if (_currentCalculation != null) {
      await StorageService().saveCalculation(_currentCalculation!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calculation saved!')),
      );
    }
  }

void _onLoadStrategy(Calculation calc) {
  setState(() {
    _currentCalculation = calc;
    _result = calculateCompoundInterest(
      principal: calc.initialInvestment,
      rate: calc.annualReturn,
      years: calc.duration,
      addition: calc.addition,
      frequency: calc.frequency,
    );
    _lastInput = calc; // Update the form fields immediately
  });
  _saveLastInput(calc); // Persist for next session
}

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlutterLogo(size: 36),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Compound Interest Calculator',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          AppPopupMenu(
            onNew: () {
              setState(() {
                _currentCalculation = null;
                _result = null;
              });
            },
            onLoadStrategy: _onLoadStrategy,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InputForm(
              key: ValueKey(_currentCalculation ?? _lastInput),
              onCalculate: _onCalculate,
              onChanged: _onInputChanged,
              initialCalculation: _currentCalculation ?? _lastInput,
            ),
            if (_result != null) ...[
              CalculationSummary(result: _result!),
              const SizedBox(height: 16),
              BarChartWidget(result: _result!),
              YearlyTotalsList(result: _result!),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _onSave,
                icon: const Icon(Icons.save, size: 28),
                label: const Text(
                  'Save Calculation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 240,
                  child: Divider(thickness: 2),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Formula:',
                        style: TextStyle(fontSize: 12),
                      ),
                      const Text(
                        'A = P(1 + r/n)^(nt) + [PMT * (((1 + r/n)^(nt) - 1) / (r/n))]',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Where:',
                        style: TextStyle(fontSize: 12),
                      ),
                      const Text(
                        'A = Final amount\n'
                        'P = Initial investment (principal)\n'
                        'r = Annual interest rate (as a decimal)\n'
                        'n = Number of compounding periods per year\n'
                        't = Number of years\n'
                        'PMT = Additional payment per period',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ],
        ),
      ),
    );
  }
}