import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiponnect/core/constants/app_colors.dart';
import 'package:kiponnect/presentation/providers/local_data_provider.dart';
import 'package:kiponnect/presentation/widgets/common/avatar_widget.dart';
import 'package:kiponnect/presentation/widgets/navigation/kiponnect_bottom_nav_bar.dart';
import 'package:kiponnect/presentation/screens/profile/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalDataProvider>(
      builder: (context, localDataProvider, child) {
        final userProfile = localDataProvider.userProfile;
        final fullName = userProfile['fullName'] ?? 'John Doe';
        final department = userProfile['department'] ?? 'Computer Science';
        final year = userProfile['year'] ?? 3;
        
        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: CustomScrollView(
            slivers: [
              // Header with Avatar and Info
              SliverAppBar(
                expandedHeight: 280,
                backgroundColor: AppColors.darkBackground,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: AppColors.darkBackground,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AvatarWidget(
                          initials: fullName.split(' ').map((word) => word[0]).join().toUpperCase(),
                          size: 100,
                        ),
                        SizedBox(height: 16),
                        Text(
                          fullName,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '$department • Year $year',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        SizedBox(height: 16),
                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatColumn(
                              value: '${userProfile['postsCount'] ?? 0}',
                              label: 'Posts',
                            ),
                            _StatColumn(
                              value: '${userProfile['followersCount'] ?? 0}',
                              label: 'Followers',
                            ),
                            _StatColumn(
                              value: '${userProfile['followingCount'] ?? 0}',
                              label: 'Following',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          // Action Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showEditProfileBottomSheet(context, localDataProvider);
                      },
                      child: Text('Edit Profile'),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkSurface,
                      foregroundColor: AppColors.primaryOrange,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {},
                    child: Icon(Icons.share),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkSurface,
                      foregroundColor: AppColors.primaryOrange,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Settings coming soon!')),
                      );
                    },
                    child: Icon(Icons.settings),
                  ),
                ],
              ),
            ),
          ),
          // Achievements
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Achievements',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(right: 12),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: AppColors.primaryOrange,
                              size: 24,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Badge ${index + 1}',
                              style:
                                  Theme.of(context).textTheme.labelSmall,
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
          // Tab Bar for Posts/Notes/Schedule
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.darkBackground,
            toolbarHeight: 0,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryOrange,
              tabs: [
                Tab(text: 'My Posts'),
                Tab(text: 'Saved Notes'),
                Tab(text: 'Schedule'),
              ],
            ),
          ),
          // Tab Views
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // My Posts
                ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: 3,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Just completed my project!',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '2 hours ago',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Saved Notes
                ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: 4,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Chapter ${index + 1}: Advanced Topics',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                // Schedule
                ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: 3,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Structures - ${9 + index}:00',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Room 301 - Dr. Smith',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: KiponnectBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          if (index != 4) {
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
  },
    );
  }

  void _showEditProfileBottomSheet(BuildContext context, LocalDataProvider localDataProvider) {
    final userProfile = localDataProvider.userProfile;
    String fullName = userProfile['fullName'] ?? 'John Doe';
    String department = userProfile['department'] ?? 'Computer Science';
    int year = userProfile['year'] ?? 3;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 24),
              // Title
              Text(
                'Edit Profile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 24),
              // Avatar Section
              Center(
                child: Stack(
                  children: [
                    AvatarWidget(
                      initials: fullName.split(' ').map((word) => word[0]).join().toUpperCase(),
                      size: 80,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Name Field
              TextField(
                controller: TextEditingController(text: fullName),
                onChanged: (value) => fullName = value,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.darkSurfaceVariant,
                ),
                style: TextStyle(color: AppColors.textPrimary),
              ),
              SizedBox(height: 16),
              // Department Field
              TextField(
                controller: TextEditingController(text: department),
                onChanged: (value) => department = value,
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.darkSurfaceVariant,
                ),
                style: TextStyle(color: AppColors.textPrimary),
              ),
              SizedBox(height: 16),
              // Year Field
              DropdownButtonFormField<int>(
                value: year,
                onChanged: (value) => setState(() => year = value ?? 3),
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.darkSurfaceVariant,
                ),
                dropdownColor: AppColors.darkSurface,
                style: TextStyle(color: AppColors.textPrimary),
                items: [1, 2, 3, 4, 5].map((y) => DropdownMenuItem(
                  value: y,
                  child: Text('Year $y'),
                )).toList(),
              ),
              SizedBox(height: 24),
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    localDataProvider.updateUserProfile({
                      'fullName': fullName,
                      'department': department,
                      'year': year,
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Save Changes'),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _StatColumn({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOrange,
              ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
