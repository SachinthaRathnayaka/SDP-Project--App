import 'package:flutter/material.dart';
import 'dart:async';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _typingAnimationController;
  bool _isBotTyping = false;

  // List to store chat messages
  final List<ChatMessage> _messages = [];

  // Quick reply options
  final List<String> _quickReplies = [
    'Book a service',
    'Check service status',
    'Operating hours',
    'Service prices',
    'Contact information',
    'Vehicle repairs',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize typing animation controller
    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Add initial welcome message with delay to show typing animation
    _showBotTypingIndicator();

    Timer(const Duration(milliseconds: 1500), () {
      _hideBotTypingIndicator();
      _addBotMessage(
        "Hi there! 👋 I'm your SachiR Vehicle Care assistant. How can I help you today?",
      );

      // Add a second message with more details
      _showBotTypingIndicator();

      Timer(const Duration(milliseconds: 2000), () {
        _hideBotTypingIndicator();
        _addBotMessage(
          "You can ask me about our services, booking information, or tap one of the quick options below.",
        );
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUserMessage: false,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUserMessage: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
    });
    _scrollToBottom();

    // Show bot typing indicator and respond after a delay
    _showBotTypingIndicator();

    // Process user message and generate response
    Timer(const Duration(milliseconds: 1500), () {
      _hideBotTypingIndicator();
      _processUserMessage(text);
    });
  }

  void _scrollToBottom() {
    // Wait for the list to update before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showBotTypingIndicator() {
    setState(() {
      _isBotTyping = true;
    });
    _scrollToBottom();
  }

  void _hideBotTypingIndicator() {
    setState(() {
      _isBotTyping = false;
    });
  }

  void _processUserMessage(String message) {
    // Convert to lowercase for easier matching
    final lowerMessage = message.toLowerCase();

    // Simple pattern matching for responses
    if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('hey')) {
      _addBotMessage("Hello! How can I assist you with your vehicle needs today?");
    }
    else if (lowerMessage.contains('book') || lowerMessage.contains('appointment')) {
      _addBotMessage("Great! Here's how you can book a service with us:\n\n1. Select the service type you need\n2. Choose your preferred date and time\n3. Provide your vehicle details\n\nWould you like me to help you book a service now?");
    }
    else if (lowerMessage.contains('service') && (lowerMessage.contains('price') || lowerMessage.contains('cost'))) {
      _addBotMessage("Our service prices vary depending on the type of service and your vehicle model. Here are some starting prices:\n\n• Basic Service: Rs. 3,500\n• Full Service: Rs. 7,500\n• Premium Service: Rs. 12,000\n\nWould you like a detailed quote for your specific vehicle?");
    }
    else if (lowerMessage.contains('hour') || lowerMessage.contains('open') || lowerMessage.contains('time')) {
      _addBotMessage("Our operating hours are:\n\nMonday to Friday: 8:00 AM - 6:00 PM\nSaturday: 9:00 AM - 4:00 PM\nSunday: Closed\n\nFor emergency services, you can contact our 24/7 helpline at 076 6734993.");
    }
    else if (lowerMessage.contains('contact') || lowerMessage.contains('phone') || lowerMessage.contains('call')) {
      _addBotMessage("You can reach us through the following channels:\n\nPhone: 076 6734993\nEmail: info@sachir.lk\nAddress: 572, Kandy Road, Pattiya Junction, Peliyadoda, Keleniya");
    }
    else if (lowerMessage.contains('repair') || lowerMessage.contains('fix')) {
      _addBotMessage("We offer a wide range of repair services including:\n\n• Engine repairs\n• Brake system repairs\n• Electrical system repairs\n• Suspension and steering\n• Transmission repairs\n\nCan you tell me more about the issue you're experiencing with your vehicle?");
    }
    else if (lowerMessage.contains('modification') || lowerMessage.contains('custom')) {
      _addBotMessage("Our vehicle modification services include:\n\n• Performance upgrades\n• Custom exteriors\n• Interior customization\n• Audio system upgrades\n• Lighting enhancements\n\nDo you have a specific modification in mind?");
    }
    else if (lowerMessage.contains('clean') || lowerMessage.contains('wash') || lowerMessage.contains('detail')) {
      _addBotMessage("We offer several cleaning packages:\n\n• Express Wash: Rs. 1,500\n• Interior Detailing: Rs. 4,500\n• Exterior Detailing: Rs. 5,500\n• Full Detailing: Rs. 8,500\n\nWould you like to book a cleaning service?");
    }
    else if (lowerMessage.contains('status') || lowerMessage.contains('progress')) {
      _addBotMessage("To check the status of your service, please provide your booking reference number or the phone number used during booking.");
    }
    else if (lowerMessage.contains('thank')) {
      _addBotMessage("You're welcome! Is there anything else I can help you with today?");
    }
    else if (lowerMessage.contains('bye') ||
        lowerMessage.contains('goodbye') ||
        lowerMessage.contains('see you')) {
      _addBotMessage("Thank you for chatting with me! Feel free to come back if you have any more questions. Have a great day!");
    }
    else {
      _addBotMessage("I'm not sure I understand. Could you please rephrase your question or select one of the quick options below?");
    }
  }

  void _handleQuickReply(String reply) {
    // Add user message
    _addUserMessage(reply);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF004D5B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Image.asset(
                'lib/assets/SachiR_Vehicle_Care.png',
                width: 60,
                height: 60,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SachiR Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About SachiR Assistant'),
                  content: const Text(
                    'SachiR Assistant is here to help you with all your vehicle care needs. '
                        'Ask questions about our services, booking information, or anything else related to your vehicle maintenance.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isBotTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isBotTyping) {
                    return _buildTypingIndicator();
                  }
                  return _buildMessage(_messages[index]);
                },
              ),
            ),
          ),

          // Quick reply chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _quickReplies.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    backgroundColor: const Color(0xFFE0F7F9),
                    label: Text(
                      _quickReplies[index],
                      style: const TextStyle(
                        color: Color(0xFF004D5B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () => _handleQuickReply(_quickReplies[index]),
                  ),
                );
              },
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Color(0xFF004D5B)),
                  onPressed: () {
                    // Show attachment options
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Attachment feature coming soon...'),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask anything...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (value) {
                      _addUserMessage(value);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                CircleAvatar(
                  backgroundColor: const Color(0xFF0099B1),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () {
                      _addUserMessage(_messageController.text);
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

  Widget _buildMessage(ChatMessage message) {
    final isUser = message.isUserMessage;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Bot avatar (only for bot messages)
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: const Color(0xFF004D5B),
              radius: 16,
              child: Image.asset(
                'lib/assets/SachiR_Vehicle_Care.png',
                width: 22,
                height: 22,
                color:Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFF004D5B)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User avatar (only for user messages)
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF0099B1),
              radius: 16,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Bot avatar
          CircleAvatar(
            backgroundColor: const Color(0xFF004D5B),
            radius: 16,
            child: Image.asset(
              'lib/assets/SachiR_Vehicle_Care.png',
              width: 22,
              height: 22,
              color:Colors.white,
            ),
          ),
          const SizedBox(width: 8),

          // Typing indicator bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _typingAnimationController,
                  builder: (context, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        final delay = index * 0.3;
                        final position = _typingAnimationController.value - delay;
                        final opacity = position > 0.0 ? position : 0.0;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF004D5B).withOpacity(opacity.clamp(0.4, 1.0)),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class ChatMessage {
  final String text;
  final bool isUserMessage;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUserMessage,
    required this.timestamp,
  });
}