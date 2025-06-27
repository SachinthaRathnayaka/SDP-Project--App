import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ServiceRecord {
  final DateTime date;
  final String type;
  final String description;
  final double cost;
  final String bookingId;

  ServiceRecord({
    required this.date,
    required this.type,
    required this.description,
    required this.cost,
    this.bookingId = '',
  });
}

class Vehicle {
  final String id;
  final String brand;
  final String model;
  final String year;
  final String registrationNumber;
  final String imagePath;
  final List<ServiceRecord> serviceHistory;

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.imagePath,
    required this.serviceHistory,
  });
}

class VehicleProfileScreen extends StatefulWidget {
  final String? initialVehicleId;

  const VehicleProfileScreen({Key? key, this.initialVehicleId}) : super(key: key);

  @override
  State<VehicleProfileScreen> createState() => _VehicleProfileScreenState();
}

class _VehicleProfileScreenState extends State<VehicleProfileScreen> {
  // List to store vehicles
  final List<Vehicle> vehicles = [];

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Selected image file (kept private as it's not accessed externally)
  File? _selectedImage;

  // Non-private fields that need to be accessed by name
  String? selectedImagePath;
  String selectedBrand = 'Toyota';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> serviceFormKey = GlobalKey<FormState>();
  final List<String> vehicleBrands = [
    'Audi', 'BMW', 'Chevrolet', 'Ford', 'Honda',
    'Hyundai', 'Jaguar', 'Kia', 'Land Rover', 'Lexus',
    'Mazda', 'Mercedes-Benz', 'Mitsubishi', 'Nissan',
    'Subaru', 'Suzuki', 'Tesla', 'Toyota', 'Volkswagen', 'Volvo', 'Other'
  ];

  // Form controllers - made naming convention consistent
  // Controllers that need to be accessed outside this class (by name) don't have underscore
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController bookingIdController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController(); // Removed underscore
  final TextEditingController registrationController = TextEditingController(); // Removed underscore

  @override
  void initState() {
    super.initState();

    // Sort brands alphabetically, but keep "Other" at the end
    vehicleBrands.sort((a, b) {
      if (a == 'Other') return 1;
      if (b == 'Other') return -1;
      return a.compareTo(b);
    });

    _loadSampleVehicles();
  }

  @override
  void dispose() {
    typeController.dispose();
    descriptionController.dispose();
    costController.dispose();
    bookingIdController.dispose();
    modelController.dispose();
    yearController.dispose(); // Updated from _yearController
    registrationController.dispose(); // Updated from _registrationController
    super.dispose();
  }

  void _loadSampleVehicles() {
    setState(() {
      vehicles.add(
        Vehicle(
          id: '1',
          brand: 'Toyota',
          model: 'Corolla',
          year: '2020',
          registrationNumber: 'ABC-1234',
          imagePath: 'lib/assets/toyota_corolla.png',
          serviceHistory: [
            ServiceRecord(
              date: DateTime(2023, 5, 15),
              type: 'Oil Change',
              description: 'Regular maintenance - oil and filter change',
              cost: 8500,
              bookingId: 'BK12345',
            ),
            ServiceRecord(
              date: DateTime(2023, 11, 8),
              type: 'Brake Service',
              description: 'Front brake pads replacement',
              cost: 12000,
              bookingId: 'BK12789',
            ),
          ],
        ),
      );

      vehicles.add(
        Vehicle(
          id: '2',
          brand: 'Honda',
          model: 'Civic',
          year: '2022',
          registrationNumber: 'XYZ-5678',
          imagePath: 'lib/assets/honda_civic.png',
          serviceHistory: [
            ServiceRecord(
              date: DateTime(2024, 1, 20),
              type: 'Tire Replacement',
              description: 'Replaced all four tires',
              cost: 35000,
              bookingId: 'BK13456',
            ),
          ],
        ),
      );
    });
  }

  // Method to pick image (required by external code)
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        selectedImagePath = image.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(source == ImageSource.gallery
              ? 'Vehicle image selected from gallery'
              : 'Vehicle image captured from camera'),
          backgroundColor: const Color(0xFF0099B1),
        ),
      );
    }
  }

  // Helper methods that call the main _pickImage method
  Future<void> _pickImageFromGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImageFromCamera() async {
    await _pickImage(ImageSource.camera);
  }

  void _showAddVehicleDialog() {
    modelController.clear();
    yearController.clear(); // Updated from _yearController
    registrationController.clear(); // Updated from _registrationController
    selectedBrand = vehicleBrands[0];
    _selectedImage = null;
    selectedImagePath = null;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add New Vehicle',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D5B),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Vehicle image picker
                  GestureDetector(
                    onTap: () => _showImageSourceDialog(),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(
                        Icons.add_a_photo,
                        color: Color(0xFF0099B1),
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Brand dropdown
                  DropdownButtonFormField<String>(
                    value: selectedBrand,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Brand',
                      border: OutlineInputBorder(),
                    ),
                    items: vehicleBrands.map((brand) {
                      return DropdownMenuItem<String>(
                        value: brand,
                        child: Text(brand),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedBrand = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a brand';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Model field
                  TextFormField(
                    controller: modelController,
                    decoration: const InputDecoration(
                      labelText: 'Model',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the model';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Year field
                  TextFormField(
                    controller: yearController, // Updated from _yearController
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the year';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid year';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Registration number field
                  TextFormField(
                    controller: registrationController, // Updated from _registrationController
                    decoration: const InputDecoration(
                      labelText: 'Registration Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the registration number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _addVehicle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0099B1),
                        ),
                        child: const Text('Add Vehicle'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle?'),
        content: Text(
          'Are you sure you want to delete ${vehicle.brand} ${vehicle.model}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                vehicles.remove(vehicle);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${vehicle.brand} ${vehicle.model} has been deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showServiceHistory(Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vehicle.brand} ${vehicle.model}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Service History (${vehicle.serviceHistory.length})',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                vehicle.serviceHistory.isEmpty
                    ? const Expanded(
                  child: Center(
                    child: Text('No service records found'),
                  ),
                )
                    : Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: vehicle.serviceHistory.length,
                    itemBuilder: (context, index) {
                      final record = vehicle.serviceHistory[index];
                      return _buildServiceRecordItem(record);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => _showAddServiceDialog(vehicle),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0099B1),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Add Service Record'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildServiceRecordItem(ServiceRecord record) {
    return ListTile(
      title: Text(record.type,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(record.description),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Rs. ${record.cost.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0099B1),
            ),
          ),
          Text('${record.date.day}/${record.date.month}/${record.date.year}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      leading: const CircleAvatar(
        backgroundColor: Color(0xFF0099B1),
        child: Icon(Icons.build, color: Colors.white, size: 20),
      ),
    );
  }

  void _showAddServiceDialog(Vehicle vehicle) {
    typeController.clear(); // Updated from _typeController
    descriptionController.clear(); // Updated from _descriptionController
    costController.clear(); // Updated from _costController
    bookingIdController.clear(); // Updated from _bookingIdController
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Service Record'),
            content: SingleChildScrollView(
              child: Form(
                key: serviceFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: typeController, // Updated from _typeController
                      decoration: const InputDecoration(
                        labelText: 'Service Type',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the service type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Date picker
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: descriptionController, // Updated from _descriptionController
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: costController, // Updated from _costController
                      decoration: const InputDecoration(
                        labelText: 'Cost (Rs.)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the cost';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: bookingIdController, // Updated from _bookingIdController
                      decoration: const InputDecoration(
                        labelText: 'Booking ID (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (serviceFormKey.currentState!.validate()) {
                    final index = vehicles.indexOf(vehicle);
                    if (index != -1) {
                      // Create a new vehicle with the updated service history
                      final updatedVehicle = Vehicle(
                        id: vehicle.id,
                        brand: vehicle.brand,
                        model: vehicle.model,
                        year: vehicle.year,
                        registrationNumber: vehicle.registrationNumber,
                        imagePath: vehicle.imagePath,
                        serviceHistory: [
                          ...vehicle.serviceHistory,
                          ServiceRecord(
                            date: selectedDate,
                            type: typeController.text, // Updated from _typeController
                            description: descriptionController.text, // Updated from _descriptionController
                            cost: double.parse(costController.text), // Updated from _costController
                            bookingId: bookingIdController.text, // Updated from _bookingIdController
                          ),
                        ],
                      );

                      // Update the vehicle list
                      setState(() {
                        vehicles[index] = updatedVehicle;
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Service record added successfully!'),
                          backgroundColor: Color(0xFF0099B1),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0099B1),
                ),
                child: const Text('Add Record'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Image Source'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _pickImageFromGallery();
            },
            child: const ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _pickImageFromCamera();
            },
            child: const ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
            ),
          ),
        ],
      ),
    );
  }

  void _addVehicle() {
    if (formKey.currentState!.validate()) {
      setState(() {
        vehicles.add(
          Vehicle(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            brand: selectedBrand,
            model: modelController.text,
            year: yearController.text, // Updated from _yearController
            registrationNumber: registrationController.text, // Updated from _registrationController
            imagePath: selectedImagePath ?? 'lib/assets/car_placeholder.png',
            serviceHistory: [],
          ),
        );
      });

      modelController.clear();
      yearController.clear(); // Updated from _yearController
      registrationController.clear(); // Updated from _registrationController

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehicle added successfully!'),
          backgroundColor: Color(0xFF0099B1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0099B1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0099B1),
        elevation: 0,
        title: const Text('Vehicle Profiles'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: vehicles.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  return _buildVehicleCard(vehicles[index]);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddVehicleDialog,
        backgroundColor: const Color(0xFF004D5B),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          const Text(
            'No vehicles added yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D5B),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap the + button to add a vehicle',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Vehicle image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0099B1),
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: AssetImage(vehicle.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Vehicle details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${vehicle.brand} ${vehicle.model}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D5B),
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
                      const SizedBox(height: 4),
                      Text(
                        'Reg: ${vehicle.registrationNumber}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Delete button
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  onPressed: () => _showDeleteConfirmationDialog(vehicle),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Service history section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Service Records: ${vehicle.serviceHistory.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // View history button
                ElevatedButton(
                  onPressed: () => _showServiceHistory(vehicle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0099B1),
                  ),
                  child: const Text('View History'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}