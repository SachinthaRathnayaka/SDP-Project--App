import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/HomeMenu.dart';
import 'package:sachir_vehicle_care/Pages/VehicleCleaningMain.dart';
import 'package:sachir_vehicle_care/Pages/VehicleRepairMain.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0099B1), // Teal background color
      body: SafeArea(
        top: true, // Remove top padding to reduce space at the top
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.28, // Reduced from 0.3
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Background image
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/Home_bg.jpg'),
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
                            Color(0xFF0099B1), // or match your app theme color
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Menu icon
                  Positioned(
                    top: 25,
                    left: 15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Color(0xFF002A32),
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const HomeMenuScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(-1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(position: offsetAnimation, child: child);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // SachiR Vehicle Care Logo
                  Positioned(
                    top: 60, // Slightly adjusted from 70
                    right: -130,
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/assets/SachiR_Vehicle_Care.png',
                          width: 400,
                          height: 180, // Reduced from 200
                          // color:Colors.white,
                        ),
                      ],
                    ),
                  ),

                  // Tagline text at bottom
                  const Positioned(
                    bottom: 00,
                    left: 30,
                    child: Text(
                      'Get your services easily...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 28, // Reduced from 30
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Services grid - centered and wrapped in Expanded
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.95,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.85,
                      shrinkWrap: true, // Makes grid take only needed space
                      children: [
                        _buildServiceCard(
                          title: 'Vehicle Cleaning',
                          image: 'lib/assets/Vehicle_Clean_BG.jpg',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const VehicleCleaningScreen()),
                            );
                          },
                        ),
                        _buildServiceCard(
                          title: 'Vehicle Repair',
                          image: 'lib/assets/Vehicle_Repair_BG.jpg',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const VehicleRepairMainScreen()),
                            );
                          },
                        ),
                        _buildServiceCard(
                          title: 'Vehicle Modification',
                          image: 'lib/assets/Vehicle_Modi_BG.jpg',
                          onTap: () {},
                        ),
                        _buildServiceCard(
                          title: 'Vehicle Charging',
                          image: 'lib/assets/Vehicle_Charge_BG.jpg',
                          onTap: () {},
                        ),
                        _buildServiceCard(
                          title: 'Vehicle Carrier Service',
                          image: 'lib/assets/Vehicle_Career_BG.jpg',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom navigation bar
            Container(
              height: 70, // Increased height to accommodate larger logo
              decoration: const BoxDecoration(
                color: Color(0xFF002A32), // Dark teal/navy background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.book, color: Colors.white),
                    iconSize: 30,
                    onPressed: () {},
                  ),

                  IconButton(
                    icon: const Icon(Icons.credit_card_sharp, color: Colors.white),
                    iconSize: 32,
                    onPressed: () {},
                  ),

                  // Center logo
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50, // Larger radius for the logo
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        'lib/assets/SachiR_Vehicle_Care.png', //SachiR Vehicle Care center logo
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    iconSize: 32,
                    onPressed: () {},
                  ),

                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.white),
                    iconSize: 35,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Service image (top 70%)
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Service title (bottom 30%)
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF0B4B57), // Teal background for title
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}