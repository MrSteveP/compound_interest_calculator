import 'package:flutter/material.dart';
import '../models/calculation.dart';
import '../services/storage_service.dart';

class SavedCalculationsScreen extends StatefulWidget {
  const SavedCalculationsScreen({super.key});

  @override
  State<SavedCalculationsScreen> createState() =>
      _SavedCalculationsScreenState();
}

class _SavedCalculationsScreenState extends State<SavedCalculationsScreen> {
  List<Calculation> _calculations = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final calcs = await StorageService().loadCalculations();
    setState(() {
      _calculations = calcs;
    });
  }

  Future<void> _delete(Calculation calc) async {
    await StorageService().deleteCalculation(calc);
    await _load();
  }

  void _confirmDelete(BuildContext context, Calculation calc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Strategy'),
        content: Text(
            'Are you sure you want to permanently delete "${calc.name}" strategy?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _delete(calc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Saved Strategies',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      )),
      body: ListView.builder(
        itemCount: _calculations.length,
        itemBuilder: (context, i) {
          final calc = _calculations[i];
          return ListTile(
            contentPadding: const EdgeInsets.only(left: 16, right: 4), // Reduce right padding
            title: Text(calc.name),
            subtitle: Text(
                'Initial: \$${calc.initialInvestment.toStringAsFixed(2)}, Return: ${calc.annualReturn.toStringAsFixed(2)}%, Years: ${calc.duration}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, calc),
            ),
            onTap: () {
              Navigator.pop(context, calc);
            },
          );
        },
      ),
    );
  }
}
