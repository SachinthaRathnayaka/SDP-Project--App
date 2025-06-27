import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/HomeMenu.dart';
import 'package:sachir_vehicle_care/Pages/VehicleCleaningMain.dart';
import 'package:sachir_vehicle_care/Pages/VehicleRepairMain.dart';
import 'package:sachir_vehicle_care/Pages/VehicleModification.dart';
import 'package:sachir_vehicle_care/Pages/VehicleChargingMain.dart';
import 'package:sachir_vehicle_care/Pages/VehicleCreerServiceMain.dart';
import 'package:sachir_vehicle_care/Pages/Profile.dart';
import 'package:sachir_vehicle_care/Pages/MyBookings.dart';
import 'package:sachir_vehicle_care/Pages/MyPayments.dart';
import 'package:sachir_vehicle_care/Pages/Notifications.dart';
import 'package:sachir_vehicle_care/Pages/VehicleProfile.dart';
import 'package:sachir_vehicle_care/Pages/ChatbotScreen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Controller for the page view
  final PageController _pageController = PageController(
    viewportFraction: 0.85, // Show a bit of the next card
    initialPage: 0,
  );

  // Animation controller for background effects
  late AnimationController _animationController;

  // Current page index
  int _currentPage = 0;

  // Auto-scroll timer
  Timer? _autoScrollTimer;

  // Flag to show all services or slideshow
  bool _showAllServices = false;

  // List of sample vehicles for demo
  List<VehicleProfileData> _userVehicles = [];

  // Service card data
  final List<ServiceCardData> _serviceCards = [
    ServiceCardData(
      title: 'Vehicle Cleaning',
      image: 'lib/assets/Vehicle_Clean_BG.jpg',
      routeBuilder: (context) => const VehicleCleaningScreen(),
    ),
    ServiceCardData(
      title: 'Vehicle Repair',
      image: 'lib/assets/Vehicle_Repair_BG.jpg',
      routeBuilder: (context) => const VehicleRepairMainScreen(),
    ),
    ServiceCardData(
      title: 'Vehicle Modification',
      image: 'lib/assets/Vehicle_Modi_BG.jpg',
      routeBuilder: (context) => const VehicleModificationsScreen(),
    ),
    ServiceCardData(
      title: 'Vehicle Charging',
      image: 'lib/assets/Vehicle_Charge_BG.jpg',
      routeBuilder: (context) => const VehicleChargingMainScreen(),
    ),
    ServiceCardData(
      title: 'Vehicle Carrier Service',
      image: 'lib/assets/Vehicle_Career_BG.jpg',
      routeBuilder: (context) => const VehicleCarrierServiceScreen(),
    ),
  ];

  // Scroll controller for the main scroll view
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Start auto-scroll timer
    _startAutoScroll();

    // Listen to page changes
    _pageController.addListener(_onPageChange);

    // Load demo vehicles
    _loadDemoVehicles();
  }

  // Load sample vehicles for demo
  void _loadDemoVehicles() {
    setState(() {
      _userVehicles = [
        VehicleProfileData(
          id: '1',
          brand: 'Toyota',
          model: 'Corolla',
          year: '2020',
          registrationNumber: 'ABC-1234',
          serviceRecords: 2,
        ),
        VehicleProfileData(
          id: '2',
          brand: 'Honda',
          model: 'Civic',
          year: '2022',
          registrationNumber: 'XYZ-5678',
          serviceRecords: 1,
        ),
      ];
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChange);
    _pageController.dispose();
    _animationController.dispose();
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onPageChange() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  void _startAutoScroll() {
    // Only start auto-scroll if not showing all services
    if (!_showAllServices) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_currentPage < _serviceCards.length - 1) {
          _pageController.animateToPage(
            _currentPage + 1,
            duration: const Duration(milliseconds: 3000),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 3000),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _toggleServicesView() {
    setState(() {
      _showAllServices = !_showAllServices;
      if (_showAllServices) {
        _stopAutoScroll();
      } else {
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0099B1), // Teal background color
      body: Stack(
        children: [
          SafeArea(
            top: true, // Remove top padding to reduce space at the top
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Header section with background image
                  _buildHeaderSection(context),

                  const SizedBox(height: 15),

                  // Featured services section title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Our Services',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Services display (either slideshow or grid)
                  _showAllServices
                      ? _buildServiceGrid()
                      : _buildServiceSlideshow(),

                  // Indicator dots for current page (only show in slideshow mode)
                  if (!_showAllServices) ...[
                    const SizedBox(height: 5),
                    _buildPageIndicator(),
                  ],

                  // Increased space between slideshow and manage vehicle button
                  const SizedBox(height: 40),

                  // Vehicle Profile Button (New)
                  _buildVehicleProfileButton(),

                  // Increased space between button and vehicles section
                  const SizedBox(height: 40),

                  // User Vehicles Section (New)
                  if (_userVehicles.isNotEmpty) _buildUserVehiclesSection(),

                  const SizedBox(height: 100), // Add space at the bottom for navigation bar
                ],
              ),
            ),
          ),

          // Fixed position menu icon
          Positioned(
            top: 65,
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashColor: const Color(0xFF0099B1).withOpacity(0.3),
                  onTap: () {
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.menu,
                      color: Color(0xFF002A32),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Chatbot button
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(35),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                    );
                  },
                  child: const Center(
                    child: Icon(
                      Icons.smart_toy,
                      color: Color(0xFF004D5B),
                      size: 38,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.28,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Background image with animated overlay effect
          AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white.withOpacity(0.7 + 0.3 * _animationController.value),
                        Colors.white.withOpacity(0.7 - 0.3 * _animationController.value),
                      ],
                      stops: const [0.0, 1.0],
                    ).createShader(bounds);
                  },
                  child: Container(
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
                );
              }
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
                    Color(0xFF0099B1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xFF0099B1),
                  ],
                ),
              ),
            ),
          ),

          // SachiR Vehicle Care Logo
          Positioned(
            top: 60,
            right: -130,
            child: Column(
              children: [
                Image.asset(
                  'lib/assets/SachiR_Vehicle_Care.png',
                  width: 400,
                  height: 180,
                ),
              ],
            ),
          ),

          // Tagline text with enhanced style
          Positioned(
            bottom: 0,
            left: 30,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color(0xFFE0F7FA)],
                ).createShader(bounds);
              },
              child: const Text(
                'Get your services easily...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                  shadows: [
                    Shadow(
                      color: Color(0xFF004D5B),
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSlideshow() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _serviceCards.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          // Calculate scale factor for cards
          double scale = _currentPage == index ? 1.0 : 0.9;

          return TweenAnimationBuilder(
            tween: Tween<double>(begin: scale, end: scale),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutQuint,
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: _buildServiceCard(
              _serviceCards[index].title,
              _serviceCards[index].image,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: _serviceCards[index].routeBuilder,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceGrid() {
    // Calculate the height needed to show all cards without scrolling
    // We're displaying 2 cards per row, so with 5 cards total we need 3 rows
    // (including partial row)
    return Container(
      height: 330, // Fixed height to accommodate all cards without scrolling
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _serviceCards.length,
        itemBuilder: (context, index) {
          return _buildServiceCard(
            _serviceCards[index].title,
            _serviceCards[index].image,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: _serviceCards[index].routeBuilder,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _serviceCards.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 12 : 8,
          height: _currentPage == index ? 12 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  // New vehicle profile button
  Widget _buildVehicleProfileButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VehicleProfileScreen())
          );
          // Refresh the vehicle list (in a real app, you'd fetch updated data here)
          _loadDemoVehicles();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF004D5B),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.directions_car, size: 26),
            SizedBox(width: 10),
            Text(
              'Manage Vehicle Profiles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // New section to display user vehicles on the home screen
  Widget _buildUserVehiclesSection() {
    return Column(
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Your Vehicles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Vehicle cards horizontal list
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _userVehicles.length,
            itemBuilder: (context, index) {
              final vehicle = _userVehicles[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Vehicle details
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Car icon with circular background
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0099B1).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              color: Color(0xFF0099B1),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Vehicle info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${vehicle.brand} ${vehicle.model}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Year: ${vehicle.year}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Reg: ${vehicle.registrationNumber}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${vehicle.serviceRecords} service records',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0099B1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Make the whole card tappable
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VehicleProfileScreen(
                                  initialVehicleId: vehicle.id,
                                ),
                              ),
                            );
                            // Refresh vehicle list when returning
                            _loadDemoVehicles();
                          },
                          splashColor: const Color(0xFF0099B1).withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(String title, String image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: _showAllServices
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                image,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Gradient overlay for better text readability
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),

            // Title and icon
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: _showAllServices ? 16 : 22, // Adjust size based on view
                          shadows: const [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF002A32),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.edit_calendar_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
              );
            },
          ),

          _buildNavItem(
            icon: Icons.credit_card,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyPaymentsScreen()),
              );
            },
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
              radius: 35,
              backgroundColor: Colors.white,
              child: Image.asset(
                'lib/assets/SachiR_Vehicle_Care.png',
                width: 160,
                height: 160,
              ),
            ),
          ),

          _buildNavItem(
            icon: Icons.notifications,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),

          _buildNavItem(
            icon: Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        splashColor: Colors.white.withOpacity(0.3),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

// Data model for service cards
class ServiceCardData {
  final String title;
  final String image;
  final WidgetBuilder routeBuilder;

  ServiceCardData({
    required this.title,
    required this.image,
    required this.routeBuilder,
  });
}

// Simple data class for vehicle information on home screen
class VehicleProfileData {
  final String id;
  final String brand;
  final String model;
  final String year;
  final String registrationNumber;
  final int serviceRecords;

  VehicleProfileData({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.serviceRecords,
  });
}