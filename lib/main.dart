import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/SplashScreen.dart';


void main() {
  runApp(const SachiR_Vehicle_Care());
}

class SachiR_Vehicle_Care extends StatelessWidget {
  const SachiR_Vehicle_Care({super.key});

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SachiR Vehicle Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255,48,28,83),
        ),
      ),
      home: SplashScreen(),
    );
  }
}