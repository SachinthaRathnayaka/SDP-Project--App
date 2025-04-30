import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/Login.dart';

class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Main content area
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: double.infinity,
            color: const Color(0xFF00C2E8), // Cyan background color
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 10),

                  // Back button and profile picture
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,  // Align items to the top
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -5),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage('lib/assets/Sachintha.jpg'),
                        ),
                      ],
                    ),
                  ),

                  _buildMenuItem(
                    icon: Icons.miscellaneous_services,
                    title: 'Our services',
                    onTap: () {
                      // Navigate to services
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.calendar_today,
                    title: 'My Bookings',
                    onTap: () {
                      // Navigate to bookings
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.payment,
                    title: 'Payments',
                    onTap: () {
                      // Navigate to payments
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.phone,
                    title: 'Contact us',
                    onTap: () {
                      // Navigate to contact
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.info,
                    title: 'About us',
                    onTap: () {
                      // Navigate to about
                    },
                  ),

                  // Vehicle service illustration
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          // color: Colors.white,
                        ),
                        child: ClipRRect(
                          child: Image.asset(
                            'lib/assets/Car_Cleaning.webp',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Log out button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCD0D0D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.logout, size: 26),
                          SizedBox(width: 12),
                          Text('Log out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      ),
                    ),
                  ),

                  const Divider(color: Colors.black38),

                  // Company info at bottom
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        // Company logo
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              'lib/assets/OIP.jpeg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Company details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Mint Auto Care Pvt. Ltd.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '572, KANDY ROAD, PATTIYA JUNCTION, RATHNAPURA P.S, PELIYADODA, KELENIYA, PELIYADODA',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black87,
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Semi-transparent overlay for the remaining screen area
          Positioned(
            left: MediaQuery.of(context).size.width * 0.85,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black87,
              size: 32,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20, // Increased font size from 16 to 20
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}