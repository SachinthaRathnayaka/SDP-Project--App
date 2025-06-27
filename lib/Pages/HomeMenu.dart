import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:sachir_vehicle_care/Pages/Login.dart';
import 'package:sachir_vehicle_care/Pages/Profile.dart';
import 'package:sachir_vehicle_care/Pages/AboutUs.dart';
import 'package:sachir_vehicle_care/Pages/ContactUs.dart';
import 'package:sachir_vehicle_care/Pages/MyBookings.dart';
import 'package:sachir_vehicle_care/Pages/MyPayments.dart';
import 'package:sachir_vehicle_care/Pages/Notifications.dart';

class HomeMenuScreen extends StatefulWidget {
  const HomeMenuScreen({Key? key}) : super(key: key);

  @override
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> with SingleTickerProviderStateMixin {
  // Animation controller for menu items
  late AnimationController _animationController;

  // List of menu items
  final List<MenuItemData> _menuItems = [
    MenuItemData(
      icon: Icons.person,
      title: 'Profile',
      routeBuilder: (context) => const ProfileScreen(),
    ),
    MenuItemData(
      icon: Icons.notifications,
      title: 'Notifications',
      routeBuilder: (context) => const NotificationsScreen(),
    ),
    MenuItemData(
      icon: Icons.edit_calendar_rounded,
      title: 'My Bookings',
      routeBuilder: (context) => const MyBookingsScreen(),
    ),
    MenuItemData(
      icon: Icons.credit_card,
      title: 'Payments',
      routeBuilder: (context) => const MyPaymentsScreen(),
    ),
    MenuItemData(
      icon: Icons.phone,
      title: 'Contact us',
      routeBuilder: (context) => const ContactUsScreen(),
    ),
    MenuItemData(
      icon: Icons.info,
      title: 'About us',
      routeBuilder: (context) => const AboutUsScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // For immersive experience
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Main content area with gradient background
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF003D47), // Darker teal at top
                  Color(0xFF0299AE), // Lighter teal at bottom
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button and profile picture container
                  _buildTopSection(context),

                  // Menu items
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Menu items with staggered animation
                          ..._buildAnimatedMenuItems(),

                          // Vehicle service illustration
                          _buildIllustration(),

                          // Log out button
                          _buildLogoutButton(context),

                          const Divider(color: Color(0xFFF0F0F0)),

                          // Company info at bottom
                          _buildCompanyInfo(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Semi-transparent overlay with blur effect
          Positioned(
            left: MediaQuery.of(context).size.width * 0.85,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Tap to close',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0, bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button with gradient effect
          Transform.translate(
            offset: const Offset(0, 18),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF0F0F0), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.cyan.withOpacity(0.3),
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          // Profile image with shadow and border
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => _FullScreenImageView(
                    imagePath: 'lib/assets/Sachintha.jpg',
                  ),
                ),
              );
            },
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - _animationController.value)),
                  child: Opacity(
                    opacity: _animationController.value,
                    child: child,
                  ),
                );
              },
              child: Hero(
                tag: 'profileImage',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF00DAFF),
                          Colors.white,
                          Color(0xFF00D1FD),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage('lib/assets/Sachintha.jpg'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnimatedMenuItems() {
    return List.generate(_menuItems.length, (index) {
      final menuItem = _menuItems[index];

      // Calculate delay based on index for staggered animation
      final delay = index * 0.2;

      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // Staggered animation values
          final start = delay;
          final end = math.min(1.0, start + 0.4);

          final curvedValue = Interval(
            start,
            end,
            curve: Curves.easeOutQuint,
          ).transform(_animationController.value);

          return Transform.translate(
            offset: Offset(
              -100 * (1 - curvedValue),
              0,
            ),
            child: Opacity(
              opacity: curvedValue,
              child: child,
            ),
          );
        },
        child: _buildMenuItem(
          icon: menuItem.icon,
          title: menuItem.title,
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    menuItem.routeBuilder(context),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.easeInOutQuint;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.cyan.withOpacity(0.3),
        highlightColor: Colors.cyan.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0),
          child: Row(
            children: [
              // Icon with gradient and shadow
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4DC9C9),
                      const Color(0xFF4DC9C9).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            // Fade and scale animation
            final scale = 0.5 + (0.5 * _animationController.value);
            final opacity = _animationController.value;

            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // Bounce animation
          final bounceAnimation = CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.6, 1.0, curve: Curves.elasticOut),
          ).value;

          return Transform.scale(
            scale: bounceAnimation,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCD0D0D).withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
            gradient: const LinearGradient(
              colors: [Color(0xFFCD0D0D), Color(0xFFE83232)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              // Haptic feedback for button press
              HapticFeedback.mediumImpact();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              minimumSize: const Size(double.infinity, 50),
              padding: EdgeInsets.zero,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.logout, size: 26),
                SizedBox(width: 12),
                Text('Log out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animation = CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.7, 1.0, curve: Curves.easeOut),
        ).value;

        return Opacity(
          opacity: animation,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Company logo with glass effect
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
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                      color: Color(0xFF000000),
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
    );
  }
}

// Full screen image viewer class with enhanced UI
class _FullScreenImageView extends StatelessWidget {
  final String imagePath;

  const _FullScreenImageView({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile Picture',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Image viewer with interaction
          Center(
            child: Hero(
              tag: 'profileImage',
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Hint text at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: Text(
                'Pinch to zoom • Double tap to reset',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data model for menu items
class MenuItemData {
  final IconData icon;
  final String title;
  final WidgetBuilder routeBuilder;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.routeBuilder,
  });
}