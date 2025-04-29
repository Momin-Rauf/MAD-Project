import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _sectionController;
  late AnimationController _buttonController;

  late Animation<double> _titleOpacity;
  late Animation<Offset> _sectionSlide;
  late Animation<double> _buttonScale;
  
  @override
  void initState() {
    super.initState();

    // Title fade animation
    _titleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeIn),
    );

    // Section slide animation
    _sectionController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _sectionSlide = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _sectionController, curve: Curves.easeOut),
    );

    // Button scale animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Start animations
    _titleController.forward();
    _sectionController.forward();
    _buttonController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _sectionController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: FadeTransition(
          opacity: _titleOpacity,
          child: const Text('Settings'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Account',
            [
              _buildSettingItem('Profile Settings', Icons.person_outline, onTap: () {}),
              _buildSettingItem('Privacy', Icons.lock_outline, onTap: () {}),
              _buildSettingItem('Security', Icons.security, onTap: () {}),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Preferences',
            [
              _buildSettingItem('Notifications', Icons.notifications_none, onTap: () {}),
              _buildSettingItem('Appearance', Icons.palette_outlined, onTap: () {}),
              _buildSettingItem('Language', Icons.language, onTap: () {}),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Support',
            [
              _buildSettingItem('Help Center', Icons.help_outline, onTap: () {}),
              _buildSettingItem('Contact Us', Icons.mail_outline, onTap: () {}),
              _buildSettingItem('About', Icons.info_outline, onTap: () {}),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ScaleTransition(
              scale: _buttonScale,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
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
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return SlideTransition(
      position: _sectionSlide,
      child: Column(
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
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, {required VoidCallback onTap}) {
    return FadeTransition(
      opacity: _titleOpacity,
      child: InkWell(
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
      ),
    );
  }
}
