import 'package:flutter/material.dart';

class ModificationPart {
  final String name;
  final String description;
  final String imageAsset;
  final double price;
  final String? vehicleInfo;
  final String? vehicleBrand;
  final String? vehicleModel;

  ModificationPart({
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.price,
    this.vehicleInfo,
    this.vehicleBrand,
    this.vehicleModel,
  });
}

class VehicleWheelModificationPartsScreen extends StatefulWidget {
  const VehicleWheelModificationPartsScreen({Key? key}) : super(key: key);

  @override
  State<VehicleWheelModificationPartsScreen> createState() => _VehicleWheelModificationPartsScreenState();
}

class _VehicleWheelModificationPartsScreenState extends State<VehicleWheelModificationPartsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedBrand;
  String? _selectedModel;

  // Predefined list of vehicle brands
  final List<String> _predefinedBrands = [
    'Any',
    'Toyota',
    'Honda',
    'Nissan',
    'Suzuki',
    'Hyundai',
    'Mitsubishi'
  ];

  final List<ModificationPart> _modificationParts = [
    ModificationPart(
      name: 'Fully LED Head light',
      description: 'with DRL',
      imageAsset: 'lib/assets/light2.webp',
      price: 125000,
      vehicleInfo: 'For SUZUKI Swift',
      vehicleBrand: 'Suzuki',
      vehicleModel: 'Swift',
    ),
    ModificationPart(
      name: 'Premium car carpet set',
      description: 'with Dust absorbance',
      imageAsset: 'lib/assets/carpet2.jpg',
      price: 37950,
      vehicleInfo: 'For TOYOTA Premio',
      vehicleBrand: 'Toyota',
      vehicleModel: 'Premio',
    ),
    ModificationPart(
      name: '3D Carpet set',
      description: '',
      imageAsset: 'lib/assets/carpet3.jpg',
      price: 97850,
      vehicleInfo: 'For Any vehicle',
      vehicleBrand: 'Any',
      vehicleModel: 'Any',
    ),
    ModificationPart(
      name: 'Racing exhaust pipe',
      description: '',
      imageAsset: 'lib/assets/shoks.jpg',
      price: 35000,
      vehicleInfo: 'For Any vehicle',
      vehicleBrand: 'Any',
      vehicleModel: 'Any',
    ),
    ModificationPart(
      name: 'Fully LED Head light',
      description: 'with DRL',
      imageAsset: 'lib/assets/light2.webp',
      price: 125000,
      vehicleInfo: 'For SUZUKI Swift',
      vehicleBrand: 'Suzuki',
      vehicleModel: 'Swift',
    ),
    ModificationPart(
      name: 'Premium car carpet set',
      description: 'with Dust absorbance',
      imageAsset: 'lib/assets/carpet2.jpg',
      price: 37950,
      vehicleInfo: 'For TOYOTA Premio',
      vehicleBrand: 'Toyota',
      vehicleModel: 'Premio',
    ),
    ModificationPart(
      name: '3D Carpet set',
      description: '',
      imageAsset: 'lib/assets/carpet3.jpg',
      price: 97850,
      vehicleInfo: 'For Any vehicle',
      vehicleBrand: 'Any',
      vehicleModel: 'Any',
    ),
    ModificationPart(
      name: 'Racing exhaust pipe',
      description: '',
      imageAsset: 'lib/assets/shoks.jpg',
      price: 35000,
      vehicleInfo: 'For Any vehicle',
      vehicleBrand: 'Any',
      vehicleModel: 'Any',
    ),
  ];

  // Get filtered parts based on selected filters and search text
  List<ModificationPart> get _filteredParts {
    return _modificationParts.where((part) {
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

      // Search filter
      if (_searchController.text.isNotEmpty) {
        final searchQuery = _searchController.text.toLowerCase();
        return part.name.toLowerCase().contains(searchQuery) ||
            (part.description.isNotEmpty && part.description.toLowerCase().contains(searchQuery)) ||
            (part.vehicleInfo?.toLowerCase().contains(searchQuery) ?? false);
      }

      return true;
    }).toList();
  }

  // Get models for selected brand
  List<String> get _vehicleModels {
    if (_selectedBrand == null || _selectedBrand == "Any") {
      return ["Any"];
    }

    final models = _modificationParts
        .where((part) => part.vehicleBrand == _selectedBrand)
        .map((part) => part.vehicleModel ?? "Any")
        .toSet()
        .toList();

    if (!models.contains("Any")) {
      models.insert(0, "Any");
    }
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
                      items: _predefinedBrands.map((brand) {
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
                    // Apply filters
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
          // Gradient background
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
              // Background image with gradient overlay
              Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF00B2CA).withOpacity(0.8),
                        const Color(0xFF00B2CA).withOpacity(0.95),
                      ],
                      stops: const [0.0, 0.3, 0.6],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcOver,
                  child: Image.asset(
                    'lib/assets/Vehicle_Modi_BG.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF00B2CA),
                      );
                    },
                  ),
                ),
              ),

              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with logo and back button
                  Stack(
                    children: [
                      // Header container with height
                      Container(
                        width: double.infinity,
                        height: 180, // Fixed height for header area
                        decoration: BoxDecoration(
                          color: Colors.transparent,
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
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),

                      // SachiR Vehicle Care Logo
                      Positioned(
                        top: -10,
                        right: -110,
                        child: Image.asset(
                          'lib/assets/SachiR_Vehicle_Care.png',
                          width: 400,
                          height: 220,
                          color: Colors.white,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(width: 100, height: 50);
                          },
                        ),
                      ),
                    ],
                  ),

                  // Search and filter bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        // Search field
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 13),
                                border: InputBorder.none,
                                hintText: 'Search...',
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(Icons.search, color: Colors.grey),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  // Trigger rebuild when search text changes
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Filter button with indicator if filters are active
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
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

                  // Active filters chips
                  if (_selectedBrand != null || _selectedModel != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
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

                  // List of modification parts - using filtered parts
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: _filteredParts.isEmpty
                          ? Center(
                        child: Text(
                          'No parts found for your search criteria',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      )
                          : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: _filteredParts.length,
                        itemBuilder: (context, index) {
                          final part = _filteredParts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildPartCard(part),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartCard(ModificationPart part) {
    return Container(
      height: 130, // Fixed height for all cards
      decoration: BoxDecoration(
        color: const Color(0xFF004D5B),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Part image (left side)
          Container(
            width: 140, // Fixed width for images
            height: 130,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              image: DecorationImage(
                image: AssetImage(part.imageAsset),
                fit: BoxFit.cover,
              ),
            ),
            child: part.imageAsset.isEmpty
                ? Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.image_not_supported,
                size: 40,
                color: Colors.grey,
              ),
            )
                : null,
          ),

          // Part details (right side)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Part name
                  Text(
                    part.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (part.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    // Part description
                    Text(
                      part.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],

                  const SizedBox(height: 4),

                  // Vehicle info
                  if (part.vehicleInfo != null)
                    Text(
                      part.vehicleInfo!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),

                  const Spacer(),

                  // Price tag
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${part.price.toInt().toString()} LKR',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}