import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/VehicleRepairMain.dart';

class SparePartItem {
  final String name;
  final String description;
  final String imageAsset;
  final double price;
  final String? vehicleBrand;
  final String? vehicleModel;

  SparePartItem({
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.price,
    this.vehicleBrand,
    this.vehicleModel,
  });
}

class VehicleSparePartsScreen extends StatefulWidget {
  const VehicleSparePartsScreen({Key? key}) : super(key: key);

  @override
  State<VehicleSparePartsScreen> createState() => _VehicleSparePartsScreenState();
}

class _VehicleSparePartsScreenState extends State<VehicleSparePartsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedBrand;
  String? _selectedModel;

  // Define specific vehicle brands
  final List<String> _specificBrands = [
    'Any',
    'Toyota',
    'Honda',
    'Nissan',
    'Suzuki',
    'Hyundai',
    'Mitsubishi'
  ];

  final List<SparePartItem> _spareParts = [
    SparePartItem(
      name: '3D Carpet set',
      description: 'for Toyota Premior',
      imageAsset: 'lib/assets/carpet3.jpg',
      price: 12500,
      vehicleBrand: 'Toyota',
      vehicleModel: 'Premior',
    ),
    SparePartItem(
      name: '10 Spoke 15"',
      description: 'Alloy wheel (4 wheel set)',
      imageAsset: 'lib/assets/wheel1.webp',
      price: 60500,
      vehicleBrand: 'Any',
      vehicleModel: 'Any',
    ),
    SparePartItem(
      name: 'LED Break Light',
      description: 'for Toyota Corolla',
      imageAsset: 'lib/assets/light1.jpg',
      price: 10500,
      vehicleBrand: 'Toyota',
      vehicleModel: 'Corolla',
    ),
    SparePartItem(
      name: 'Fully LED Head light',
      description: 'with DRL for SUZUKI Swift',
      imageAsset: 'lib/assets/light2.webp',
      price: 122750,
      vehicleBrand: 'Suzuki',
      vehicleModel: 'Swift',
    ),
    SparePartItem(
      name: '3D Carpet set',
      description: 'for Toyota CHR',
      imageAsset: 'lib/assets/carpet3.jpg',
      price: 12500,
      vehicleBrand: 'Toyota',
      vehicleModel: 'CHR',
    ),
    SparePartItem(
      name: '10 Spoke 15"',
      description: 'Alloy wheel (4 wheel set)',
      imageAsset: 'lib/assets/wheel1.webp',
      price: 60500,
      vehicleBrand: 'Any',
      vehicleModel: 'Any',
    ),
    SparePartItem(
      name: 'Middle mount LED',
      description: 'Break light',
      imageAsset: 'lib/assets/light1.jpg',
      price: 10500,
      vehicleBrand: 'Honda',
      vehicleModel: 'Civic',
    ),
    SparePartItem(
      name: 'Fully LED Head light',
      description: 'with DRL for SUZUKI Swift',
      imageAsset: 'lib/assets/light2.webp',
      price: 122750,
      vehicleBrand: 'Suzuki',
      vehicleModel: 'Swift',
    ),
  ];

  // Get filtered parts based on selected filters
  List<SparePartItem> get _filteredParts {
    return _spareParts.where((part) {
      // Filter by brand if selected
      if (_selectedBrand != null && _selectedBrand != "Any") {
        if (part.vehicleBrand != _selectedBrand) {
          return false;
        }
      }

      // Filter by model if selected
      if (_selectedModel != null && _selectedModel != "Any") {
        if (part.vehicleModel != _selectedModel) {
          return false;
        }
      }

      // Search filter (if implemented)
      if (_searchController.text.isNotEmpty) {
        final searchQuery = _searchController.text.toLowerCase();
        return part.name.toLowerCase().contains(searchQuery) ||
            part.description.toLowerCase().contains(searchQuery);
      }

      return true;
    }).toList();
  }

  // Get models for selected brand
  List<String> get _vehicleModels {
    if (_selectedBrand == null || _selectedBrand == "Any") {
      return ["Any"];
    }

    final models = _spareParts
        .where((part) => part.vehicleBrand == _selectedBrand)
        .map((part) => part.vehicleModel ?? "Any")
        .toSet()
        .toList();

    // Make sure "Any" is first in the list
    if (models.contains("Any")) {
      models.remove("Any");
    }
    models.insert(0, "Any");

    return models;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text(
              'Filter Options',
              style: TextStyle(
                color: Color(0xFF004D5B),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle brand dropdown
                const Text(
                  'Vehicle Brand',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedBrand,
                      hint: const Text('Select Brand'),
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      items: _specificBrands.map((brand) {
                        return DropdownMenuItem<String>(
                          value: brand,
                          child: Text(brand),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedBrand = value;
                          // Reset model when brand changes
                          _selectedModel = null;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Vehicle model dropdown
                const Text(
                  'Vehicle Model',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedModel,
                      hint: const Text('Select Model'),
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      items: _vehicleModels.map((model) {
                        return DropdownMenuItem<String>(
                          value: model,
                          child: Text(model),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedModel = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              // Clear filter button
              TextButton(
                onPressed: () {
                  setDialogState(() {
                    _selectedBrand = null;
                    _selectedModel = null;
                  });
                },
                child: const Text(
                  'Clear Filters',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              // Apply button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Apply filters (no need to do anything, since we're using getters)
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B2CA),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and title
              Stack(
                children: [
                  // Background image
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        'lib/assets/SignUp_bg.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF004D5B),
                          );
                        },
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
                            MaterialPageRoute(builder: (context) => const VehicleRepairMainScreen()),
                          );
                        },
                      ),
                    ),
                  ),

                  // Title
                  const Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Vehicle Spare Parts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
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
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Search bar and filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Row(
                  children: [
                    // Search bar
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            border: InputBorder.none,
                            hintText: 'Search',
                            hintStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  // Refresh list when search button is pressed
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // Update search results as user types
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Filter button
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.filter_alt_outlined, color: Colors.grey),
                            onPressed: _showFilterDialog,
                          ),
                          if (_selectedBrand != null || _selectedModel != null)
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Active filters indicator (optional)
              if (_selectedBrand != null || _selectedModel != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      if (_selectedBrand != null && _selectedBrand != "Any")
                        Chip(
                          label: Text('Brand: $_selectedBrand'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedBrand = null;
                              _selectedModel = null;
                            });
                          },
                          backgroundColor: Colors.white.withOpacity(0.7),
                          labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF004D5B)),
                        ),
                      if (_selectedModel != null && _selectedModel != "Any")
                        Chip(
                          label: Text('Model: $_selectedModel'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedModel = null;
                            });
                          },
                          backgroundColor: Colors.white.withOpacity(0.7),
                          labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF004D5B)),
                        ),
                    ],
                  ),
                ),

              // Grid of spare parts
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: _filteredParts.isEmpty
                      ? const Center(
                    child: Text(
                      'No spare parts found for your filter criteria',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredParts.length,
                    itemBuilder: (context, index) {
                      final part = _filteredParts[index];
                      return _buildSparePartCard(part);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSparePartCard(SparePartItem part) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Part image
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    part.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if image isn't found
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Part details - bottom section with dark background
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF004D5B),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  children: [
                    // Part name
                    Text(
                      part.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Part description
                    Text(
                      part.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Price tag
          Positioned(
            bottom: 80, // Positioned above the description container
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Text(
                'LKR. ${part.price.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}