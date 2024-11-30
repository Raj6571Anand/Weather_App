import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFB3E5FC), // Frost Blue
          secondary: Color(0xFF81D4FA), // Pale Ice Blue
          // background: Color(0xFF0D47A1), // Midnight Blue
          surface: Color(0xFF1565C0), // Arctic Grey for Cards
          onPrimary: Color(0xFF0D47A1), // Deep Navy on Primary
          onSecondary: Color(0xFF0D47A1), // Deep Navy on Secondary
        ),
        scaffoldBackgroundColor: const Color(0xFF0D47A1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1), // Frost Blue for AppBar
        ),
      ),
      home: const WeatherScreen(),
    );
  }
}
