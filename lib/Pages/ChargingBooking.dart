import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sachir_vehicle_care/Pages/VehicleChargingMain.dart';

class VehicleChargingBookingScreen extends StatefulWidget {
  const VehicleChargingBookingScreen({Key? key}) : super(key: key);

  @override
  State<VehicleChargingBookingScreen> createState() => _VehicleChargingBookingScreenState();
}

class _VehicleChargingBookingScreenState extends State<VehicleChargingBookingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Station location selection
  String? _selectedStation;

  DateTime? _selectedDate;

  // List of charging stations in Sri Lanka
  final List<String> _chargingStations = [
    'ChargeNET - Trace Expert City, Maradana',
    'EVPOINT - Colombo City Centre',
    'Lanka Filling Station - Negombo Road',
    'CPC Filling Station - High-level Road',
    'ChargeNET - SLNP Filling Station',
    'R&R Service Center - Kandy Road',
    'GoEV Station - Liberty Plaza',
    'EVPOINT - Cinnamon Grand',
    'ChargeNET - Crescat Boulevard',
    'EVPOINT - One Galle Face Mall',
    'ChargeNET - Keells Super',
    'Lanka IOC - Pelawatte',
  ];

  // ScrollController to manage the form's scrolling
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _vehicleNumberController.dispose();
    _vehicleModelController.dispose();
    _dateController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00B2CA), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Color(0xFF004D5B), // body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Form validation
  bool _validateForm() {
    if (_nameController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _vehicleNumberController.text.isEmpty ||
        _vehicleModelController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _selectedStation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Color(0xFFB12218),
        ),
      );
      return false;
    }
    return true;
  }

  // Booking confirmation dialog
  void _showBookingConfirmation() {
    // Show loading indicator first
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00B2CA),
          ),
        );
      },
    );

    // Simulate API call or booking process with a delay
    Future.delayed(const Duration(seconds: 1), () {
      // Dismiss loading dialog
      Navigator.of(context).pop();

      // Show success overlay
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00B2CA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Charging Booking Confirmed!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D5B),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'We will contact you shortly to confirm your charging appointment.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const VehicleChargingMainScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00B2CA),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text("Done"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen height to calculate form height
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = 200.0; // Height of the static header
    final safeAreaPadding = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;

    // Calculate form height (subtract header height, safe area padding, and add extra padding)
    final formHeight = screenHeight - headerHeight - safeAreaPadding;

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
              // Fixed header with background image, back button, and title
              Stack(
                children: [
                  // Background image with gradient overlay
                  Container(
                    height: headerHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('lib/assets/FogetPassword.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            const Color(0xFF066B7E).withOpacity(0.9),
                          ],
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title text
                              const Text(
                                'Book your time...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // SachiR Vehicle Care Logo
                  Positioned(
                    top: 0,
                    right: -130,
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/assets/SachiR_Vehicle_Care.png',
                          width: 400,
                          height: 200,
                          color: Colors.white,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),

                  // Back button
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withAlpha(128),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ],
              ),

              // Scrollable form area
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF004D5B),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Vehicle owner name
                            const Text(
                              'Vehicle owner name',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _nameController,
                              hintText: 'Enter your name',
                            ),

                            const SizedBox(height: 16),

                            // Contact number
                            const Text(
                              'Contact number',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _contactController,
                              hintText: '07x xxxxxxx',
                              keyboardType: TextInputType.phone,
                            ),

                            const SizedBox(height: 16),

                            // Vehicle number
                            const Text(
                              'Vehicle number',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _vehicleNumberController,
                              hintText: 'Ex:- CBB 2017',
                            ),

                            const SizedBox(height: 16),

                            // Vehicle brand/model
                            const Text(
                              'Vehicle brand/model',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _vehicleModelController,
                              hintText: 'Ex: Toyota Aqua',
                            ),

                            const SizedBox(height: 16),

                            // Date picker
                            const Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _dateController,
                                    hintText: 'DD/MM/YYYY',
                                    enabled: false,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: IconButton(
                                    onPressed: () => _selectDate(context),
                                    icon: const Icon(Icons.calendar_today, size: 22),
                                    color: const Color(0xFF004D5B),
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Charging Station Dropdown
                            const Text(
                              'Select Charging Station',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Theme(
                                // Use Theme to modify the dropdown button properties
                                data: Theme.of(context).copyWith(
                                  inputDecorationTheme: const InputDecorationTheme(
                                    // Reduce internal padding to prevent overflow
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true, // Ensures menu aligns with button
                                    child: DropdownButton<String>(
                                      isExpanded: true, // Make dropdown take full width of container
                                      hint: const Text(
                                        'Select a charging station',
                                        style: TextStyle(color: Colors.grey, fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      value: _selectedStation,
                                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: const TextStyle(color: Colors.black, fontSize: 14),
                                      dropdownColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedStation = newValue;
                                        });
                                      },
                                      items: _chargingStations
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Book button
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_validateForm()) {
                                      _showBookingConfirmation();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00B2CA),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Text(
                                    'Book',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}