import 'package:flutter/material.dart';
import 'package:kiponnect/core/constants/app_colors.dart';
import 'package:kiponnect/presentation/widgets/navigation/kiponnect_bottom_nav_bar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDay = 0;
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final List<Map<String, dynamic>> _classes = [
    {
      'time': '09:00 - 10:30',
      'subject': 'Data Structures',
      'room': '301',
      'teacher': 'Dr. Smith',
      'isCurrent': true,
    },
    {
      'time': '11:00 - 12:30',
      'subject': 'Algorithms',
      'room': '305',
      'teacher': 'Prof. Johnson',
      'isCurrent': false,
    },
    {
      'time': '14:00 - 15:30',
      'subject': 'Database Design',
      'room': '201',
      'teacher': 'Dr. Williams',
      'isCurrent': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text('Smart Schedule'),
      ),
      body: Column(
        children: [
          // Day Selector
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedDay;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedDay = index);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryOrange
                          : AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: !isSelected
                          ? Border.all(color: AppColors.borderColor)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _days[index],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${15 + index}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12),
          // Classes List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                final classItem = _classes[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: classItem['isCurrent']
                        ? Border.all(
                            color: AppColors.primaryOrange,
                            width: 2,
                          )
                        : Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            classItem['time'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: classItem['isCurrent']
                                      ? AppColors.primaryOrange
                                      : AppColors.textPrimary,
                                ),
                          ),
                          if (classItem['isCurrent'])
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryOrange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Now',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        classItem['subject'],
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Room ${classItem['room']}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            classItem['teacher'],
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: KiponnectBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed('/home');
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
