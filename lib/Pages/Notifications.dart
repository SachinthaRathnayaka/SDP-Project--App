import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with TickerProviderStateMixin {
  // Tab controller for notification categories
  late TabController _tabController;

  // Controller for animations
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock notification data
  final List<NotificationItem> _allNotifications = [
    NotificationItem(
      id: 'n1',
      title: 'Service Reminder',
      message: 'Your Toyota Aqua is due for regular maintenance in 3 days.',
      dateTime: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.reminder,
      isRead: false,
      actionable: true,
      vehicle: 'Toyota Aqua (CBB 2017)',
    ),
    NotificationItem(
      id: 'n2',
      title: 'Payment Successful',
      message: 'Your payment of Rs. 5,500 for Full Service has been successfully processed.',
      dateTime: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.payment,
      isRead: true,
      reference: 'PAY-2025-001',
    ),
    NotificationItem(
      id: 'n3',
      title: 'Booking Confirmed',
      message: 'Your vehicle service booking for May 10, 2025 at 10:00 AM has been confirmed.',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.booking,
      isRead: false,
      actionable: true,
      reference: 'BK001',
    ),
    NotificationItem(
      id: 'n4',
      title: 'Special Offer',
      message: '20% discount on AC servicing this summer! Valid until June 30, 2025.',
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.promotion,
      isRead: true,
    ),
    NotificationItem(
      id: 'n5',
      title: 'Service Completed',
      message: 'Your vehicle service for Honda Civic has been completed. You can collect your vehicle.',
      dateTime: DateTime.now().subtract(const Duration(days: 3)),
      type: NotificationType.service,
      isRead: true,
      vehicle: 'Honda Civic (CAR 1234)',
    ),
    NotificationItem(
      id: 'n6',
      title: 'New Service Available',
      message: 'We now offer electric vehicle battery health checks. Book now!',
      dateTime: DateTime.now().subtract(const Duration(days: 5)),
      type: NotificationType.promotion,
      isRead: false,
      actionable: true,
    ),
    NotificationItem(
      id: 'n7',
      title: 'Booking Reminder',
      message: 'Reminder: Your vehicle service is scheduled for tomorrow at 2:30 PM.',
      dateTime: DateTime.now().subtract(const Duration(days: 6)),
      type: NotificationType.reminder,
      isRead: true,
      reference: 'BK002',
    ),
  ];

  List<NotificationItem> _filteredNotifications = [];
  bool _showOnlyUnread = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Initialize tab controller
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Initialize filtered notifications
    _filteredNotifications = List.from(_allNotifications);

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      _filterNotifications();
    }
  }

  void _filterNotifications() {
    setState(() {
      // Reset animation
      _animationController.reset();

      // Filter by category (tab)
      switch (_tabController.index) {
        case 0: // All
          _filteredNotifications = List.from(_allNotifications);
          break;
        case 1: // Reminders
          _filteredNotifications = _allNotifications
              .where((n) => n.type == NotificationType.reminder)
              .toList();
          break;
        case 2: // Bookings
          _filteredNotifications = _allNotifications
              .where((n) => n.type == NotificationType.booking)
              .toList();
          break;
        case 3: // Payments
          _filteredNotifications = _allNotifications
              .where((n) => n.type == NotificationType.payment)
              .toList();
          break;
        case 4: // Promotions
          _filteredNotifications = _allNotifications
              .where((n) => n.type == NotificationType.promotion)
              .toList();
          break;
      }

      // Filter by read status if needed
      if (_showOnlyUnread) {
        _filteredNotifications = _filteredNotifications
            .where((n) => !n.isRead)
            .toList();
      }

      // Start animation
      _animationController.forward();
    });
  }

  void _toggleReadFilter() {
    setState(() {
      _showOnlyUnread = !_showOnlyUnread;
      _filterNotifications();
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification.isRead = true;
      }
      _filterNotifications();
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _markAsRead(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  void _deleteNotification(NotificationItem notification) {
    setState(() {
      _allNotifications.remove(notification);
      _filterNotifications();
    });

    // Show confirmation with undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allNotifications.add(notification);
              _filterNotifications();
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showNotificationDetails(NotificationItem notification) {
    // Mark as read when opened
    if (!notification.isRead) {
      _markAsRead(notification);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildNotificationDetailsSheet(notification),
    );
  }

  Widget _buildNotificationDetailsSheet(NotificationItem notification) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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

              // Header with icon and title
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getNotificationColor(notification.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getNotificationIcon(notification.type),
                        color: _getNotificationColor(notification.type),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004D5B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getFormattedDate(notification.dateTime),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Notification content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Message
                    Text(
                      notification.message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Additional details
                    if (notification.vehicle != null) ...[
                      _buildDetailRow(
                        icon: Icons.directions_car,
                        label: 'Vehicle',
                        value: notification.vehicle!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (notification.reference != null) ...[
                      _buildDetailRow(
                        icon: Icons.receipt_long,
                        label: 'Reference',
                        value: notification.reference!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Type-specific details
                    if (notification.type == NotificationType.reminder) ...[
                      _buildDetailRow(
                        icon: Icons.event,
                        label: 'Type',
                        value: 'Service Reminder',
                      ),
                    ] else if (notification.type == NotificationType.booking) ...[
                      _buildDetailRow(
                        icon: Icons.event,
                        label: 'Type',
                        value: 'Booking Notification',
                      ),
                    ] else if (notification.type == NotificationType.payment) ...[
                      _buildDetailRow(
                        icon: Icons.payment,
                        label: 'Type',
                        value: 'Payment Notification',
                      ),
                    ],

                    const SizedBox(height: 30),

                    // Action buttons
                    if (notification.actionable) ...[
                      ElevatedButton(
                        onPressed: () {
                          // Handle action based on notification type
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
                        child: Text(
                          _getActionButtonText(notification.type),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],

                    // Delete button
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteNotification(notification);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade700),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Delete Notification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  String _getActionButtonText(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return 'Book Service';
      case NotificationType.booking:
        return 'View Booking';
      case NotificationType.payment:
        return 'View Payment';
      case NotificationType.promotion:
        return 'View Offer';
      case NotificationType.service:
        return 'View Details';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Count unread notifications
    final unreadCount = _allNotifications.where((n) => !n.isRead).length;

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
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Mark all as read button
                    if (unreadCount > 0)
                      CircleAvatar(
                        backgroundColor: Colors.white.withAlpha(128),
                        child: IconButton(
                          icon: const Icon(Icons.done_all, color: Colors.black, size: 18),
                          onPressed: _markAllAsRead,
                          tooltip: 'Mark all as read',
                        ),
                      )
                    else
                      const SizedBox(width: 40), // Placeholder for balance
                  ],
                ),
              ),

              // Notification summary
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Unread count
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: unreadCount > 0 ? Colors.red : Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            unreadCount > 0
                                ? '$unreadCount unread'
                                : 'All read',
                            style: TextStyle(
                              color: const Color(0xFF004D5B),
                              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Filter toggle
                    GestureDetector(
                      onTap: _toggleReadFilter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _showOnlyUnread
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: const Color(0xFF004D5B),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Unread only',
                              style: TextStyle(
                                color: const Color(0xFF004D5B),
                                fontWeight: _showOnlyUnread ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
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
                  isScrollable: true,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: const Color(0xFF004D5B),
                  unselectedLabelColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Reminders'),
                    Tab(text: 'Bookings'),
                    Tab(text: 'Payments'),
                    Tab(text: 'Promotions'),
                  ],
                ),
              ),

              // Notifications list
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _filteredNotifications.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification, index);
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 70,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _showOnlyUnread
                  ? 'You have no unread notifications'
                  : 'You have no notifications in this category',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, int index) {
    // Calculate delay based on index for staggered animation
    final delay = index * 0.1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: () => _showNotificationDetails(notification),
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Notification content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _getNotificationColor(notification.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getNotificationIcon(notification.type),
                      color: _getNotificationColor(notification.type),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Notification text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF004D5B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getFormattedDate(notification.dateTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // More options
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey.shade700,
                    ),
                    onSelected: (value) {
                      if (value == 'read') {
                        _markAsRead(notification);
                      } else if (value == 'delete') {
                        _deleteNotification(notification);
                      }
                    },
                    itemBuilder: (context) => [
                      if (!notification.isRead)
                        const PopupMenuItem(
                          value: 'read',
                          child: Text('Mark as read'),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Unread indicator
            if (!notification.isRead)
              Positioned(
                top: 16,
                left: 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getFormattedDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return Icons.notification_important;
      case NotificationType.booking:
        return Icons.calendar_today;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.promotion:
        return Icons.local_offer;
      case NotificationType.service:
        return Icons.build;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.booking:
        return const Color(0xFF00B2CA);
      case NotificationType.payment:
        return Colors.green;
      case NotificationType.promotion:
        return Colors.purple;
      case NotificationType.service:
        return Colors.blue;
    }
  }
}

// Data models
enum NotificationType {
  reminder,
  booking,
  payment,
  promotion,
  service,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime dateTime;
  final NotificationType type;
  bool isRead;
  final bool actionable;
  final String? reference;
  final String? vehicle;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.dateTime,
    required this.type,
    this.isRead = false,
    this.actionable = false,
    this.reference,
    this.vehicle,
  });
}