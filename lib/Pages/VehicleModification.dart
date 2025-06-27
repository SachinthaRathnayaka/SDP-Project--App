import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/ModPerformance.dart';
import 'package:sachir_vehicle_care/Pages/ModInterior.dart';
import 'package:sachir_vehicle_care/Pages/ModExterior.dart';
import 'package:sachir_vehicle_care/Pages/ModAudio.dart';
import 'package:sachir_vehicle_care/Pages/ModWheel.dart';
import 'package:sachir_vehicle_care/Pages/ModLight.dart';

class VehicleModificationsScreen extends StatelessWidget {
  const VehicleModificationsScreen({Key? key}) : super(key: key);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and title
              Stack(
                children: [
                  // Background image with gradient overlay
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        'lib/assets/InteriorCleaning.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF004D5B),
                          );
                        },
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
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),

                  const Positioned(
                    bottom: 00,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Modifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),

                  // SachiR Vehicle Care Logo
                  Positioned(
                    top: -10,
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

              // Modifications grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85, // Keep consistent aspect ratio
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildModificationCard(
                        title: 'Performance\nUpgrades',
                        icon: Icons.speed,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VehicleModificationPartsScreen()),
                          );
                        },
                      ),
                      _buildModificationCard(
                        title: 'Interior\nCustomization',
                        icon: Icons.airline_seat_recline_normal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VehicleInteriorModificationPartsScreen()),
                          );
                        },
                      ),
                      _buildModificationCard(
                        title: 'Exterior\nStyling',
                        icon: Icons.directions_car,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VehicleExteriorModificationPartsScreen()),
                          );
                        },
                      ),
                      _buildModificationCard(
                        title: 'Audio\nUpgrades',
                        icon: Icons.speaker,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VehicleAudioModificationPartsScreen()),
                          );
                        },
                      ),
                      _buildModificationCard(
                        title: 'Wheel\nCustomization',
                        icon: Icons.disc_full,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VehicleWheelModificationPartsScreen()),
                          );
                        },
                      ),
                      _buildModificationCard(
                        title: 'Lighting\nEnhancements',
                        icon: Icons.lightbulb,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VehicleLightModificationPartsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModificationCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF00B2CA),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 15),
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF004D5B),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}