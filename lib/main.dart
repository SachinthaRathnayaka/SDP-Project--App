import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sachir_vehicle_care/Pages/SplashScreen.dart';
import 'package:sachir_vehicle_care/providers/auth_provider.dart';
import 'package:sachir_vehicle_care/providers/vehicle_provider.dart';
import 'package:sachir_vehicle_care/providers/appointment_provider.dart';
import 'package:sachir_vehicle_care/providers/service_provider.dart';

void main() {
  runApp(
    MultiProvider(      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ],
      child: const SachiR_Vehicle_Care(),
    ),
  );
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