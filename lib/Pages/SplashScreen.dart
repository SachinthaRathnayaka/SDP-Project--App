import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/Login.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    // Fade in
    Timer(const Duration(milliseconds: 900), () {
      if (!_isDisposed && mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    // Fade out before navigation
    Timer(const Duration(seconds: 3), () {
      if (!_isDisposed && mounted) {
        setState(() {
          _opacity = 0.0;
        });
      }
    });

    // Navigate to Login screen after 4 seconds
    Timer(const Duration(seconds: 4), () {
      if (!_isDisposed && mounted && context != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0097A7), // Darker teal at top
              Color(0xFF26C6DA), // Lighter teal at bottom
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(seconds: 1),
                  child: Image.asset(
                    'lib/assets/SachiR_Vehicle_Care.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return const Center(
                        child: Text(
                          'SachiR Vehicle Care',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}