import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sachir_vehicle_care/Pages/VehicleCreerServiceMain.dart';
import 'package:sachir_vehicle_care/Pages/CareerServicePayment.dart';

// BookingDetails class definition
class BookingDetails {
  final String vehicleBrand;
  final String vehicleModel;
  final String vehicleType;
  final String vehicleImage;
  final String customerName;
  final String contactNumber;
  final String vehicleNumber;
  final String jobId;
  final String bookingDate;
  final double amount;

  BookingDetails({
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleType,
    required this.vehicleImage,
    required this.customerName,
    required this.contactNumber,
    required this.vehicleNumber,
    required this.jobId,
    required this.bookingDate,
    required this.amount,
  });
}

class VehicleCarrierServiceStatusScreen extends StatelessWidget {
  final BookingDetails bookingDetails;

  const VehicleCarrierServiceStatusScreen({
    Key? key,
    required this.bookingDetails,
  }) : super(key: key);

  // Method to copy job ID to clipboard
  void _copyJobIdToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: bookingDetails.jobId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Job ID copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Method to handle payment
  void _handlePayment(BuildContext context) {
    // In a real app, this would navigate to a payment gateway or screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Process Payment'),
        content: Text(
          'Proceed to payment gateway for amount: ${bookingDetails.amount.toStringAsFixed(2)} LKR',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehicleCarrierPaymentScreen(
                    amount: 4300.00,
                    serviceType: 'Carrier Service',
                    jobId: '68761616',
                  ),
                ),
              );
            },
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }

  // Payment success dialog
  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Payment Successful'),
          ],
        ),
        content: const Text(
          'Your payment has been processed successfully. You will receive a confirmation message shortly.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, you might navigate back to a home screen
            },
            child: const Text('OK'),
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
        // Wrap the entire content with SingleChildScrollView to fix bottom overflow
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0), // Add bottom padding
              child: Column(
                children: [
                  // Header with back button, title and logo
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [

                        // Back button
                        CircleAvatar(
                          backgroundColor: Colors.white.withAlpha(128),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const VehicleCarrierServiceScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Booking Status title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Booking Status',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Booking details card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF004D5B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Vehicle image and details - Fix right overflow with Flexible widgets
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Vehicle image
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    bookingDetails.vehicleImage,
                                    width: 120,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Vehicle details - Flexible to prevent overflow
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bookingDetails.vehicleBrand,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        // Add overflow handling for text
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        bookingDetails.vehicleModel,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        bookingDetails.vehicleType,
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Divider
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(
                              color: Colors.white24,
                              thickness: 1,
                            ),
                          ),

                          // Booking information
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Customer name - Fix right overflow with modified _buildInfoRow
                                _buildInfoRow(
                                  label: 'Customer name:',
                                  value: bookingDetails.customerName,
                                ),
                                const SizedBox(height: 8),

                                // Contact
                                _buildInfoRow(
                                  label: 'Contact:',
                                  value: bookingDetails.contactNumber,
                                ),
                                const SizedBox(height: 8),

                                // Vehicle number
                                _buildInfoRow(
                                  label: 'Vehicle number:',
                                  value: bookingDetails.vehicleNumber,
                                ),
                                const SizedBox(height: 8),

                                // Job ID (with tap to copy)
                                GestureDetector(
                                  onTap: () => _copyJobIdToClipboard(context),
                                  child: _buildInfoRow(
                                    label: 'Job ID:',
                                    value: bookingDetails.jobId,
                                    valueColor: Colors.white,
                                    valueWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Date
                                _buildInfoRow(
                                  label: 'Date:',
                                  value: bookingDetails.bookingDate,
                                ),
                              ],
                            ),
                          ),

                          // Amount
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                '${bookingDetails.amount.toStringAsFixed(2)} LKR',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        children: [
                          // Main content
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                // Animated check icon with gradient
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Text content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Saved your details',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E3A5F),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF6C7A92),
                                            height: 1.4,
                                          ),
                                          children: [
                                            const TextSpan(text: 'Use Job no '),
                                            TextSpan(
                                              text: '68761616',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF00AB55),
                                              ),
                                            ),
                                            const TextSpan(text: ' to inquire about your booking.'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Optional: Bottom action strip
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF4F9F6),
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xFFE0F2F1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  // Copy job ID to clipboard
                                  Clipboard.setData(const ClipboardData(text: '68761616'));
                                  // Show toast or snackbar
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.content_copy_outlined,
                                      size: 14,
                                      color: Color(0xFF00AB55),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Tap to copy Job ID',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF00AB55),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Pay now button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => _handlePayment(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0AC355),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Pay now',
                          style: TextStyle(
                            fontSize: 22,
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
    );
  }

  // Modified helper method to build info rows with overflow handling
  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
    FontWeight? valueWeight,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed width for label to ensure consistent alignment
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
            ),
          ),
        ),
        // Flexible for value to handle overflow
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 14,
              fontWeight: valueWeight ?? FontWeight.normal,
            ),
            // Handle text overflow
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}