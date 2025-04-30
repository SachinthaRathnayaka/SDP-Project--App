import 'package:flutter/material.dart';

class SparePartItem {
  final String name;
  final String description;
  final String imageAsset;
  final double price;

  SparePartItem({
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.price,
  });
}

class VehicleSparePartsScreen extends StatefulWidget {
  const VehicleSparePartsScreen({Key? key}) : super(key: key);

  @override
  State<VehicleSparePartsScreen> createState() => _VehicleSparePartsScreenState();
}

class _VehicleSparePartsScreenState extends State<VehicleSparePartsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<SparePartItem> _spareParts = [
    SparePartItem(
      name: '3D Carpet set',
      description: 'for Toyota Premior',
      imageAsset: 'assets/images/spare_parts/carpet_set.jpg',
      price: 12500,
    ),
    SparePartItem(
      name: '10 Spoke 15"',
      description: 'Alloy wheel (4 wheel set)',
      imageAsset: 'assets/images/spare_parts/alloy_wheel.jpg',
      price: 60500,
    ),
    SparePartItem(
      name: 'Middle mount LED',
      description: 'Break light',
      imageAsset: 'assets/images/spare_parts/break_light.jpg',
      price: 10500,
    ),
    SparePartItem(
      name: 'Fully LED Head light',
      description: 'with DRL for SUZUKI Swift',
      imageAsset: 'assets/images/spare_parts/head_light.jpg',
      price: 122750,
    ),
    // You can add more items here
  ];

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
              // Back button and logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    // Back button
                    CircleAvatar(
                      backgroundColor: Colors.white.withAlpha(128),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Spacer(),
                    // Logo (if needed)
                    Image.asset(
                      'assets/images/logo_small.png', // Make sure to add this asset
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              // Vehicle spare parts title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Text(
                  'Vehicle spare parts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Search bar and filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
                                // Implement search functionality here
                              },
                            ),
                          ),
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
                      child: IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.grey),
                        onPressed: () {
                          // Implement filter functionality
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Grid of spare parts
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _spareParts.length,
                    itemBuilder: (context, index) {
                      final part = _spareParts[index];
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Part image
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: Image.asset(
                      part.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if image isn't found
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Part details
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF004D5B),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Part name
                    Text(
                      part.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Part description
                    Text(
                      part.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Price tag
          Positioned(
            bottom: 64,
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
                'Rs. ${part.price.toInt()}',
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