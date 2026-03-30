import 'package:flutter/material.dart';
import 'package:kiponnect/core/constants/app_colors.dart';
import 'package:kiponnect/presentation/widgets/common/avatar_widget.dart';
import 'package:kiponnect/presentation/widgets/navigation/kiponnect_bottom_nav_bar.dart';
import 'package:kiponnect/presentation/screens/messenger/chat_screen.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({Key? key}) : super(key: key);

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  final List<Map<String, dynamic>> _chats = [
    {
      'id': '1',
      'name': 'John Doe',
      'lastMessage': 'Sure, let\'s meet tomorrow!',
      'timestamp': '2 min',
      'isOnline': true,
      'unread': 2,
    },
    {
      'id': '2',
      'name': 'Study Group',
      'lastMessage': 'Mike: Who wants to study tonight?',
      'timestamp': '15 min',
      'isOnline': false,
      'unread': 0,
    },
    {
      'id': '3',
      'name': 'Sarah Smith',
      'lastMessage': 'Thanks for the notes!',
      'timestamp': '1 hour',
      'isOnline': true,
      'unread': 0,
    },
    {
      'id': '4',
      'name': 'Ivan Ivanov',
      'lastMessage': 'See you in class!',
      'timestamp': '2 hours',
      'isOnline': false,
      'unread': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text('Messenger'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('New message feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    chatName: chat['name'],
                    chatId: chat['id'],
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      AvatarWidget(
                        initials: chat['name']
                            .split(' ')
                            .map((word) => word[0])
                            .join()
                            .toUpperCase(),
                        size: 56,
                      ),
                      if (chat['isOnline'])
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.successGreen,
                              border: Border.all(
                                color: AppColors.darkSurface,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat['name'],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          chat['lastMessage'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat['timestamp'],
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                      ),
                      SizedBox(height: 4),
                      if (chat['unread'] > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${chat['unread']}',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: KiponnectBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index != 3) {
            if (index == 0) {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          }
        },
        items: [
          NavBarItem(icon: Icons.home, label: 'Home'),
          NavBarItem(icon: Icons.search, label: 'Search'),
          NavBarItem(icon: Icons.add, label: 'Create'),
          NavBarItem(icon: Icons.chat, label: 'Chats'),
          NavBarItem(icon: Icons.person, label: 'Profile'),
        ],
      ),
    );
  }
}
