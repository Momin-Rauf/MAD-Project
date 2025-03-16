import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/profile_dto.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileDTO profileData =
        ModalRoute.of(context)?.settings.arguments as ProfileDTO;

    // Hardcoded values for missing fields
    final Map<String, dynamic> additionalData = {
      'role': 'Software Developer',
      'joinDate': 'March 2024',
      'status': 'Active',
      'totalProjects': '15',
      'lastActive': 'Today',
    };

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(profileData.imageName),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      profileData.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      additionalData['role'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Personal Information'),
                  _buildInfoCard([
                    _buildInfoItem(Icons.email, 'Email', profileData.email),
                    _buildInfoItem(Icons.phone, 'Phone', profileData.phone),
                    _buildInfoItem(
                        Icons.location_on, 'Address', profileData.address),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Account Details'),
                  _buildInfoCard([
                    _buildInfoItem(Icons.calendar_today, 'Joined',
                        additionalData['joinDate']),
                    _buildInfoItem(
                        Icons.circle, 'Status', additionalData['status'],
                        customIcon: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        )),
                    _buildInfoItem(
                      Icons.fingerprint,
                      'Biometric Login',
                      profileData.biometric ? 'Enabled' : 'Disabled',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Activity'),
                  _buildInfoCard([
                    _buildInfoItem(Icons.folder, 'Total Projects',
                        additionalData['totalProjects']),
                    _buildInfoItem(Icons.access_time, 'Last Active',
                        additionalData['lastActive']),
                  ]),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value,
      {Widget? customIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: customIcon ?? Icon(icon, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
            onPressed: () {
              // TODO: Implement edit profile
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.security),
            label: const Text('Security Settings'),
            onPressed: () {
              // TODO: Implement security settings
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: AppTheme.primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}