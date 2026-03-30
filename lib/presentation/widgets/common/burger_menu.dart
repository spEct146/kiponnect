import 'package:flutter/material.dart';
import 'package:kiponnect/core/constants/app_colors.dart';
import 'package:kiponnect/presentation/screens/settings/settings_screen.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkBackground,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(24),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryOrange,
                    ),
                    child: Center(
                      child: Text(
                        'K',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Kiponnect',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'v1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.borderColor),
            // Menu Items
            Expanded(
              child: ListView(
                children: [
                  _MenuItemTile(
                    icon: Icons.map,
                    label: 'Campus Maps',
                    onTap: () {
                      Navigator.pop(context);
                      _showFeatureAlert(context, 'Campus Maps');
                    },
                  ),
                  _MenuItemTile(
                    icon: Icons.radio,
                    label: 'College FM',
                    onTap: () {
                      Navigator.pop(context);
                      _showFeatureAlert(context, 'College FM');
                    },
                  ),
                  _MenuItemTile(
                    icon: Icons.announcement,
                    label: 'Bulletin Board 2.0',
                    onTap: () {
                      Navigator.pop(context);
                      _showFeatureAlert(context, 'Bulletin Board 2.0');
                    },
                  ),
                  Divider(color: AppColors.borderColor, height: 24),
                  _MenuItemTile(
                    icon: Icons.help,
                    label: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                      _showFeatureAlert(context, 'Help & Support');
                    },
                  ),
                  _MenuItemTile(
                    icon: Icons.info,
                    label: 'About Kiponnect',
                    onTap: () {
                      Navigator.pop(context);
                      _showAboutDialog(context);
                    },
                  ),
                  _MenuItemTile(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Footer
            Divider(color: AppColors.borderColor),
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MenuItemTile(
                    icon: Icons.logout,
                    label: 'Sign Out',
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutDialog(context);
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Made for Students, By Students',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureAlert(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: AppColors.infoBlue,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Kiponnect',
      applicationVersion: '1.0.0',
      applicationLegalese:
          '© 2024 Kiponnect. A private social network for college students.',
      children: [
        SizedBox(height: 16),
        Text(
          'Kiponnect connects college students in a private, secure environment to share knowledge, collaborate, and build community.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItemTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primaryOrange,
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}
