import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyPaymentsScreen extends StatefulWidget {
  const MyPaymentsScreen({Key? key}) : super(key: key);

  @override
  State<MyPaymentsScreen> createState() => _MyPaymentsScreenState();
}

class _MyPaymentsScreenState extends State<MyPaymentsScreen> with TickerProviderStateMixin {
  // Tab controller for different payment views
  late TabController _tabController;

  // Filter selection
  String _selectedFilter = 'Last 3 Months';
  final List<String> _filterOptions = ['Last 3 Months', 'Last 6 Months', 'This Year', 'All Time'];

  // Mock payment data
  final List<Payment> _allPayments = [
    Payment(
      id: 'PAY-2025-001',
      amount: 5500.0,
      date: DateTime.now().subtract(const Duration(days: 5)),
      serviceType: 'Full Service',
      vehicleInfo: 'Toyota Aqua (CBB 2017)',
      paymentMethod: 'Credit Card',
      cardInfo: '**** **** **** 4582',
      status: PaymentStatus.completed,
    ),
    Payment(
      id: 'PAY-2025-002',
      amount: 12000.0,
      date: DateTime.now().subtract(const Duration(days: 15)),
      serviceType: 'Battery Replacement',
      vehicleInfo: 'Honda Civic (CAR 1234)',
      paymentMethod: 'Online Banking',
      status: PaymentStatus.completed,
    ),
    Payment(
      id: 'PAY-2025-003',
      amount: 3500.0,
      date: DateTime.now().subtract(const Duration(days: 30)),
      serviceType: 'Wheel Alignment',
      vehicleInfo: 'Suzuki Swift (KD 5678)',
      paymentMethod: 'Cash',
      status: PaymentStatus.completed,
    ),
    Payment(
      id: 'PAY-2025-004',
      amount: 8000.0,
      date: DateTime.now().subtract(const Duration(days: 60)),
      serviceType: 'AC Repair',
      vehicleInfo: 'Nissan Leaf (EV 4567)',
      paymentMethod: 'Online Banking',
      status: PaymentStatus.pending,
    ),
    Payment(
      id: 'PAY-2025-005',
      amount: 7200.0,
      date: DateTime.now().subtract(const Duration(days: 90)),
      serviceType: 'Brake Pad Replacement',
      vehicleInfo: 'Mitsubishi Outlander (SUV 7890)',
      paymentMethod: 'Cash',
      status: PaymentStatus.failed,
    ),
  ];

  List<Payment> _filteredPayments = [];
  double _totalSpent = 0;

  @override
  void initState() {
    super.initState();

    // Initialize tab controller
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    // Filter payments initially
    _applyTimeFilter(_selectedFilter);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _applyTimeFilter(String filter) {
    setState(() {
      _selectedFilter = filter;

      final now = DateTime.now();
      late DateTime cutoffDate;

      switch (filter) {
        case 'Last 3 Months':
          cutoffDate = DateTime(now.year, now.month - 3, now.day);
          break;
        case 'Last 6 Months':
          cutoffDate = DateTime(now.year, now.month - 6, now.day);
          break;
        case 'This Year':
          cutoffDate = DateTime(now.year, 1, 1);
          break;
        case 'All Time':
          cutoffDate = DateTime(2000);
          break;
      }

      _filteredPayments = _allPayments
          .where((payment) => payment.date.isAfter(cutoffDate))
          .toList();

      // Calculate total spent
      _totalSpent = _filteredPayments
          .where((payment) => payment.status == PaymentStatus.completed)
          .fold(0, (sum, payment) => sum + payment.amount);
    });
  }

  void _showPaymentDetails(Payment payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPaymentDetailsSheet(payment),
    );
  }

