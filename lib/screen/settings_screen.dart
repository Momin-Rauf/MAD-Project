import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Account',
            [
              _buildSettingItem(
                'Profile Settings',
                Icons.person_outline,
                onTap: () {},
              ),
              _buildSettingItem(
                'Privacy',
                Icons.lock_outline,
                onTap: () {},
              ),
              _buildSettingItem(
                'Security',
                Icons.security,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Preferences',
            [
              _buildSettingItem(
                'Notifications',
                Icons.notifications_none,
                onTap: () {},
              ),
              _buildSettingItem(
                'Appearance',
                Icons.palette_outlined,
                onTap: () {},
              ),
              _buildSettingItem(
                'Language',
                Icons.language,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Support',
            [
              _buildSettingItem(
                'Help Center',
                Icons.help_outline,
                onTap: () {},
              ),
              _buildSettingItem(
                'Contact Us',
                Icons.mail_outline,
                onTap: () {},
              ),
              _buildSettingItem(
                'About',
                Icons.info_outline,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: AppTheme.headingStyle.copyWith(fontSize: 20),
          ),
        ),
        Container(
          decoration: AppTheme.cardDecoration,
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(String title, IconData icon,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
