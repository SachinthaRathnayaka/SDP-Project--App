import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/Signup.dart';
import 'package:sachir_vehicle_care/Pages/ForgetPassword.dart';
import 'package:sachir_vehicle_care/Pages/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top image with overlay and logo
            Stack(
              alignment: Alignment.center,
              children: [
                // Background mechanic image with gradient overlay
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [

                      // Background image
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/assets/Log_In_bg.jpg'),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              // Fallback if image fails to load
                              return;
                            },
                          ),
                          borderRadius: const BorderRadius.only(
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
                                Color(0xFFFFFFFF), // or match your app theme color
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                // SachiR Vehicle Care Logo
                Positioned(
                  top: 20,
                  right: -130,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/SachiR_Vehicle_Care.png',
                        width: 400,
                        height: 200,
                        color: Colors.white,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text(
                            'SachiR Vehicle Care',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // "Log In" text overlay at bottom
                const Positioned(
                  bottom: 05,
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 44,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // "Beyond the Expectation..." text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Beyond the Expectation...',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Username field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Username',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter username',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Password field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Forgot Password
            Padding(
              padding: const EdgeInsets.only(right: 30, top: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                      );
                    }
                  },
                  child: const Text(
                    'Forgot Password ?',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Login Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BCD4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 1,
              ),
            ),

            const SizedBox(height: 10),

            // Social login section
            const Text('or log in with'),

            const SizedBox(height: 15),

            // Social login buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google button
                InkWell(
                  onTap: () {
                    // Handle Google login
                  },
                  child: Image.asset(
                    'lib/assets/google-icon.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.g_mobiledata, size: 40, color: Colors.red);
                    },
                  ),
                ),
                const SizedBox(width: 40),
                // Facebook button
                InkWell(
                  onTap: () {
                    // Handle Facebook login
                  },
                  child: Image.asset(
                    'lib/assets/f_logo_RGB-Blue_1024.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.facebook, size: 40, color: Colors.blue);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Sign up text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Are you a new member? '),
                GestureDetector(

                  // Hit on "Sign Up" login screen navigate to the Signup screen
                  onTap: () {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    }
                  },

                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF00BCD4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}