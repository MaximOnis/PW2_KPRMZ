import 'package:flutter/material.dart';
import 'calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор викидів',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const EmissionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EmissionScreen extends StatefulWidget {
  const EmissionScreen({super.key});

  @override
  State<EmissionScreen> createState() => _EmissionScreenState();
}

class _EmissionScreenState extends State<EmissionScreen> {
  final _coalController = TextEditingController();
  final _mazutController = TextEditingController();
  final _gasController = TextEditingController();

  EmissionResults? _results;

  double _parse(String text) {
    return double.tryParse(text.replaceAll(',', '.')) ?? 0;
  }

  void calculateAndDisplay() {
    double coal = _parse(_coalController.text);
    double mazut = _parse(_mazutController.text);
    double gas = _parse(_gasController.text);

    setState(() {
      _results = EmissionCalculator.calculate(coal, mazut, gas);
    });
  }

  void clearFields() {
    setState(() {
      _coalController.clear();
      _mazutController.clear();
      _gasController.clear();
      _results = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// 🔷 HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.eco, color: Colors.white, size: 40),
                      SizedBox(height: 10),
                      Text(
                        'Калькулятор викидів',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Розрахунок шкідливих речовин',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// 🔷 INPUTS
                _buildInputCard('Вугілля (т)', Icons.agriculture, _coalController),
                _buildInputCard('Мазут (т)', Icons.local_gas_station, _mazutController),
                _buildInputCard('Газ (м³)', Icons.local_fire_department, _gasController),

                const SizedBox(height: 25),

                /// 🔷 BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: calculateAndDisplay,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Розрахувати',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: clearFields,
                      icon: const Icon(Icons.refresh),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 25),

                /// 🔷 RESULTS
                if (_results != null) ...[
                  _buildResultCard(
                      'Вугілля',
                      _results!.ktvCoal,
                      _results!.etvCoal,
                      Colors.brown),
                  _buildResultCard(
                      'Мазут',
                      _results!.ktvMazut,
                      _results!.etvMazut,
                      Colors.orange),
                  _buildResultCard(
                      'Газ',
                      _results!.ktvGas,
                      _results!.etvGas,
                      Colors.blue),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(String label, IconData icon, TextEditingController controller) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(icon, color: Colors.teal),
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String ktv, String etv, Color color) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border(left: BorderSide(color: color, width: 6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 8),
            Text('Емісія: $ktv г/ГДж'),
            Text('Викиди: $etv т'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _coalController.dispose();
    _mazutController.dispose();
    _gasController.dispose();
    super.dispose();
  }
}