  Widget _buildPaymentDetailsSheet(Payment payment) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),

              // Header with payment ID and status
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment #${payment.id}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D5B),
                      ),
                    ),
                    _buildStatusChip(payment.status),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Payment details
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Amount
                    Center(
                      child: Text(
                        'Rs. ${NumberFormat('#,##0.00').format(payment.amount)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D5B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Payment info
                    _buildDetailSection(
                      title: 'Payment Information',
                      children: [
                        _buildDetailRow(
                          icon: Icons.calendar_today,
                          label: 'Date',
                          value: DateFormat('MMMM d, yyyy').format(payment.date),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          icon: Icons.payment,
                          label: 'Payment Method',
                          value: payment.paymentMethod,
                        ),
                        if (payment.cardInfo != null) ...[
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            icon: Icons.credit_card,
                            label: 'Card',
                            value: payment.cardInfo!,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Service info
                    _buildDetailSection(
                      title: 'Service Information',
                      children: [
                        _buildDetailRow(
                          icon: Icons.miscellaneous_services,
                          label: 'Service Type',
                          value: payment.serviceType,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          icon: Icons.directions_car,
                          label: 'Vehicle',
                          value: payment.vehicleInfo,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Action buttons based on status
                    if (payment.status == PaymentStatus.completed)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.receipt_long),
                        label: const Text('View Receipt'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B2CA),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),

                    if (payment.status == PaymentStatus.failed)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B2CA),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('Retry Payment'),
                      ),

                    if (payment.status == PaymentStatus.pending)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('Cancel Payment'),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF00B2CA),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D5B),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F9FA),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF00B2CA).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF00B2CA),
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white.withAlpha(128),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'My Payments',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white.withAlpha(128),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.black, size: 18),
                        onPressed: () {
                          // Handle search
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Analytics card
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time filter dropdown
                    DropdownButton<String>(
                      value: _selectedFilter,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      underline: const SizedBox(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D5B),
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _applyTimeFilter(newValue);
                        }
                      },
                      items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 10),

                    // Total spent amount
                    Text(
                      'Rs. ${NumberFormat('#,##0.00').format(_totalSpent)}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D5B),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Total spent label
                    Text(
                      'Total spent on vehicle maintenance',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Tab bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: const Color(0xFF004D5B),
                  unselectedLabelColor: Colors.white,
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Completed'),
                    Tab(text: 'Pending'),
                  ],
                ),
              ),

              // Tab views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // All payments tab
                    _buildPaymentsList(_filteredPayments),

                    // Completed payments tab
                    _buildPaymentsList(_filteredPayments
                        .where((p) => p.status == PaymentStatus.completed)
                        .toList()),

                    // Pending payments tab
                    _buildPaymentsList(_filteredPayments
                        .where((p) => p.status == PaymentStatus.pending || p.status == PaymentStatus.failed)
                        .toList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentsList(List<Payment> payments) {
    if (payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 60,
              color: Colors.white.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            const Text(
              'No payments found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'There are no payments in this category for the selected time period.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return _buildPaymentCard(payment);
      },
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showPaymentDetails(payment),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              // Payment card header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F9FA),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    // Payment method icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getPaymentMethodColor(payment.paymentMethod),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getPaymentMethodIcon(payment.paymentMethod),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Payment info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment.paymentMethod,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF004D5B),
                            ),
                          ),
                          if (payment.cardInfo != null)
                            Text(
                              payment.cardInfo!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Status chip
                    _buildStatusChip(payment.status),
                  ],
                ),
              ),

              // Payment details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F7F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.miscellaneous_services,
                        color: Color(0xFF00B2CA),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Service details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment.serviceType,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF004D5B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            payment.vehicleInfo,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs. ${NumberFormat('#,##0.00').format(payment.amount)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF004D5B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM d, yyyy').format(payment.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(PaymentStatus status) {
    Color backgroundColor;
    String statusText;

    switch (status) {
      case PaymentStatus.completed:
        backgroundColor = const Color(0xFF4CAF50);
        statusText = 'COMPLETED';
        break;
      case PaymentStatus.pending:
        backgroundColor = const Color(0xFFFF9800);
        statusText = 'PENDING';
        break;
      case PaymentStatus.failed:
        backgroundColor = Colors.red.shade700;
        statusText = 'FAILED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'credit card':
        return Icons.credit_card;
      case 'online banking':
        return Icons.account_balance;
      case 'cash':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }

  Color _getPaymentMethodColor(String method) {
    switch (method.toLowerCase()) {
      case 'credit card':
        return const Color(0xFF4CAF50);
      case 'online banking':
        return const Color(0xFF3F51B5);
      case 'cash':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF00B2CA);
    }
  }
}

// Data models
enum PaymentStatus {
  completed,
  pending,
  failed,
}

class Payment {
  final String id;
  final double amount;
  final DateTime date;
  final String serviceType;
  final String vehicleInfo;
  final String paymentMethod;
  final String? cardInfo;
  final PaymentStatus status;

  Payment({
    required this.id,
    required this.amount,
    required this.date,
    required this.serviceType,
    required this.vehicleInfo,
    required this.paymentMethod,
    this.cardInfo,
    required this.status,
  });
}