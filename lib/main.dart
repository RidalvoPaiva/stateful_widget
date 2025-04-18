import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculador de Média',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CalculadorMedia(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculadorMedia extends StatefulWidget {
  const CalculadorMedia({super.key});

  @override
  State<CalculadorMedia> createState() => _CalculadorMediaState();
}

class _CalculadorMediaState extends State<CalculadorMedia> {
  final _controllers = {
    'nome': TextEditingController(),
    'email': TextEditingController(),
    'nota1': TextEditingController(),
    'nota2': TextEditingController(),
    'nota3': TextEditingController(),
  };

  final _resultados = {
    'nome': '',
    'email': '',
    'notas': '- -',
    'media': '',
    'status': '',
  };

  bool _validarEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  String? _validarNota(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    final nota = double.tryParse(value);
    if (nota == null) return 'Digite um número válido';
    if (nota < 0 || nota > 10) return 'Nota deve ser entre 0 e 10';
    return null;
  }

  void _calcularMedia() {
    if (_controllers.values.any((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    if (!_validarEmail(_controllers['email']!.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um e-mail válido!')),
      );
      return;
    }

    final notas = [
      double.tryParse(_controllers['nota1']!.text)!,
      double.tryParse(_controllers['nota2']!.text)!,
      double.tryParse(_controllers['nota3']!.text)!,
    ];

    final media = notas.reduce((total, nota) => total + nota) / notas.length;
    final status = media >= 6 ? 'Aprovado! 🎉' : 'Reprovado. 😢';

    setState(() {
      _resultados['nome'] = _controllers['nome']!.text;
      _resultados['email'] = _controllers['email']!.text;
      _resultados['notas'] = notas.map((nota) => nota.toStringAsFixed(1)).join(' - ');
      _resultados['media'] = media.toStringAsFixed(1);
      _resultados['status'] = status;
    });
  }

  void _apagarCampos() {
    setState(() {
      for (final controller in _controllers.values) {
        controller.clear();
      }
      for (final key in _resultados.keys) {
        _resultados[key] = key == 'notas' ? '- -' : '';
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildCampo(String label, String chave, {bool isNota = false}) {
    return TextField(
      controller: _controllers[chave],
      keyboardType: isNota ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText: isNota ? _validarNota(_controllers[chave]!.text) : null,
      ),
      onChanged: isNota ? (_) => setState(() {}) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculador de Média - DPM 2025.1'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CALCULADOR DE MÉDIA',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCampo('NOME', 'nome'),
            const SizedBox(height: 10),
            _buildCampo('eMAIL', 'email'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildCampo('Nota 1', 'nota1', isNota: true)),
                const SizedBox(width: 10),
                Expanded(child: _buildCampo('Nota 2', 'nota2', isNota: true)),
                const SizedBox(width: 10),
                Expanded(child: _buildCampo('Nota 3', 'nota3', isNota: true)),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _calcularMedia,
                child: const Text('CALCULA MÉDIA'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'RESULTADO:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Nome: ${_resultados['nome']}'),
            Text('eMail: ${_resultados['email']}'),
            Text('Notas: ${_resultados['notas']}'),
            Text('Média: ${_resultados['media']}'),
            Text(
              'Status: ${_resultados['status']}',
              style: TextStyle(
                color: _resultados['status'] == 'Aprovado! 🎉' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _apagarCampos,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('APAGAR OS CAMPOS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}