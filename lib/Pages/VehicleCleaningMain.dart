import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/VehicleCleaningServices.dart';
import 'package:sachir_vehicle_care/Pages/ServiceBooking.dart';
import 'package:sachir_vehicle_care/Pages/HomeScreen.dart';

class VehicleCleaningScreen extends StatelessWidget {
  const VehicleCleaningScreen({Key? key}) : super(key: key);

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
              Color(0xFF004D5B), // Darker teal at top
              Color(0xFF00B2CA), // Lighter teal at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top image with car cleaning and back button
              Stack(
                children: [
                  // Background image
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/VehicleCleaningMainBG.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),

                  // Gradient overlay at the bottom
                  Positioned(
                    bottom: 00,
                    left: 0,
                    right: 0,
                    height: 100,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0xFF137080), // or match your app theme color
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Back button
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.5),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                      ),
                    ),
                  ),

                  // SachiR Vehicle Care Logo
                  Positioned(
                    top: 80,
                    right: -130,
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/assets/SachiR_Vehicle_Care.png',
                          width: 400,
                          height: 200,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),

                ],
              ),

              // "Vehicle cleaning" text
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Text(
                  'Vehicle cleaning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),

              // Main menu options
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Our services button
                          _buildMenuButton(
                            image: 'lib/assets/VehicleCleaning2.jpg',
                            label: 'Our services',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const VehicleCleaningServicesScreen()),
                              );
                            },
                          ),

                          const SizedBox(height: 25),

                          // Book your time button
                          _buildMenuButton(
                            image: 'lib/assets/VehicleCleaning1.jpg',
                            label: 'Book your time',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ServiceBookingScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String image,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [

          // Image container
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay for better text visibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),

          // Button label positioned at bottom center of image
          Positioned(
            bottom:10,
            left: 0,
            right: 0,
            child: Container(
              width: 180,
              margin: const EdgeInsets.symmetric(horizontal: 60),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF034B5A),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}