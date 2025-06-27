import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:sachir_vehicle_care/Pages/ContactUs.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();

  // Parallax effect values
  double _headerHeight = 350;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
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

          // Scrollable content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar with logo animation
              SliverAppBar(
                expandedHeight: _headerHeight,
                floating: false,
                pinned: true,
                backgroundColor: _scrollOffset > 50
                    ? const Color(0xFF004D5B)
                    : Colors.transparent,
                elevation: _scrollOffset > 50 ? 4 : 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    _scrollOffset > 50 ? "About Us" : "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Animated background
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (_, child) {
                          return CustomPaint(
                            painter: AnimatedBackgroundPainter(
                              animation: _controller.value,
                            ),
                            child: child,
                          );
                        },
                      ),

                      // Logo and title with parallax effect
                      Positioned(
                        top: 100 - (_scrollOffset * 0.5).clamp(0, 100),
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            // Animated logo
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (_, __) {
                                return Transform.rotate(
                                  angle: math.sin(_controller.value * math.pi * 2) * 0.05,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.asset(
                                        'lib/assets/OIP.jpeg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // Title text
                            const Text(
                              "About Us",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
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

              // Content area
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Our Story section
                        _buildSectionTitle("Our Story"),
                        const SizedBox(height: 15),
                        _buildContentText(
                          "Founded in 2015, SachiR Vehicle Care began with a single location in Colombo and a passion for exceptional car care services. What started as a small team of automotive enthusiasts has grown into a respected company with multiple locations across Sri Lanka.",
                        ),
                        const SizedBox(height: 10),
                        _buildContentText(
                          "Our journey has been driven by a commitment to quality service, attention to detail, and customer satisfaction. We have continuously invested in training our team and upgrading our facilities to provide the best care for your vehicles.",
                        ),

                        const SizedBox(height: 30),

                        // Our Mission section
                        _buildSectionTitle("Our Mission"),
                        const SizedBox(height: 15),
                        _buildMissionCard(
                          icon: Icons.auto_awesome,
                          title: "Excellence",
                          description: "To provide exceptional vehicle care services that exceed customer expectations.",
                        ),
                        const SizedBox(height: 15),
                        _buildMissionCard(
                          icon: Icons.eco,
                          title: "Sustainability",
                          description: "To implement eco-friendly practices in all our operations and minimize environmental impact.",
                        ),
                        const SizedBox(height: 15),
                        _buildMissionCard(
                          icon: Icons.people,
                          title: "Community",
                          description: "To build lasting relationships within our community through honest service and fair pricing.",
                        ),

                        const SizedBox(height: 30),

                        // Our Team section
                        _buildSectionTitle("Our Team"),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildTeamMember(
                                name: "Sachintha Rathnayaka",
                                position: "Founder & CEO",
                                imagePath: "lib/assets/Sachintha.jpg",
                              ),
                              _buildTeamMember(
                                name: "Amara Fernando",
                                position: "Head Technician",
                                imagePath: "lib/assets/placeholder_female.png",
                              ),
                              _buildTeamMember(
                                name: "Dinesh Perera",
                                position: "Customer Relations",
                                imagePath: "lib/assets/placeholder_male.png",
                              ),
                              _buildTeamMember(
                                name: "Lakshmi Silva",
                                position: "Operations Manager",
                                imagePath: "lib/assets/placeholder_female.png",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Our Services
                        _buildSectionTitle("Our Services"),
                        const SizedBox(height: 15),

                        // Original services
                        _buildServiceItem(
                          icon: Icons.car_repair,
                          title: "Vehicle Repair",
                          description: "Full-service vehicle repair and maintenance with state-of-the-art equipment.",
                        ),
                        _buildServiceItem(
                          icon: Icons.cleaning_services,
                          title: "Vehicle Cleaning",
                          description: "Comprehensive interior and exterior cleaning and detailing services.",
                        ),

                        // Added services
                        _buildServiceItem(
                          icon: Icons.tune,
                          title: "Vehicle Modifications",
                          description: "Custom vehicle modifications including performance upgrades, body kits, and interior customizations.",
                        ),
                        _buildServiceItem(
                          icon: Icons.battery_charging_full,
                          title: "Vehicle Charging Service",
                          description: "EV charging stations and battery maintenance services for electric and hybrid vehicles.",
                        ),
                        _buildServiceItem(
                          icon: Icons.local_shipping,
                          title: "Vehicle Carrier Service",
                          description: "Safe and secure transportation of vehicles to any destination with our specialized carrier fleet.",
                        ),
                        _buildServiceItem(
                          icon: Icons.battery_charging_full,
                          title: "Battery Services",
                          description: "Battery testing, replacement, and recycling services for all vehicle types.",
                        ),
                        _buildServiceItem(
                          icon: Icons.tire_repair,
                          title: "Tire Services",
                          description: "Tire rotation, balancing, and replacement with top brands.",
                        ),

                        const SizedBox(height: 30),

                        // Contact Info section
                        _buildSectionTitle("Visit Us"),
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
                              // Office location
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF00B2CA),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Main Office",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF004D5B),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "572, Kandy Road, Pattiya Junction, Peliyadoda, Keleniya",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              // Contact info
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.phone,
                                          color: Color(0xFF00B2CA),
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "076 6734993",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.email,
                                          color: Color(0xFF00B2CA),
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "info@sachir.lk",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              // Operating hours
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Color(0xFF00B2CA),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Operating Hours",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF004D5B),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Mon - Fri: 7:30 AM - 6:00 PM\nSat: 7:30 AM - 8:00 PM\nSun: 7.00 AM - 4.00 PM\nPoya days: Close",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Get in touch section
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                "Reach out to us for any inquiries",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004D5B),
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                width: 200,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ContactUsScreen ()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00B2CA),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Text(
                                    "Contact Us",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Footer
                        const Center(
                          child: Text(
                            "© 2025 SachiR Vehicle Care. All rights reserved.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
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
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 25,
            decoration: BoxDecoration(
              color: const Color(0xFF00B2CA),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D5B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  Widget _buildMissionCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
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
              icon,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String position,
    required String imagePath,
  }) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          // Profile picture with animated border
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, double value, child) {
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: const [
                      Color(0xFF00B2CA),
                      Color(0xFF004D5B),
                      Color(0xFF00B2CA),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    startAngle: 0.0,
                    endAngle: math.pi * 2 * value,
                    transform: GradientRotation(math.pi * 2 * (1 - value)),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: child,
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                imagePath,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D5B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            position,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00B2CA),
              size: 28,
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
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom animated background painter
class AnimatedBackgroundPainter extends CustomPainter {
  final double animation;

  AnimatedBackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw animated bubbles/circles
    for (int i = 0; i < 15; i++) {
      final radius = (20 + i * 4) * math.sin((animation + i * 0.1) * math.pi);
      final offset = Offset(
        (size.width * 0.1) + math.sin((animation + i * 0.1) * math.pi * 2) * size.width * 0.4,
        (size.height * 0.5) + math.cos((animation + i * 0.1) * math.pi * 2) * size.height * 0.3,
      );

      canvas.drawCircle(offset, radius.abs(), paint);
    }

    // Draw wave pattern
    final path = Path();
    path.moveTo(0, size.height * 0.7);

    for (double x = 0; x < size.width; x++) {
      final y = size.height * 0.7 + math.sin((x / size.width * 4 * math.pi) + (animation * math.pi * 2)) * 20;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(AnimatedBackgroundPainter oldDelegate) => true;
}