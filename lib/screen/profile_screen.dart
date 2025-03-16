import 'package:flutter/material.dart';
import '../models/profile_dto.dart';
import '../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileDTO profileData =
        ModalRoute.of(context)?.settings.arguments as ProfileDTO;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(profileData.imageName),
            ),
            const SizedBox(height: 24),
            Text(
              profileData.name,
              style: AppTheme.headingStyle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              profileData.email,
              style: AppTheme.subheadingStyle.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildInfoCard(profileData),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement edit profile functionality
              },
              style: AppTheme.elevatedButtonStyle,
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(ProfileDTO profile) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoRow(Icons.phone, 'Phone', profile.phone),
          const Divider(height: 24),
          _buildInfoRow(Icons.location_on, 'Address', profile.address),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.fingerprint,
            'Biometric Login',
            profile.biometric ? 'Enabled' : 'Disabled',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? 'Not provided' : value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
