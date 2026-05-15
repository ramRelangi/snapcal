import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  final File image;

  const ResultScreen({super.key, required this.result, required this.image});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data;
    try {
      data = jsonDecode(result['raw']);
    } catch (e) {
      data = {"total_cal": 0, "items": ["Error"], "tip": "Try again"};
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Plate Analysis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.file(image, height: 300, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text('${data['total_cal'] ?? 0} Calories', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 10),
            Text('📍 Hyderabad / Telugu Style', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 30),
            _buildMacroRow('Protein', data['protein'] ?? 0, 'g', Colors.blue),
            _buildMacroRow('Carbs', data['carbs'] ?? 0, 'g', Colors.green),
            _buildMacroRow('Fat', data['fat'] ?? 0, 'g', Colors.red),
            const SizedBox(height: 30),
            Card(
              color: Colors.orange.shade50,
              child: Padding(padding: const EdgeInsets.all(16), child: Text(data['tip'] ?? 'Healthy choice!', style: const TextStyle(fontSize: 18), textAlign: TextAlign.center)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(onPressed: () { Fluttertoast.showToast(msg: "Saved to daily log ✓"); Navigator.pop(context); }, icon: const Icon(Icons.save), label: const Text('Save to Diary'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16))),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroRow(String label, num value, String unit, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(fontSize: 18)), Text('$value $unit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color))]),
    );
  }
}