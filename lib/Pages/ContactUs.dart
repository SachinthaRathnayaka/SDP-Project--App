import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  // Direct dial phone function
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      await launchUrl(launchUri);
    } catch (e) {
      debugPrint('Could not launch dialer: $e');
      // Show a snackbar or alert if the dialer couldn't be launched
    }
  }

  // Function to launch email
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@sachir.lk',
      queryParameters: {
        'subject': 'Customer Inquiry',
        'body': 'Hello SachiR Vehicle Care,'
      },
    );
    try {
      await launchUrl(emailUri);
    } catch (e) {
      debugPrint('Could not launch email client: $e');
      // Show a snackbar or alert if the email client couldn't be launched
    }
  }

  // Function to open location in maps
  Future<void> _openMap() async {
    const String googleMapsUrl = 'https://maps.google.com/?q=6.9509,79.9171&z=17';
    final Uri mapUri = Uri.parse(googleMapsUrl);
    try {
      await launchUrl(mapUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch maps: $e');
      // Show a snackbar or alert if maps couldn't be launched
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
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
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar with back button and title
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withAlpha(128),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Contact Us',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Empty container for symmetry
                      Container(width: 40),
                    ],
                  ),
                ),

                // Professional circular image with glass effect border
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'lib/assets/OIP.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Mint Auto Care title
                const Text(
                  'Mint Auto Care Pvt. Ltd.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                // Slogan or tagline
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Your Trusted Partner for All Vehicle Care Needs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                // Contact information cards
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // Call Us section
                          _buildContactSectionTitle('Call Us'),
                          const SizedBox(height: 15),
                          _buildCallCard(
                            title: 'Customer Support',
                            phoneNumber: '076 6734993', // Your actual phone number
                            iconData: Icons.headset_mic,
                            onTap: () => _makePhoneCall('0766734993'),
                          ),
                          const SizedBox(height: 15),
                          _buildCallCard(
                            title: 'Service Center',
                            phoneNumber: '074 0326964', // Your actual phone number
                            iconData: Icons.car_repair,
                            onTap: () => _makePhoneCall('0766734993'),
                          ),

                          const SizedBox(height: 30),

                          // Email Us section
                          _buildContactSectionTitle('Email Us'),
                          const SizedBox(height: 15),
                          _buildInfoCard(
                            title: 'General Inquiries',
                            subtitle: 'info@sachir.lk',
                            iconData: Icons.email,
                            onTap: _launchEmail,
                          ),

                          const SizedBox(height: 30),

                          // Visit Us section
                          _buildContactSectionTitle('Visit Us'),
                          const SizedBox(height: 15),
                          _buildInfoCard(
                            title: 'Main Office',
                            subtitle: '572, Kandy Road, Pattiya Junction, Peliyadoda, Keleniya',
                            iconData: Icons.location_on,
                            onTap: _openMap,
                          ),

                          const SizedBox(height: 30),

                          // Operating hours section
                          _buildContactSectionTitle('Operating Hours'),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildHoursRow('Monday - Friday', '7:30 AM - 6:00 PM'),
                                const Divider(height: 20),
                                _buildHoursRow('Saturday', '7:30 AM - 8:00 PM'),
                                const Divider(height: 20),
                                _buildHoursRow('Sunday', '7:00 AM - 4:00 PM'),
                                const Divider(height: 20),
                                _buildHoursRow('Poya days', 'Close'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Social media section
                          _buildContactSectionTitle('Follow Us'),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Facebook button
                              InkWell(
                                onTap: () {
                                  // Handle facebook
                                },
                                child: Image.asset(
                                  'lib/assets/f_logo_RGB-Blue_1024.png',
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.g_mobiledata, size: 40, color: Colors.red);
                                  },
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Google button
                              InkWell(
                                onTap: () {
                                  // Handle Google
                                },
                                child: Image.asset(
                                  'lib/assets/google-icon.png',
                                  width: 45,
                                  height: 45,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.g_mobiledata, size: 40, color: Colors.red);
                                  },
                                ),
                              ),

                              const SizedBox(width: 5),

                              // Instagram button
                              InkWell(
                                onTap: () {
                                  // Handle Instagram
                                },
                                child: Image.asset(
                                  'lib/assets/insta.jpeg',
                                  width: 45,
                                  height: 45,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.g_mobiledata, size: 40, color: Colors.red);
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Divider
                          const Divider(),

                          const SizedBox(height: 20),

                          // Call to action
                          Center(
                            child: SizedBox(
                              width: 220,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () => _makePhoneCall('0766734993'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF05B64F),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                icon: const Icon(Icons.call, size: 24),
                                label: const Text(
                                  'Call Us Now',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF00B2CA),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF004D5B),
          ),
        ),
      ],
    );
  }

  Widget _buildCallCard({
    required String title,
    required String phoneNumber,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0099B8),
              Color(0xFF004D5B),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                iconData,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.call,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF00B2CA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                iconData,
                color: const Color(0xFF00B2CA),
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D5B),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF004D5B),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursRow(String day, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF004D5B),
          ),
        ),
        Text(
          hours,
          style: TextStyle(
            fontSize: 14,
            color: hours == 'Close' ? Colors.red : Colors.black87,
            fontWeight: hours == 'Close' ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}