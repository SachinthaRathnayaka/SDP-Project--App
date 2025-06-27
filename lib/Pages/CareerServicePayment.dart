import 'package:flutter/material.dart';
import 'package:sachir_vehicle_care/Pages/HomeScreen.dart';

class PaymentMethod {
  final String id;
  final String type; // 'visa', 'mastercard', etc.
  final String lastFourDigits;
  final String? cardNumber; // Full masked number (if needed)
  final IconData icon;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.lastFourDigits,
    this.cardNumber,
    required this.icon,
  });
}

class VehicleCarrierPaymentScreen extends StatefulWidget {
  final double amount;
  final String serviceType;
  final String jobId;

  const VehicleCarrierPaymentScreen({
    Key? key,
    required this.amount,
    required this.serviceType,
    required this.jobId,
  }) : super(key: key);

  @override
  State<VehicleCarrierPaymentScreen> createState() => _VehicleCarrierPaymentScreenState();
}

class _VehicleCarrierPaymentScreenState extends State<VehicleCarrierPaymentScreen> {
  int? _selectedPaymentMethodIndex;
  bool _isProcessing = false;

  // Sample payment methods
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: 'card_1',
      type: 'visa',
      lastFourDigits: '1423',
      cardNumber: '2459 xxxx xxxx 1423',
      icon: Icons.credit_card,
    ),
    PaymentMethod(
      id: 'card_2',
      type: 'mastercard',
      lastFourDigits: '2536',
      cardNumber: '5321 xxxx xxxx 2536',
      icon: Icons.credit_card,
    ),
  ];

  void _addPaymentMethod() {
    // In a real app, this would navigate to an "Add payment method" screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment Method'),
        content: const Text('This would navigate to a payment method form in a real app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _processPayment() {
    if (_selectedPaymentMethodIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });

      // Show payment confirmation
      _showPaymentConfirmation();
    });
  }

  void _showPaymentConfirmation() {
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
                      'Payment Successful!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D5B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your payment of ${widget.amount.toStringAsFixed(2)} LKR has been processed successfully.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Job ID: ${widget.jobId}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          // Navigate back to home or booking list screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen ()),
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
                        child: const Text('Done'),
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
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),

              // Payment title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                child: Text(
                  'Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Payment card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Payment Options title
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Payment Options',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // List of payment methods
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            itemCount: _paymentMethods.length + 1, // +1 for "Add a payment method" option
                            itemBuilder: (context, index) {
                              if (index < _paymentMethods.length) {
                                // Payment method items
                                final method = _paymentMethods[index];
                                return _buildPaymentMethodTile(
                                  method: method,
                                  isSelected: _selectedPaymentMethodIndex == index,
                                  onTap: () {
                                    setState(() {
                                      _selectedPaymentMethodIndex = index;
                                    });
                                  },
                                );
                              } else {
                                // "Add a payment method" item
                                return _buildAddPaymentMethodTile();
                              }
                            },
                          ),
                        ),

                        // Pay button
                        Padding(
                          padding: const EdgeInsets.all(80.0),
                          child: Column(
                            children: [
                              // Pay button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isProcessing ? null : _processPayment,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00B2CA),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: _isProcessing
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : const Text(
                                    'Pay',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              // Help & Feedback link
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Show help dialog or navigate to help screen
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Help & Feedback'),
                                        content: const Text('For assistance with payment or to provide feedback, please contact our support team at support@sachir.com or call +94766734993.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Help & Feedback',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
    );
  }

  Widget _buildPaymentMethodTile({
    required PaymentMethod method,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Choose the right card icon/image based on card type
    Widget cardIcon;
    if (method.type == 'visa') {
      cardIcon = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'lib/assets/Visacard.jpeg',
          height: 35,
          width: 40,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if image is missing
            return Icon(
              Icons.credit_card,
              color: Colors.orange[800],
              size: 25,
            );
          },
        ),
      );
    } else if (method.type == 'mastercard') {
      cardIcon = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'lib/assets/Mastercard.jpeg',
          height: 55,
          width: 40,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if image is missing
            return Icon(
              Icons.credit_card,
              color: Colors.orange[800],
              size: 25,
            );
          },
        ),
      );
    } else {
      cardIcon = Icon(
        method.icon,
        color: Colors.blue[800],
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        border: isSelected
            ? Border.all(color: const Color(0xFF00B2CA), width: 2)
            : null,
      ),
      child: ListTile(
        leading: cardIcon,
        title: Text(
          method.cardNumber ?? '•••• •••• •••• ${method.lastFourDigits}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Color(0xFF00B2CA))
            : const Icon(Icons.circle_outlined, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildAddPaymentMethodTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(Icons.add_circle_outline, color: Colors.black54),
        title: const Text(
          'Add a payment method',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        onTap: _addPaymentMethod,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

// Example of how to use this screen:
/*
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
*/