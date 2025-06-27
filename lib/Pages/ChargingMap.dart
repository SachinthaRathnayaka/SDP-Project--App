import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleChargingMapScreen extends StatefulWidget {
  const VehicleChargingMapScreen({Key? key}) : super(key: key);

  @override
  State<VehicleChargingMapScreen> createState() => _VehicleChargingMapScreenState();
}

class _VehicleChargingMapScreenState extends State<VehicleChargingMapScreen> {
  // Controller for the Google Map
  GoogleMapController? _mapController;

  // Initial camera position (centered on Colombo, Sri Lanka)
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(6.9271, 79.8612), // Colombo coordinates
    zoom: 13.0,
  );

  // Set of markers to display charging stations
  final Set<Marker> _markers = {};

  // Charging station data
  final List<Map<String, dynamic>> _chargingStations = [
    {
      'id': 'station_1',
      'name': 'City Center EV Charging',
      'position': const LatLng(6.9271, 79.8612), // Colombo
      'address': 'Liberty Plaza, Colombo 03',
      'availability': 'Available (2/4)',
      'chargingTypes': ['Type 2', 'CCS'],
      'rating': 4.5,
    },
    {
      'id': 'station_2',
      'name': 'SachiR Charging Point',
      'position': const LatLng(6.9101, 79.8629), // Nearby location
      'address': 'Galle Road, Colombo 04',
      'availability': 'Busy (4/4)',
      'chargingTypes': ['CHAdeMO', 'Type 2'],
      'rating': 4.8,
    },
    {
      'id': 'station_3',
      'name': 'Green Power Charging',
      'position': const LatLng(6.9018, 79.8507), // Another location
      'address': 'Marine Drive, Colombo 03',
      'availability': 'Available (1/2)',
      'chargingTypes': ['CCS'],
      'rating': 4.2,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize markers
    _createMarkers();
  }

  // Create markers for charging stations
  void _createMarkers() {
    for (final station in _chargingStations) {
      final marker = Marker(
        markerId: MarkerId(station['id']),
        position: station['position'],
        infoWindow: InfoWindow(
          title: station['name'],
          snippet: station['availability'],
        ),
        onTap: () {
          _showStationDetails(station);
        },
      );

      _markers.add(marker);
    }
  }

  // Show details of a charging station
  void _showStationDetails(Map<String, dynamic> station) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF004D5B),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Station name
            Text(
              station['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Address
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 18),
                const SizedBox(width: 5),
                Text(
                  station['address'],
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 5),

            // Availability
            Row(
              children: [
                const Icon(Icons.electrical_services, color: Colors.grey, size: 18),
                const SizedBox(width: 5),
                Text(
                  station['availability'],
                  style: TextStyle(
                    color: station['availability'].toString().contains('Available')
                        ? Colors.green
                        : Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Charging types
            const Text(
              'Charging Types:',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Wrap(
              spacing: 10,
              children: (station['chargingTypes'] as List<String>).map((type) {
                return Chip(
                  label: Text(type),
                  backgroundColor: const Color(0xFF00B2CA),
                  labelStyle: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),

            const SizedBox(height: 15),

            // Rating
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < station['rating'].floor() ? Icons.star :
                    index < station['rating'] ? Icons.star_half : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
                const SizedBox(width: 10),
                Text(
                  '${station['rating']}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Button to navigate to the charging station
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the charging station (implement routing logic)
                  Navigator.pop(context);

                  // Move camera to the station location
                  _mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: station['position'],
                        zoom: 17,
                      ),
                    ),
                  );
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
                  'Navigate',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
          ),

          // Back button and title
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                // Back button
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF004D5B), size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(width: 15),

                // Title card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      'EV Charging Stations',
                      style: TextStyle(
                        color: Color(0xFF004D5B),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter and current location buttons
          Positioned(
            bottom: 30,
            right: 20,
            child: Column(
              children: [
                // Filter button
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt, color: Color(0xFF004D5B), size: 25),
                    onPressed: () {
                      // Show filter options (implement later)
                    },
                  ),
                ),

                const SizedBox(height: 15),

                // Current location button
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.my_location, color: Color(0xFF004D5B), size: 25),
                    onPressed: () {
                      // Move to user's current location
                      // This would typically use location services to get the user's position
                      // For now, just move to a predefined position
                      _mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(_initialCameraPosition),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}