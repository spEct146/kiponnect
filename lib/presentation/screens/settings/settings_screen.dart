import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiponnect/core/constants/app_colors.dart';
import 'package:kiponnect/presentation/providers/local_data_provider.dart';
import 'package:kiponnect/presentation/providers/localization_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true; // Default to dark mode as per design

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Consumer2<LocalDataProvider, LocalizationProvider>(
        builder: (context, localDataProvider, localizationProvider, child) {
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Account Section
              _SettingsSection(
                title: 'Account',
                children: [
                  _SettingsTile(
                    icon: Icons.person,
                    title: 'Profile',
                    subtitle: 'Manage your profile information',
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.logout,
                    title: 'Sign Out',
                    subtitle: 'Sign out of your account',
                    onTap: () {
                      _showSignOutDialog(context);
                    },
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              // Preferences Section
              _SettingsSection(
                title: 'Preferences',
                children: [
                  _SettingsTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: localDataProvider.language == 'en' ? 'English' : 'Русский',
                    trailing: DropdownButton<String>(
                      value: localDataProvider.language,
                      dropdownColor: AppColors.darkSurface,
                      style: TextStyle(color: Colors.white),
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'ru',
                          child: Text('Русский'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          localDataProvider.setLanguage(value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Language changed to ${value == 'en' ? 'English' : 'Русский'}')),
                          );
                        }
                      },
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    subtitle: _darkMode ? 'Enabled' : 'Disabled',
                    trailing: Switch(
                      value: _darkMode,
                      activeColor: AppColors.primaryOrange,
                      onChanged: (value) {
                        setState(() {
                          _darkMode = value;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Dark mode ${value ? 'enabled' : 'disabled'}')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              // Data Management Section
              _SettingsSection(
                title: 'Data Management',
                children: [
                  _SettingsTile(
                    icon: Icons.clear_all,
                    title: 'Clear Cache',
                    subtitle: 'Clear all local posts and data',
                    onTap: () {
                      _showClearCacheDialog(context, localDataProvider);
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.storage,
                    title: 'Storage Usage',
                    subtitle: 'Manage app storage',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Storage management coming soon!')),
                      );
                    },
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              // About Section
              _SettingsSection(
                title: 'About',
                children: [
                  _SettingsTile(
                    icon: Icons.info,
                    title: 'About Kiponnect',
                    subtitle: 'Version 1.0.0',
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.help,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Help & Support coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
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

  void _showClearCacheDialog(BuildContext context, LocalDataProvider localDataProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text('Clear Cache'),
        content: Text('This will delete all your local posts and data. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await localDataProvider.clearAllPosts();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cache cleared successfully!')),
              );
            },
            child: Text(
              'Clear',
              style: TextStyle(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Kiponnect',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Kiponnect. A private social network for college students.',
      children: [
        SizedBox(height: 16),
        Text(
          'Kiponnect connects college students in a private, secure environment to share knowledge, collaborate, and build community.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryOrange,
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryOrange.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryOrange,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: trailing ?? (onTap != null ? Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary) : null),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}