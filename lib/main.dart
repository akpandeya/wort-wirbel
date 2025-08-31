import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const WortWirbelApp());
}

class WortWirbelApp extends StatelessWidget {
  const WortWirbelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wort-Wirbel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
