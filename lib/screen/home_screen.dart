import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/profile_dto.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const HomeScreen({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome,',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  userData['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(userData['imageName']),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildRecentUpdates(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.headingStyle.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildActionCard(
              'Profile',
              Icons.person,
              AppTheme.primaryColor,
              onTap: () => Navigator.pushNamed(
                context,
                '/profile',
                arguments: ProfileDTO(
                  name: userData['name'],
                  imageName: userData['imageName'],
                  phone: userData['phone'] ?? '',
                  email: userData['email'] ?? '',
                  biometric: userData['biometric'] ?? false,
                  address: userData['address'] ?? '',
                ),
              ),
            ),
            _buildActionCard(
              'Messages',
              Icons.message,
              AppTheme.secondaryColor,
              onTap: () => Navigator.pushNamed(context, '/chat'),
            ),
            _buildActionCard(
              'Settings',
              Icons.settings,
              Colors.purple,
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            _buildActionCard(
              'Help',
              Icons.help,
              Colors.teal,
              onTap: () {
                // TODO: Implement help functionality
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: AppTheme.cardDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentUpdates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Updates',
          style: AppTheme.headingStyle.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: AppTheme.cardDecoration,
          child: Column(
            children: [
              _buildUpdateItem(
                'Profile Updated',
                'Your profile information has been updated successfully',
                Icons.person,
                AppTheme.primaryColor,
              ),
              const Divider(),
              _buildUpdateItem(
                'New Message',
                'You have a new message from the support team',
                Icons.message,
                AppTheme.secondaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateItem(
      String title, String subtitle, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
