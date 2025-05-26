import 'package:flutter/material.dart';
import '../models/calculation.dart';

class InputForm extends StatefulWidget {
  final void Function(Calculation) onCalculate;
  final void Function(Calculation)? onChanged;
  final Calculation? initialCalculation;

  const InputForm({
    super.key,
    required this.onCalculate,
    this.onChanged,
    this.initialCalculation,
  });

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _initialInvestmentController;
  late TextEditingController _annualReturnController;
  late TextEditingController _durationController;
  late TextEditingController _additionController;
  AdditionFrequency _frequency = AdditionFrequency.monthly;

  @override
  void initState() {
    super.initState();
    final calc = widget.initialCalculation;
    _nameController = TextEditingController(text: calc?.name ?? 'My Investment Strategy');
    _initialInvestmentController = TextEditingController(
        text: calc != null ? calc.initialInvestment.toStringAsFixed(2) : '10000.00');
    _annualReturnController = TextEditingController(
        text: calc != null ? calc.annualReturn.toString() : '7');
    _durationController = TextEditingController(
        text: calc != null ? calc.duration.toString() : '30');
    _additionController = TextEditingController(
        text: calc != null ? calc.addition.toStringAsFixed(2) : '300.00');
    _frequency = calc?.frequency ?? AdditionFrequency.monthly;
  }

  void _notifyChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(
        Calculation(
          name: _nameController.text,
          initialInvestment: double.tryParse(_initialInvestmentController.text) ?? 0,
          annualReturn: double.tryParse(_annualReturnController.text) ?? 0,
          duration: int.tryParse(_durationController.text) ?? 0,
          addition: double.tryParse(_additionController.text) ?? 0,
          frequency: _frequency,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Strategy Name'),
            onChanged: (_) => _notifyChanged(),
          ),
          TextFormField(
            controller: _initialInvestmentController,
            decoration: const InputDecoration(labelText: 'Initial Investment (\$)'),
            keyboardType: TextInputType.number,
            onChanged: (_) => _notifyChanged(),
          ),
          TextFormField(
            controller: _annualReturnController,
            decoration: const InputDecoration(labelText: 'Annual Return (%)'),
            keyboardType: TextInputType.number,
            onChanged: (_) => _notifyChanged(),
          ),
          TextFormField(
            controller: _durationController,
            decoration: const InputDecoration(labelText: 'Duration (years)'),
            keyboardType: TextInputType.number,
            onChanged: (_) => _notifyChanged(),
          ),
          TextFormField(
            controller: _additionController,
            decoration: const InputDecoration(labelText: 'Addition per Period (\$)'),
            keyboardType: TextInputType.number,
            onChanged: (_) => _notifyChanged(),
          ),
          DropdownButtonFormField<AdditionFrequency>(
            value: _frequency,
            decoration: const InputDecoration(labelText: 'Addition Frequency'),
            items: AdditionFrequency.values.map((freq) {
              return DropdownMenuItem(
                value: freq,
                child: Text(freq.toString().split('.').last),
              );
            }).toList(),
            onChanged: (freq) {
              if (freq != null) {
                setState(() {
                  _frequency = freq;
                });
                _notifyChanged();
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                widget.onCalculate(
                  Calculation(
                    name: _nameController.text,
                    initialInvestment: double.tryParse(_initialInvestmentController.text) ?? 0,
                    annualReturn: double.tryParse(_annualReturnController.text) ?? 0,
                    duration: int.tryParse(_durationController.text) ?? 0,
                    addition: double.tryParse(_additionController.text) ?? 0,
                    frequency: _frequency,
                    timestamp: DateTime.now(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.calculate, size: 28),
            label: const Text(
              'Calculate',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}