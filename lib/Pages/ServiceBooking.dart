import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sachir_vehicle_care/Pages/VehicleCleaningMain.dart';

class ServiceBookingScreen extends StatefulWidget {
  const ServiceBookingScreen({Key? key}) : super(key: key);

  @override
  State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedService;
  DateTime? _selectedDate;

  final List<String> _serviceCategories = [
    'Body wash',
    'Full cleaning',
    'Under body cleaning',
    'Interior cleaning',
    'Engine Bay Cleaning',
    'Head Light Polishing',
    'Body Waxing',
    'Body Protect Sticker',
    'NANO Coating',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _vehicleNumberController.dispose();
    _vehicleModelController.dispose();
    _dateController.dispose();
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

  // Add validation method
  bool _validateForm() {
    // Add your validation logic here
    if (_selectedService == null ||
        _nameController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _vehicleNumberController.text.isEmpty ||
        _vehicleModelController.text.isEmpty ||
        _dateController.text.isEmpty) {

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  // Add confirmation dialog method with fixed navigation
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
                        'Booking Confirmed!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D5B),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'We will contact you shortly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
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

      // Auto dismiss after 2.5 seconds
      Future.delayed(const Duration(milliseconds: 2500), () {
        // Dismiss confirmation dialog
        Navigator.of(context).pop();

        // Use a simpler navigation method that won't cause history issues
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const VehicleCleaningScreen()),
        );
      });
    });
  }

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
          child: Stack(
            children: [
              // Back button - fixed position
              Positioned(
                top: 16,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withAlpha(128), // Fixed deprecated withOpacity
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Column(
                  children: [
                    // Book your time heading
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Book your time',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Booking form
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00505E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Service selection
                              const Text(
                                'Select the service category',
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
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    border: InputBorder.none,
                                    hintText: 'Select your service',
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                  value: _selectedService,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: _serviceCategories.map((String category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(category, style: const TextStyle(fontSize: 14)),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedService = newValue;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 12),

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

                              const SizedBox(height: 12),

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
                                hintText: 'Enter your contact',
                                keyboardType: TextInputType.phone,
                              ),

                              const SizedBox(height: 12),

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
                                hintText: 'Ex:- CBE 2018',
                              ),

                              const SizedBox(height: 12),

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

                              const SizedBox(height: 12),

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
                                  const SizedBox(width: 15),
                                  Container(
                                    height: 50, // Increased height
                                    width: 50, // Made it square
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

                              const SizedBox(height: 30), // Add fixed spacing instead of Spacer

                              Center(
                                child: SizedBox(
                                  width: 200, // Reduced from full width to 150
                                  height: 50,
                                  child: ElevatedButton(
                                    // CHANGED: Modified the onPressed callback
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
                                        borderRadius: BorderRadius.circular(30),
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

                    const SizedBox(height: 40),
                  ],
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
      height: 50, // Increased from 40 to 50
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), // Increased vertical padding
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}