import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;

  // Tab controller for switching between booking statuses
  late TabController _tabController;

  // Filter options
  final List<String> _filterOptions = ['All', 'This Week', 'This Month'];
  String _selectedFilter = 'All';

  // Mock booking data - in a real app, this would come from your API or database
  final List<BookingData> _allBookings = [
    BookingData(
      id: 'BK001',
      serviceType: 'Full Service',
      vehicleModel: 'Toyota Aqua',
      vehicleNumber: 'CBB 2017',
      date: DateTime.now().add(const Duration(days: 2)),
      time: '10:00 AM',
      status: BookingStatus.upcoming,
      cost: 'Rs. 5,500',
      notes: 'Oil change, filter replacement, and full inspection',
      serviceCenter: 'Peliyadoda Branch',
      isFavorite: true,
    ),
    BookingData(
      id: 'BK002',
      serviceType: 'Battery Replacement',
      vehicleModel: 'Honda Civic',
      vehicleNumber: 'CAR 1234',
      date: DateTime.now().add(const Duration(days: 1)),
      time: '2:30 PM',
      status: BookingStatus.upcoming,
      cost: 'Rs. 12,000',
      notes: 'New battery installation',
      serviceCenter: 'Keleniya Branch',
    ),
    BookingData(
      id: 'BK003',
      serviceType: 'Wheel Alignment',
      vehicleModel: 'Suzuki Swift',
      vehicleNumber: 'KD 5678',
      date: DateTime.now().add(const Duration(days: -2)),
      time: '9:00 AM',
      status: BookingStatus.completed,
      cost: 'Rs. 3,500',
      notes: 'Four wheel alignment and balancing',
      serviceCenter: 'Peliyadoda Branch',
      rating: 4,
    ),
    BookingData(
      id: 'BK004',
      serviceType: 'Oil Change',
      vehicleModel: 'Toyota Prius',
      vehicleNumber: 'PQK 8901',
      date: DateTime.now().add(const Duration(days: -5)),
      time: '11:30 AM',
      status: BookingStatus.completed,
      cost: 'Rs. 2,500',
      notes: 'Synthetic oil change with filter',
      serviceCenter: 'Kandy Branch',
      rating: 5,
    ),
    BookingData(
      id: 'BK005',
      serviceType: 'AC Repair',
      vehicleModel: 'Nissan Leaf',
      vehicleNumber: 'EV 4567',
      date: DateTime.now().add(const Duration(days: 5)),
      time: '3:00 PM',
      status: BookingStatus.upcoming,
      cost: 'Rs. 8,000',
      notes: 'AC not cooling properly',
      serviceCenter: 'Peliyadoda Branch',
    ),
    BookingData(
      id: 'BK006',
      serviceType: 'Brake Pad Replacement',
      vehicleModel: 'Mitsubishi Outlander',
      vehicleNumber: 'SUV 7890',
      date: DateTime.now().add(const Duration(days: -10)),
      time: '10:30 AM',
      status: BookingStatus.cancelled,
      cost: 'Rs. 7,200',
      notes: 'Front and rear brake pad replacement',
      serviceCenter: 'Keleniya Branch',
      cancellationReason: 'Technician unavailable',
    ),
  ];

  List<BookingData> _filteredBookings = [];
  List<BookingData> _displayedBookings = [];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize tab controller
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Filter bookings
    _filteredBookings = List.from(_allBookings);
    _applyTabFilter();

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _applyTabFilter();
      });
    }
  }

  void _applyTabFilter() {
    _fadeController.reset();
    _slideController.reset();

    setState(() {
      switch (_tabController.index) {
        case 0: // All
          _displayedBookings = _filteredBookings;
          break;
        case 1: // Upcoming
          _displayedBookings = _filteredBookings.where((booking) =>
          booking.status == BookingStatus.upcoming).toList();
          break;
        case 2: // Completed
          _displayedBookings = _filteredBookings.where((booking) =>
          booking.status == BookingStatus.completed ||
              booking.status == BookingStatus.cancelled).toList();
          break;
      }
    });

    _fadeController.forward();
    _slideController.forward();
  }

  void _applyDateFilter(String filter) {
    setState(() {
      _selectedFilter = filter;

      switch (filter) {
        case 'All':
          _filteredBookings = List.from(_allBookings);
          break;
        case 'This Week':
          final now = DateTime.now();
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));

          _filteredBookings = _allBookings.where((booking) {
            return booking.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                booking.date.isBefore(weekEnd.add(const Duration(days: 1)));
          }).toList();
          break;
        case 'This Month':
          final now = DateTime.now();
          final monthStart = DateTime(now.year, now.month, 1);
          final monthEnd = (now.month < 12)
              ? DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1))
              : DateTime(now.year + 1, 1, 1).subtract(const Duration(days: 1));

          _filteredBookings = _allBookings.where((booking) {
            return booking.date.isAfter(monthStart.subtract(const Duration(days: 1))) &&
                booking.date.isBefore(monthEnd.add(const Duration(days: 1)));
          }).toList();
          break;
      }

      _applyTabFilter();
    });
  }

  void _toggleFavorite(BookingData booking) {
    setState(() {
      booking.isFavorite = !booking.isFavorite;
    });
  }

  void _showBookingDetails(BuildContext context, BookingData booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBookingDetailsSheet(context, booking),
    );
  }

  Widget _buildBookingDetailsSheet(BuildContext context, BookingData booking) {
    return DraggableScrollableSheet(
      initialChildSize: 0.70,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),

              // Header with service type and status
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status).withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(
                            booking.status.name.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: _getStatusColor(booking.status),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        Text(
                          'Booking #${booking.id}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      booking.serviceType,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D5B),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${DateFormat('MMM d, yyyy').format(booking.date)} at ${booking.time}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              // Booking details
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Vehicle information
                    _buildDetailSection(
                      title: 'Vehicle Information',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            icon: Icons.directions_car,
                            label: 'Vehicle Model',
                            value: booking.vehicleModel,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            icon: Icons.tag,
                            label: 'Vehicle Number',
                            value: booking.vehicleNumber,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Service details
                    _buildDetailSection(
                      title: 'Service Details',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            icon: Icons.location_on,
                            label: 'Service Center',
                            value: booking.serviceCenter,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            icon: Icons.monetization_on,
                            label: 'Service Cost',
                            value: booking.cost,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            icon: Icons.notes,
                            label: 'Notes',
                            value: booking.notes,
                          ),
                          if (booking.status == BookingStatus.cancelled)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: _buildDetailRow(
                                icon: Icons.cancel,
                                label: 'Cancellation Reason',
                                value: booking.cancellationReason ?? 'None provided',
                                valueColor: Colors.red.shade700,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Rating section for completed bookings
                    if (booking.status == BookingStatus.completed)
                      _buildDetailSection(
                        title: 'Your Rating',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < (booking.rating ?? 0)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: const Color(0xFFFFB100),
                                  size: 28,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 30),

                    // Action buttons
                    if (booking.status == BookingStatus.upcoming)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Reschedule logic
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: Color(0xFF00B2CA)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Reschedule',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF00B2CA),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Cancel logic
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Cancel Booking',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    if (booking.status == BookingStatus.completed && (booking.rating ?? 0) == 0)
                      ElevatedButton(
                        onPressed: () {
                          // Rate service logic
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B2CA),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Rate Service',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF004D5B),
          ),
        ),
        const SizedBox(height: 15),
        content,
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
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
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? Colors.black,
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
            children: [
              // Custom app bar
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
                          'My Bookings',
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

              // Filter options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _filterOptions.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return GestureDetector(
                        onTap: () => _applyDateFilter(filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF004D5B) : Colors.white,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Tab bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Past'),
                  ],
                ),
              ),

              // Booking cards
              Expanded(
                child: _displayedBookings.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _displayedBookings.length,
                  itemBuilder: (context, index) {
                    final booking = _displayedBookings[index];

                    // Animation delays
                    final slideAnimation = Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _slideController,
                      curve: Interval(
                        0.1 * index,
                        0.1 * index + 0.6,
                        curve: Curves.easeOutQuad,
                      ),
                    ));

                    final fadeAnimation = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: _fadeController,
                      curve: Interval(
                        0.1 * index,
                        0.1 * index + 0.6,
                        curve: Curves.easeOut,
                      ),
                    ));

                    return SlideTransition(
                      position: slideAnimation,
                      child: FadeTransition(
                        opacity: fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildBookingCard(context, booking),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to booking creation screen
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Color(0xFF004D5B),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeController,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today,
                size: 60,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Bookings Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'You have no bookings in this category.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to booking creation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF004D5B),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                'Book a Service',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingData booking) {
    return GestureDetector(
      onTap: () => _showBookingDetails(context, booking),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Card header with date
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getHeaderColor(booking.status),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  // Date circle
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('dd').format(booking.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF004D5B),
                          ),
                        ),
                        Text(
                          DateFormat('MMM').format(booking.date),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF004D5B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Booking details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.serviceType,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              booking.time,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                booking.serviceCenter,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Favorite icon
                  IconButton(
                    icon: Icon(
                      booking.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: booking.isFavorite ? Colors.red : Colors.white70,
                    ),
                    onPressed: () => _toggleFavorite(booking),
                  ),
                ],
              ),
            ),

            // Card content with vehicle info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Vehicle icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: const Color(0xFF00B2CA),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Vehicle details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.vehicleModel,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xFF004D5B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.vehicleNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status chip
                  Chip(
                    label: Text(
                      booking.status.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: _getStatusColor(booking.status),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),

            // Footer with cost and action buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  // Cost
                  Text(
                    booking.cost,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF004D5B),
                    ),
                  ),
                  const Spacer(),
                  // Action buttons
                  if (booking.status == BookingStatus.upcoming)
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.edit,
                          color: const Color(0xFF00B2CA),
                          onPressed: () {
                            // Reschedule logic
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.cancel,
                          color: Colors.red.shade700,
                          onPressed: () {
                            // Cancel logic
                          },
                        ),
                      ],
                    ),
                  if (booking.status == BookingStatus.completed && (booking.rating ?? 0) == 0)
                    _buildActionButton(
                      icon: Icons.star,
                      color: const Color(0xFFFFB100),
                      onPressed: () {
                        // Rate service logic
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: color),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  Color _getHeaderColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return const Color(0xFF00B2CA);
      case BookingStatus.completed:
        return const Color(0xFF4CAF50);
      case BookingStatus.cancelled:
        return Colors.red.shade700;
    }
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return const Color(0xFF00B2CA);
      case BookingStatus.completed:
        return const Color(0xFF4CAF50);
      case BookingStatus.cancelled:
        return Colors.red.shade700;
    }
  }
}

// Data model
enum BookingStatus {
  upcoming,
  completed,
  cancelled,
}

class BookingData {
  final String id;
  final String serviceType;
  final String vehicleModel;
  final String vehicleNumber;
  final DateTime date;
  final String time;
  final BookingStatus status;
  final String cost;
  final String notes;
  final String serviceCenter;
  bool isFavorite;
  final int? rating;
  final String? cancellationReason;

  BookingData({
    required this.id,
    required this.serviceType,
    required this.vehicleModel,
    required this.vehicleNumber,
    required this.date,
    required this.time,
    required this.status,
    required this.cost,
    required this.notes,
    required this.serviceCenter,
    this.isFavorite = false,
    this.rating,
    this.cancellationReason,
  });
}