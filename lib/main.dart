import 'package:flutter/material.dart';

void main() {
  runApp(const GoRouteApp());
}

class GoRouteApp extends StatelessWidget {
  const GoRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoRoute',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoRoute Mobile')),
      body: const Center(
        child: Text('SPEC-15 — app Flutter mínimo (roadmap + auth em releases futuras).'),
      ),
    );
  }
}
