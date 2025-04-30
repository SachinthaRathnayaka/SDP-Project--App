import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sachir_vehicle_care/Pages/ResetPassword.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Controllers for the 4-digit verification code
  final TextEditingController _digit1Controller = TextEditingController();
  final TextEditingController _digit2Controller = TextEditingController();
  final TextEditingController _digit3Controller = TextEditingController();
  final TextEditingController _digit4Controller = TextEditingController();

  // Focus nodes for verification code fields
  final FocusNode _digit1FocusNode = FocusNode();
  final FocusNode _digit2FocusNode = FocusNode();
  final FocusNode _digit3FocusNode = FocusNode();
  final FocusNode _digit4FocusNode = FocusNode();

  bool _codeSent = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _digit1Controller.dispose();
    _digit2Controller.dispose();
    _digit3Controller.dispose();
    _digit4Controller.dispose();
    _digit1FocusNode.dispose();
    _digit2FocusNode.dispose();
    _digit3FocusNode.dispose();
    _digit4FocusNode.dispose();
    super.dispose();
  }

  void _sendVerificationCode() {
    setState(() {
      _codeSent = true;
    });
    // In a real app, you would send the verification code to the user here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image with overlay and logo
            Stack(
              alignment: Alignment.center,
              children: [

                // Background image
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/FogetPassword.jpg'),
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
                          Color(0xFFFFFFFF), // or match your app theme color
                        ],
                      ),
                    ),
                  ),
                ),

                // SachiR Vehicle Care Logo
                Positioned(
                  top: 20,
                  right: -130,
                  child: Column(
                    children: [
                      Image.asset(
                        'lib/assets/SachiR_Vehicle_Care.png',
                        width: 400,
                        height: 200,
                        color:Colors.white,
                      ),
                    ],
                  ),
                ),

                // "Forgot Password" text overlay at bottom
                const Positioned(
                  bottom: 15,
                  child: Text(
                    'Forget Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // "Did you forget your password..?" text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Did you forget your password..?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
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
                      fillColor: Colors.grey[300],
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

            const SizedBox(height: 15),

            // Phone Number field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Enter your phone number',
                            fillColor: Colors.grey[300],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _sendVerificationCode,
                        child: const Text(
                          'Send a code',
                          style: TextStyle(
                            color: Color(0xFF00BCD4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Verification code section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter the code',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCodeDigitField(_digit1Controller, _digit1FocusNode, _digit2FocusNode),
                      const SizedBox(width: 10),
                      _buildCodeDigitField(_digit2Controller, _digit2FocusNode, _digit3FocusNode),
                      const SizedBox(width: 10),
                      _buildCodeDigitField(_digit3Controller, _digit3FocusNode, _digit4FocusNode),
                      const SizedBox(width: 10),
                      _buildCodeDigitField(_digit4Controller, _digit4FocusNode, null),
                    ],
                  ),

                ],
              ),
            ),

            const SizedBox(height: 40),

            // Reset Password Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BCD4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  minimumSize: const Size(250, 50),
                ),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Back to Login text
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Back to '),
                  GestureDetector(
                    onTap: () {
                      // Navigate to login screen
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Color(0xFF00BCD4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildCodeDigitField(
      TextEditingController controller,
      FocusNode focusNode,
      FocusNode? nextFocusNode,
      ) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            nextFocusNode.requestFocus();
          }
        },
      ),
    );
  }
}