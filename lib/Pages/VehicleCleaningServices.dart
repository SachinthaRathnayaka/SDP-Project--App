import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/BodyWash.dart';
import 'package:sachir_vehicle_care/Pages/VehicleCleaningMain.dart';

class VehicleCleaningServicesScreen extends StatelessWidget {
  const VehicleCleaningServicesScreen({Key? key}) : super(key: key);

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
                    bottom: 0,
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
                            MaterialPageRoute(builder: (context) => const VehicleCleaningScreen()),
                          );
                        },
                      ),
                    ),
                  ),

                  // SachiR Vehicle Care Logo
                  Positioned(
                    top: -30,
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

                  // "Our Services" text at bottom
                  const Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Text(
                      'Our Services',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3.0,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Services list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildServiceCard(
                      title: 'Body wash',
                      image: 'lib/assets/Bodywash.jpg',
                      price: 'LKR. 1,500',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BodyWashServiceScreen()),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    _buildServiceCard(
                      title: 'Full Service',
                      image: 'lib/assets/Fullservice.jpg',
                      price: 'LKR. 7,500',
                      onTap: () {
                        // Handle service selection
                      },
                    ),

                    const SizedBox(height: 15),

                    _buildServiceCard(
                      title: 'Under body cleaning',
                      image: 'lib/assets/UnderBodyClean.jpg',
                      price: 'LKR. 500',
                      onTap: () {
                        // Handle service selection
                      },
                    ),

                    const SizedBox(height: 15),

                    _buildServiceCard(
                      title: 'Interior cleaning',
                      image: 'lib/assets/InteriorCleaning.jpg',
                      price: 'LKR. 3,500',
                      onTap: () {
                        // Handle service selection
                      },
                    ),

                    const SizedBox(height: 15),

                    _buildServiceCard(
                      title: 'Engine Bay Cleaning',
                      image: 'lib/assets/EngineCleaning.jpg',
                      price: 'LKR. 650',
                      onTap: () {
                        // Handle service selection
                      },
                    ),

                    const SizedBox(height: 15),

                    _buildServiceCard(
                      title: 'Head Light cleaning',
                      image: 'lib/assets/HeadLightClean.jpg',
                      price: 'LKR. 1,200',
                      onTap: () {
                        // Handle service selection
                      },
                    ),

                    const SizedBox(height: 15),

                    _buildServiceCard(
                      title: 'Body Waxing',
                      image: 'lib/assets/BodyWaxing.jpg',
                      price: 'LKR. 14,500',
                      onTap: () {
                        // Handle service selection
                      },
                    ),

                    const SizedBox(height: 15),

                    _buildServiceCard(
                      title: 'Body Protect Sticker',
                      image: 'lib/assets/BodySticker.jpg',
                      price: 'LKR. 25,000',
                      onTap: () {
                        // Handle service selection
                      },
                    ),

                    const SizedBox(height: 15),

                    _buildServiceCard(
                      title: 'NANO Coating',
                      image: 'lib/assets/NanoCoating.jpg',
                      price: 'LKR. 18,000',
                      onTap: () {
                        // Handle service selection
                      },
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String image,
    required String price,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFF00B2CA),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),

              // Service title pill at top
              Positioned(
                top: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              // Price pill at bottom right
              Positioned(
                right: 15,
                bottom: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C853), // Green color for price tag
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
}