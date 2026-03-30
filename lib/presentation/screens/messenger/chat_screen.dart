import 'package:flutter/material.dart';
import 'package:kiponnect/core/constants/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String chatName;
  final String chatId;

  const ChatScreen({
    Key? key,
    required this.chatName,
    required this.chatId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load mock messages based on chat
    _loadMockMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMockMessages() {
    if (widget.chatId == '1') {
      _messages.addAll([
        {
          'id': '1',
          'sender': 'John Doe',
          'content': 'Hey! How are you doing?',
          'timestamp': DateTime.now().subtract(Duration(minutes: 5)),
          'isMe': false,
        },
        {
          'id': '2',
          'sender': 'You',
          'content': 'I\'m good! Just studying for the exam. You?',
          'timestamp': DateTime.now().subtract(Duration(minutes: 4)),
          'isMe': true,
        },
        {
          'id': '3',
          'sender': 'John Doe',
          'content': 'Same here. The algorithms class is killing me 😅',
          'timestamp': DateTime.now().subtract(Duration(minutes: 3)),
          'isMe': false,
        },
      ]);
    } else if (widget.chatId == '2') {
      _messages.addAll([
        {
          'id': '1',
          'sender': 'Study Group',
          'content': 'Hey everyone! Who wants to study tonight?',
          'timestamp': DateTime.now().subtract(Duration(hours: 2)),
          'isMe': false,
        },
        {
          'id': '2',
          'sender': 'You',
          'content': 'I\'m in! What time were you thinking?',
          'timestamp': DateTime.now().subtract(Duration(hours: 1)),
          'isMe': true,
        },
        {
          'id': '3',
          'sender': 'Mike',
          'content': '8 PM at the library?',
          'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
          'isMe': false,
        },
      ]);
    } else {
      // Default messages for other chats
      _messages.addAll([
        {
          'id': '1',
          'sender': widget.chatName,
          'content': 'Hello! Thanks for connecting.',
          'timestamp': DateTime.now().subtract(Duration(hours: 1)),
          'isMe': false,
        },
      ]);
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'sender': 'You',
          'content': _messageController.text.trim(),
          'timestamp': DateTime.now(),
          'isMe': true,
        });
      });
      _messageController.clear();
      
      // Scroll to bottom
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inHours > 0) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryOrange,
              ),
              child: Center(
                child: Text(
                  widget.chatName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Active now',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.successGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Show chat options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['isMe'] as bool;
                
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isMe) ...[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryOrange,
                          ),
                          child: Center(
                            child: Text(
                              message['sender'].substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isMe ? AppColors.primaryOrange : AppColors.darkSurface,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(isMe ? 20 : 4),
                              topRight: Radius.circular(isMe ? 4 : 20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe && widget.chatId == '2') // Show sender name for group chats
                                Text(
                                  message['sender'],
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.primaryOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(
                                message['content'],
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _formatTimestamp(message['timestamp']),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isMe) ...[
                        SizedBox(width: 8),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryOrange.withOpacity(0.3),
                          ),
                          child: Center(
                            child: Text(
                              'Y',
                              style: TextStyle(
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Message Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              border: Border(top: BorderSide(color: AppColors.borderColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppColors.primaryOrange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppColors.primaryOrange),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppColors.primaryOrange, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryOrange,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
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