import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/HomeScreen.dart';
import 'package:sachir_vehicle_care/Pages/CareerServiceStatus.dart';

void navigateToStatusScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VehicleCarrierServiceStatusScreen(
        bookingDetails: BookingDetails(
          vehicleBrand: 'Suzuki',
          vehicleModel: 'Celerio',
          vehicleType: 'Car',
          vehicleImage: 'lib/assets/Celerio.jpg',
          customerName: 'Sachintha Rathnayka',
          contactNumber: '076 6734993',
          vehicleNumber: 'CAR-2018',
          jobId: '68761616',
          bookingDate: '23/11/2024',
          amount: 4300.00,
        ),
      ),
    ),
  );
}

class VehicleCarrierServiceScreen extends StatefulWidget {
  const VehicleCarrierServiceScreen({Key? key}) : super(key: key);

  @override
  State<VehicleCarrierServiceScreen> createState() => _VehicleCarrierServiceScreenState();
}

class _VehicleCarrierServiceScreenState extends State<VehicleCarrierServiceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _pickLocationController = TextEditingController();
  final TextEditingController _dropLocationController = TextEditingController();

  String? _selectedVehicleType;
  String? _selectedVehicleBrand;
  String? _selectedVehicleModel;

  final List<String> _vehicleTypes = [
    'Car',
    'SUV',
    'Van',
    'Truck',
    'Motorcycle',
    'Bus',
  ];

  final Map<String, List<String>> _vehicleBrandsAndModels = {
    'Toyota': ['Corolla', 'Camry', 'RAV4', 'Prius', 'Land Cruiser', 'Hilux'],
    'Honda': ['Civic', 'Accord', 'CR-V', 'Fit', 'Pilot'],
    'Nissan': ['Altima', 'Sentra', 'Pathfinder', 'Rogue', 'X-Trail'],
    'Ford': ['Mustang', 'Focus', 'F-150', 'Ranger', 'Explorer'],
    'BMW': ['3 Series', '5 Series', 'X3', 'X5', '7 Series'],
    'Mercedes': ['C-Class', 'E-Class', 'S-Class', 'GLC', 'GLE'],
    'Audi': ['A3', 'A4', 'A6', 'Q3', 'Q5', 'Q7'],
    'Suzuki': ['Swift', 'Alto', 'Jimny', 'Vitara', 'Wagon R'],
  };

  List<String> get _vehicleBrands => _vehicleBrandsAndModels.keys.toList();

  List<String> get _vehicleModels {
    if (_selectedVehicleBrand == null) return [];
    return _vehicleBrandsAndModels[_selectedVehicleBrand] ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _vehicleNumberController.dispose();
    _pickLocationController.dispose();
    _dropLocationController.dispose();
    super.dispose();
  }

  // Form validation
  bool _validateForm() {
    if (_nameController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _selectedVehicleType == null ||
        _selectedVehicleBrand == null ||
        _selectedVehicleModel == null ||
        _vehicleNumberController.text.isEmpty ||
        _pickLocationController.text.isEmpty ||
        _dropLocationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  // Show confirmation dialog
  void _showConfirmationDialog() {
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
                      color: Colors.black.withAlpha(50),
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
                      'Request Submitted!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D5B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your carrier service request has been submitted. We will contact you shortly to confirm details.',
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
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Go back to previous screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B2CA),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('OK'),
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
  }

  // Method to open a location picker (this could be integrated with Google Maps)
  void _pickLocation(TextEditingController controller) {
    // In a real app, this would open a map or address selector
    // For now, we'll just show a simple location selection dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select a Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Current Location'),
              leading: const Icon(Icons.my_location),
              onTap: () {
                controller.text = 'Current Location (GPS)';
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Colombo City Center'),
              leading: const Icon(Icons.location_on),
              onTap: () {
                controller.text = 'Colombo City Center';
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Galle Face Green'),
              leading: const Icon(Icons.location_on),
              onTap: () {
                controller.text = 'Galle Face Green, Colombo';
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Kandy City'),
              leading: const Icon(Icons.location_on),
              onTap: () {
                controller.text = 'Kandy City Center';
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
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
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Center(
                          child: Text(
                            'Carrier Service',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Back button
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.5),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),


              Expanded(
                child: SingleChildScrollView(
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
                          // Form title
                          const Center(
                            child: Text(
                              'Enter the details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          // Divider
                          const Center(
                            child: SizedBox(
                              width: 150,
                              child: Divider(color: Colors.white, thickness: 1),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Customer name
                          const Text(
                            'Customer name',
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
                            'Your contact',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _contactController,
                            hintText: 'Enter your phone number',
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 16),

                          // Vehicle type dropdown
                          const Text(
                            'Vehicle type',
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
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                border: InputBorder.none,
                                hintText: 'Select vehicle type',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              value: _selectedVehicleType,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: _vehicleTypes.map((String type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type, style: const TextStyle(fontSize: 14)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedVehicleType = newValue;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Vehicle brand and model (side by side)
                          Row(
                            children: [
                              // Vehicle brand
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Vehicle brand',
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
                                      child: DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                          border: InputBorder.none,
                                          hintText: 'Select',
                                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                        ),
                                        value: _selectedVehicleBrand,
                                        isExpanded: true,
                                        icon: const Icon(Icons.keyboard_arrow_down),
                                        items: _vehicleBrands.map((String brand) {
                                          return DropdownMenuItem(
                                            value: brand,
                                            child: Text(brand, style: const TextStyle(fontSize: 14)),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedVehicleBrand = newValue;
                                            _selectedVehicleModel = null; // Reset model when brand changes
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              // Vehicle model
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Vehicle model',
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
                                      child: DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                          border: InputBorder.none,
                                          hintText: 'Select',
                                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                        ),
                                        value: _selectedVehicleModel,
                                        isExpanded: true,
                                        icon: const Icon(Icons.keyboard_arrow_down),
                                        items: _selectedVehicleBrand == null
                                            ? []
                                            : _vehicleModels.map((String model) {
                                          return DropdownMenuItem(
                                            value: model,
                                            child: Text(model, style: const TextStyle(fontSize: 14)),
                                          );
                                        }).toList(),
                                        onChanged: _selectedVehicleBrand == null
                                            ? null
                                            : (String? newValue) {
                                          setState(() {
                                            _selectedVehicleModel = newValue;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                            hintText: 'Ex: YP 2345',
                          ),

                          const SizedBox(height: 16),

                          // Pick location
                          const Text(
                            'Pick Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildTextFieldWithIcon(
                            controller: _pickLocationController,
                            hintText: 'Enter your location',
                            icon: Icons.place,
                            onIconPressed: () => _pickLocation(_pickLocationController),
                          ),

                          const SizedBox(height: 16),

                          // Drop location
                          const Text(
                            'Drop Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildTextFieldWithIcon(
                            controller: _dropLocationController,
                            hintText: 'Enter your destination',
                            icon: Icons.place,
                            onIconPressed: () => _pickLocation(_dropLocationController),
                          ),

                          const SizedBox(height: 30),

                          // Save button
                          Center(
                            child: SizedBox(
                              width: 200,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_validateForm()) {
                                    Navigator.pop(context); // Close dialog

                                    // Create a booking details object (in a real app, this would come from your backend)
                                    final bookingDetails = BookingDetails(
                                      vehicleBrand: 'Suzuki',
                                      vehicleModel: 'Celerio',
                                      vehicleType: 'Car',
                                      vehicleImage: 'lib/assets/Celerio.jpg',
                                      customerName: 'Sachintha Rathnayka',
                                      contactNumber: '076 6734993',
                                      vehicleNumber: 'CAR-2018',
                                      jobId: '68761616', // This might be generated on the server
                                      bookingDate: '23/11/2024',
                                      amount: 4300.00,
                                    );

                                    // Navigate to the status screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VehicleCarrierServiceStatusScreen(
                                          bookingDetails: bookingDetails,
                                        ),
                                      ),
                                    );
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
                                  'SAVE',
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

  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required VoidCallback onIconPressed,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
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
          ),
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: IconButton(
              icon: Icon(icon, color: const Color(0xFF004D5B)),
              onPressed: onIconPressed,
            ),
          ),
        ],
      ),
    );
  }
}